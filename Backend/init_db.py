#!/usr/bin/env python3
"""
Script untuk menginisialisasi database dengan data sample
"""

import requests
import json
from datetime import datetime

BASE_URL = "http://172.15.1.21:8000"

def init_database():
    """Initialize database with sample data"""
    
    print("🚀 Initializing Perisai Nusantara Database...")
    
    # Test connection
    try:
        response = requests.get(f"{BASE_URL}/")
        if response.status_code == 200:
            print("✅ Server is running")
        else:
            print("❌ Server is not responding")
            return
    except requests.exceptions.ConnectionError:
        print("❌ Cannot connect to server. Make sure the server is running on http://172.15.1.21:8000")
        return
    
    # Initialize database
    try:
        response = requests.post(f"{BASE_URL}/init-db")
        if response.status_code == 200:
            print("✅ Database initialized with sample data")
        else:
            print(f"❌ Failed to initialize database: {response.text}")
    except Exception as e:
        print(f"❌ Error initializing database: {e}")
    
    # Add sample emergency contacts
    emergency_contacts = [
        {
            "nama": "Polisi",
            "no_telepon": "110",
            "service": "Kepolisian",
            "alamat": "Jakarta"
        },
        {
            "nama": "Pemadam Kebakaran",
            "no_telepon": "113",
            "service": "Pemadam Kebakaran",
            "alamat": "Jakarta"
        },
        {
            "nama": "Ambulans",
            "no_telepon": "118",
            "service": "Layanan Medis",
            "alamat": "Jakarta"
        },
        {
            "nama": "SAR",
            "no_telepon": "115",
            "service": "Search and Rescue",
            "alamat": "Jakarta"
        },
        {
            "nama": "PLN",
            "no_telepon": "123",
            "service": "Perusahaan Listrik Negara",
            "alamat": "Jakarta"
        }
    ]
    
    print("📞 Adding emergency contacts...")
    for contact in emergency_contacts:
        try:
            response = requests.post(f"{BASE_URL}/emergency-contact", json=contact)
            if response.status_code == 200:
                print(f"✅ Added: {contact['nama']} - {contact['no_telepon']}")
            else:
                print(f"❌ Failed to add {contact['nama']}: {response.text}")
        except Exception as e:
            print(f"❌ Error adding {contact['nama']}: {e}")
    
    # Add sample users
    sample_users = [
        {
            "nip": "12345",
            "name": "Administrator",
            "email": "admin@perisai.com",
            "password": "admin123",
            "id_site": 1,
            "site": "Jakarta",
            "id_position": 1,
            "status": "active"
        },
        {
            "nip": "67890",
            "name": "Petugas Keamanan",
            "email": "security@perisai.com",
            "password": "security123",
            "id_site": 1,
            "site": "Jakarta",
            "id_position": 2,
            "status": "active"
        }
    ]
    
    print("👥 Adding sample users...")
    for user in sample_users:
        try:
            response = requests.post(f"{BASE_URL}/users", json=user)
            if response.status_code == 200:
                print(f"✅ Added user: {user['name']}")
            else:
                print(f"❌ Failed to add user {user['name']}: {response.text}")
        except Exception as e:
            print(f"❌ Error adding user {user['name']}: {e}")
    
    print("\n🎉 Database initialization completed!")
    print("\n📋 Sample Data:")
    print("- Emergency Contacts: 5 contacts")
    print("- Users: 2 users")
    print("\n🔗 API Documentation:")
    print(f"- Swagger UI: {BASE_URL}/docs")
    print(f"- ReDoc: {BASE_URL}/redoc")
    print("\n👤 Sample Login Credentials:")
    print("- Email: admin@perisai.com")
    print("- Password: admin123")

if __name__ == "__main__":
    init_database() 