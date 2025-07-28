from sqlalchemy import Column, Integer, String, DateTime, Text, Boolean, ForeignKey
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from database import Base

class User(Base):
    __tablename__ = "users"
    
    id = Column(Integer, primary_key=True, index=True)
    nip = Column(String, unique=True, index=True)
    name = Column(String)
    email = Column(String, unique=True, index=True)
    password = Column(String)
    id_site = Column(Integer)
    site = Column(String)
    id_position = Column(Integer)
    status = Column(String, default="active")
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

class BukuTamu(Base):
    __tablename__ = "buku_tamu"
    
    id = Column(Integer, primary_key=True, index=True)
    no_visitor = Column(String, unique=True, index=True)
    tanggal = Column(DateTime)
    nama = Column(String)
    telepon = Column(String)
    alamat = Column(Text)
    keperluan = Column(Text)
    foto = Column(Text)  # Base64 encoded image
    filename = Column(String)
    created_by = Column(Integer, ForeignKey("users.id"))
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    
    user = relationship("User")

class BukuPaket(Base):
    __tablename__ = "buku_paket"
    
    id = Column(Integer, primary_key=True, index=True)
    id_paket = Column(String, unique=True, index=True)
    tanggal = Column(DateTime)
    nama_penerima = Column(String)
    barang = Column(Text)
    kurir = Column(String)
    nama_petugas = Column(String)
    foto = Column(Text)  # Base64 encoded image
    created_by = Column(Integer, ForeignKey("users.id"))
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    
    user = relationship("User")

class Laporan(Base):
    __tablename__ = "laporan"
    
    id = Column(Integer, primary_key=True, index=True)
    laporanid = Column(String, unique=True, index=True)
    nama = Column(String)
    laporan = Column(Text)
    tanggal = Column(DateTime)
    foto = Column(Text)  # Base64 encoded image
    created_by = Column(Integer, ForeignKey("users.id"))
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    
    user = relationship("User")

class Activity(Base):
    __tablename__ = "activities"
    
    id = Column(Integer, primary_key=True, index=True)
    activityid = Column(String, unique=True, index=True)
    name = Column(String)
    activity = Column(Text)
    images = Column(Text)  # Base64 encoded image
    datetime = Column(DateTime)
    created_by = Column(Integer, ForeignKey("users.id"))
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    
    user = relationship("User")

class EmergencyContact(Base):
    __tablename__ = "emergency_contacts"
    
    id = Column(Integer, primary_key=True, index=True)
    nama = Column(String)
    no_telepon = Column(String)
    service = Column(String)
    alamat = Column(Text)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

class Attendance(Base):
    __tablename__ = "attendance"
    
    id = Column(Integer, primary_key=True, index=True)
    nik = Column(String, ForeignKey("users.nip"))
    tagid = Column(String)
    checkin = Column(Boolean)  # True for check-in, False for check-out
    timestamp = Column(DateTime(timezone=True), server_default=func.now())
    
    user = relationship("User")

class AccidentReport(Base):
    __tablename__ = "accident_reports"
    
    id = Column(Integer, primary_key=True, index=True)
    nik_reporter = Column(String, ForeignKey("users.nip"))
    the_time = Column(String)
    the_date = Column(String)
    title = Column(String)
    id_site = Column(Integer)
    related_figure = Column(String)
    figures_remark = Column(Text)
    chronology = Column(Text)
    taken_action = Column(Text)
    image = Column(Text)  # Base64 encoded image
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    
    user = relationship("User") 