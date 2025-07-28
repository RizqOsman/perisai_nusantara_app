from pydantic import BaseModel
from typing import Optional
from datetime import datetime

# User schemas
class UserBase(BaseModel):
    nip: str
    name: str
    email: str
    id_site: int
    site: str
    id_position: int
    status: str = "active"

class UserCreate(UserBase):
    password: str

class UserLogin(BaseModel):
    email: str
    password: str

class User(UserBase):
    id: int
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True

class UserAuth(BaseModel):
    user: User

# Buku Tamu schemas
class BukuTamuBase(BaseModel):
    no_visitor: str
    tanggal: datetime
    nama: str
    telepon: str
    alamat: str
    keperluan: str
    foto: str
    filename: str

class BukuTamuCreate(BukuTamuBase):
    pass

class BukuTamu(BukuTamuBase):
    id: int
    created_by: int
    created_at: datetime

    class Config:
        from_attributes = True

# Buku Paket schemas
class BukuPaketBase(BaseModel):
    id_paket: str
    tanggal: datetime
    nama_penerima: str
    barang: str
    kurir: str
    nama_petugas: str
    foto: str

class BukuPaketCreate(BukuPaketBase):
    pass

class BukuPaket(BukuPaketBase):
    id: int
    created_by: int
    created_at: datetime

    class Config:
        from_attributes = True

# Laporan schemas
class LaporanBase(BaseModel):
    laporanid: str
    nama: str
    laporan: str
    tanggal: datetime
    foto: str

class LaporanCreate(LaporanBase):
    pass

class Laporan(LaporanBase):
    id: int
    created_by: int
    created_at: datetime

    class Config:
        from_attributes = True

# Activity schemas
class ActivityBase(BaseModel):
    activityid: str
    name: str
    activity: str
    images: str
    datetime: datetime

class ActivityCreate(ActivityBase):
    pass

class Activity(ActivityBase):
    id: int
    created_by: int
    created_at: datetime

    class Config:
        from_attributes = True

# Emergency Contact schemas
class EmergencyContactBase(BaseModel):
    nama: str
    no_telepon: str
    service: str
    alamat: str

class EmergencyContactCreate(EmergencyContactBase):
    pass

class EmergencyContact(EmergencyContactBase):
    id: int
    created_at: datetime

    class Config:
        from_attributes = True

# Attendance schemas
class AttendanceBase(BaseModel):
    nik: str
    tagid: str
    checkin: bool

class AttendanceCreate(AttendanceBase):
    pass

class Attendance(AttendanceBase):
    id: int
    timestamp: datetime

    class Config:
        from_attributes = True

# Accident Report schemas
class AccidentReportBase(BaseModel):
    nik_reporter: str
    the_time: str
    the_date: str
    title: str
    id_site: int
    related_figure: str
    figures_remark: str
    chronology: str
    taken_action: str
    image: str

class AccidentReportCreate(AccidentReportBase):
    pass

class AccidentReport(AccidentReportBase):
    id: int
    created_at: datetime

    class Config:
        from_attributes = True 