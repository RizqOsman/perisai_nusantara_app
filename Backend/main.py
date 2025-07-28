from fastapi import FastAPI, Depends, HTTPException, status, UploadFile, File, Form
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from typing import List
import uuid
from datetime import datetime, timedelta
import base64
from io import BytesIO
from PIL import Image

from database import engine, get_db
import models
import schemas
import auth
import utils

# Create database tables
models.Base.metadata.create_all(bind=engine)

app = FastAPI(title="Perisai Nusantara API", version="1.0.0")

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Authentication endpoints
@app.post("/login-anggota")
def login_anggota(user_credentials: schemas.UserLogin, db: Session = Depends(get_db)):
    user = auth.authenticate_user(db, user_credentials.email, user_credentials.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    access_token_expires = timedelta(minutes=auth.ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = auth.create_access_token(
        data={"sub": user.email}, expires_delta=access_token_expires
    )
    
    return {
        "user": {
            "nip": user.nip,
            "name": user.name,
            "id_site": user.id_site,
            "site": user.site,
            "id_position": user.id_position,
            "email": user.email,
            "password": user.password,
            "status": user.status
        }
    }

# Buku Tamu endpoints
@app.post("/daftar-tamu")
def create_buku_tamu(
    no_visitor: str = Form(...),
    tanggal: str = Form(...),
    nama: str = Form(...),
    telepon: str = Form(...),
    alamat: str = Form(...),
    keperluan: str = Form(...),
    foto: str = Form(...),
    filename: str = Form(...),
    db: Session = Depends(get_db)
):
    # Generate visitor number if not provided
    if not no_visitor or no_visitor == "no_visitor":
        no_visitor = utils.generate_visitor_number()
    
    # Parse and validate date
    tanggal_dt = utils.parse_datetime_string(tanggal)
    
    # Compress image if provided
    if foto:
        foto = utils.compress_image_base64(foto)
    
    # Format phone number
    telepon = utils.format_phone_number(telepon)
    
    db_buku_tamu = models.BukuTamu(
        no_visitor=no_visitor,
        tanggal=tanggal_dt,
        nama=nama,
        telepon=telepon,
        alamat=alamat,
        keperluan=keperluan,
        foto=foto,
        filename=filename,
        created_by=1  # Default user ID, should be from token
    )
    db.add(db_buku_tamu)
    db.commit()
    db.refresh(db_buku_tamu)
    return {"message": "Buku tamu berhasil ditambahkan", "id": db_buku_tamu.id, "no_visitor": no_visitor}

@app.get("/buku-tamu", response_model=List[schemas.BukuTamu])
def get_buku_tamu(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    buku_tamu = db.query(models.BukuTamu).offset(skip).limit(limit).all()
    return buku_tamu

# Buku Paket endpoints
@app.post("/daftar-paket")
def create_buku_paket(
    id_paket: str = Form(...),
    tanggal: str = Form(...),
    nama_penerima: str = Form(...),
    barang: str = Form(...),
    kurir: str = Form(...),
    nama_petugas: str = Form(...),
    foto: str = Form(...),
    db: Session = Depends(get_db)
):
    # Generate package ID if not provided
    if not id_paket or id_paket == "id_paket":
        id_paket = utils.generate_package_id()
    
    # Parse and validate date
    tanggal_dt = utils.parse_datetime_string(tanggal)
    
    # Compress image if provided
    if foto:
        foto = utils.compress_image_base64(foto)
    
    db_buku_paket = models.BukuPaket(
        id_paket=id_paket,
        tanggal=tanggal_dt,
        nama_penerima=nama_penerima,
        barang=barang,
        kurir=kurir,
        nama_petugas=nama_petugas,
        foto=foto,
        created_by=1  # Default user ID, should be from token
    )
    db.add(db_buku_paket)
    db.commit()
    db.refresh(db_buku_paket)
    return {"message": "Buku paket berhasil ditambahkan", "id": db_buku_paket.id, "id_paket": id_paket}

@app.get("/buku-paket", response_model=List[schemas.BukuPaket])
def get_buku_paket(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    buku_paket = db.query(models.BukuPaket).offset(skip).limit(limit).all()
    return buku_paket

# Laporan endpoints
@app.post("/laporan")
def create_laporan(
    laporanid: str = Form(...),
    nama: str = Form(...),
    laporan: str = Form(...),
    tanggal: str = Form(...),
    foto: str = Form(...),
    db: Session = Depends(get_db)
):
    # Generate report ID if not provided
    if not laporanid or laporanid == "laporanid":
        laporanid = utils.generate_report_id()
    
    # Parse and validate date
    tanggal_dt = utils.parse_datetime_string(tanggal)
    
    # Compress image if provided
    if foto:
        foto = utils.compress_image_base64(foto)
    
    db_laporan = models.Laporan(
        laporanid=laporanid,
        nama=nama,
        laporan=laporan,
        tanggal=tanggal_dt,
        foto=foto,
        created_by=1  # Default user ID, should be from token
    )
    db.add(db_laporan)
    db.commit()
    db.refresh(db_laporan)
    return {"message": "Laporan berhasil ditambahkan", "id": db_laporan.id, "laporanid": laporanid}

@app.get("/laporan", response_model=List[schemas.Laporan])
def get_laporan(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    laporan = db.query(models.Laporan).offset(skip).limit(limit).all()
    return laporan

# Activity endpoints
@app.post("/activity")
def create_activity(
    activityid: str = Form(...),
    name: str = Form(...),
    activity: str = Form(...),
    images: str = Form(...),
    datetime: str = Form(...),
    db: Session = Depends(get_db)
):
    # Generate activity ID if not provided
    if not activityid or activityid == "activityid":
        activityid = utils.generate_activity_id()
    
    # Parse and validate datetime
    datetime_dt = utils.parse_datetime_string(datetime)
    
    # Compress image if provided
    if images:
        images = utils.compress_image_base64(images)
    
    db_activity = models.Activity(
        activityid=activityid,
        name=name,
        activity=activity,
        images=images,
        datetime=datetime_dt,
        created_by=1  # Default user ID, should be from token
    )
    db.add(db_activity)
    db.commit()
    db.refresh(db_activity)
    return {"message": "Activity berhasil ditambahkan", "id": db_activity.id, "activityid": activityid}

@app.get("/activity", response_model=List[schemas.Activity])
def get_activity(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    activities = db.query(models.Activity).offset(skip).limit(limit).all()
    return activities

# Emergency Contact endpoints
@app.post("/emergency-contact", response_model=schemas.EmergencyContact)
def create_emergency_contact(
    emergency_contact: schemas.EmergencyContactCreate,
    db: Session = Depends(get_db)
):
    db_contact = models.EmergencyContact(**emergency_contact.dict())
    db.add(db_contact)
    db.commit()
    db.refresh(db_contact)
    return db_contact

@app.get("/emergency-contact", response_model=List[schemas.EmergencyContact])
def get_emergency_contacts(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    contacts = db.query(models.EmergencyContact).offset(skip).limit(limit).all()
    return contacts

# Attendance endpoints
@app.post("/attendance")
def create_attendance(
    nik: str = Form(...),
    tagid: str = Form(...),
    checkin: str = Form(...),
    db: Session = Depends(get_db)
):
    checkin_bool = checkin.lower() == "true" or checkin == "1"
    
    db_attendance = models.Attendance(
        nik=nik,
        tagid=tagid,
        checkin=checkin_bool
    )
    db.add(db_attendance)
    db.commit()
    db.refresh(db_attendance)
    return {"message": "Attendance berhasil dicatat", "id": db_attendance.id}

@app.get("/attendance", response_model=List[schemas.Attendance])
def get_attendance(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    attendance = db.query(models.Attendance).offset(skip).limit(limit).all()
    return attendance

# Accident Report endpoints
@app.post("/accident-report")
def create_accident_report(
    nik_reporter: str = Form(...),
    the_time: str = Form(...),
    the_date: str = Form(...),
    title: str = Form(...),
    id_site: int = Form(...),
    related_figure: str = Form(...),
    figures_remark: str = Form(...),
    chronology: str = Form(...),
    taken_action: str = Form(...),
    image: str = Form(...),
    db: Session = Depends(get_db)
):
    db_accident = models.AccidentReport(
        nik_reporter=nik_reporter,
        the_time=the_time,
        the_date=the_date,
        title=title,
        id_site=id_site,
        related_figure=related_figure,
        figures_remark=figures_remark,
        chronology=chronology,
        taken_action=taken_action,
        image=image
    )
    db.add(db_accident)
    db.commit()
    db.refresh(db_accident)
    return {"message": "Accident report berhasil ditambahkan", "id": db_accident.id}

@app.get("/accident-report", response_model=List[schemas.AccidentReport])
def get_accident_reports(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    accidents = db.query(models.AccidentReport).offset(skip).limit(limit).all()
    return accidents

# User management endpoints
@app.post("/users", response_model=schemas.User)
def create_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    hashed_password = auth.get_password_hash(user.password)
    db_user = models.User(
        nip=user.nip,
        name=user.name,
        email=user.email,
        password=hashed_password,
        id_site=user.id_site,
        site=user.site,
        id_position=user.id_position,
        status=user.status
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

@app.get("/users", response_model=List[schemas.User])
def get_users(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    users = db.query(models.User).offset(skip).limit(limit).all()
    return users

# Health check endpoint
@app.get("/")
def read_root():
    return {"message": "Perisai Nusantara API is running"}

# Initialize database with sample data
@app.post("/init-db")
def initialize_database(db: Session = Depends(get_db)):
    # Create sample emergency contacts
    sample_contacts = [
        {"nama": "Polisi", "no_telepon": "110", "service": "Kepolisian", "alamat": "Jakarta"},
        {"nama": "Pemadam Kebakaran", "no_telepon": "113", "service": "Pemadam Kebakaran", "alamat": "Jakarta"},
        {"nama": "Ambulans", "no_telepon": "118", "service": "Layanan Medis", "alamat": "Jakarta"},
    ]
    
    for contact_data in sample_contacts:
        existing = db.query(models.EmergencyContact).filter(
            models.EmergencyContact.no_telepon == contact_data["no_telepon"]
        ).first()
        if not existing:
            contact = models.EmergencyContact(**contact_data)
            db.add(contact)
    
    # Create sample user
    existing_user = db.query(models.User).filter(models.User.email == "admin@perisai.com").first()
    if not existing_user:
        hashed_password = auth.get_password_hash("admin123")
        user = models.User(
            nip="12345",
            name="Administrator",
            email="admin@perisai.com",
            password=hashed_password,
            id_site=1,
            site="Jakarta",
            id_position=1,
            status="active"
        )
        db.add(user)
    
    db.commit()
    return {"message": "Database initialized with sample data"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000) 