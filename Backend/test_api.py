#!/usr/bin/env python3
"""
Script untuk testing API endpoints
"""

import requests
import json
import uuid
from datetime import datetime

BASE_URL = "http://172.15.1.21:8000"

def test_health_check():
    """Test health check endpoint"""
    print("🔍 Testing health check...")
    try:
        response = requests.get(f"{BASE_URL}/")
        if response.status_code == 200:
            print("✅ Health check passed")
            return True
        else:
            print(f"❌ Health check failed: {response.status_code}")
            return False
    except Exception as e:
        print(f"❌ Health check error: {e}")
        return False

def test_login():
    """Test login endpoint"""
    print("🔍 Testing login...")
    login_data = {
        "email": "admin@perisai.com",
        "password": "admin123"
    }
    
    try:
        response = requests.post(f"{BASE_URL}/login-anggota", json=login_data)
        if response.status_code == 200:
            data = response.json()
            print("✅ Login successful")
            print(f"   User: {data['user']['name']}")
            print(f"   NIP: {data['user']['nip']}")
            return True
        else:
            print(f"❌ Login failed: {response.status_code}")
            print(f"   Response: {response.text}")
            return False
    except Exception as e:
        print(f"❌ Login error: {e}")
        return False

def test_buku_tamu():
    """Test buku tamu endpoints"""
    print("🔍 Testing buku tamu...")
    
    # Test create buku tamu
    import uuid
    unique_id = str(uuid.uuid4())[:8]
    buku_tamu_data = {
        "no_visitor": f"VT-{datetime.now().strftime('%Y%m%d')}-{unique_id}",
        "tanggal": datetime.now().isoformat(),
        "nama": "John Doe",
        "telepon": "08123456789",
        "alamat": "Jakarta",
        "keperluan": "Meeting",
        "foto": "data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAYEBQYFBAYGBQYHBwYIChAKCgkJChQODwwQFxQYGBcUFhYaHSUfGhsjHBYWICwgIyYnKSopGR8tMC0oMCUoKSj/2wBDAQcHBwoIChMKChMoGhYaKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCj/wAARCAABAAEDASIAAhEBAxEB/8QAFQABAQAAAAAAAAAAAAAAAAAAAAv/xAAUEAEAAAAAAAAAAAAAAAAAAAAA/8QAFQEBAQAAAAAAAAAAAAAAAAAAAAX/xAAUEQEAAAAAAAAAAAAAAAAAAAAA/9oADAMBAAIRAxEAPwCdABmX/9k=",
        "filename": "test.jpg"
    }
    
    try:
        response = requests.post(f"{BASE_URL}/daftar-tamu", data=buku_tamu_data)
        if response.status_code == 200:
            print("✅ Create buku tamu successful")
        else:
            print(f"❌ Create buku tamu failed: {response.status_code}")
            return False
    except Exception as e:
        print(f"❌ Create buku tamu error: {e}")
        return False
    
    # Test get buku tamu
    try:
        response = requests.get(f"{BASE_URL}/buku-tamu")
        if response.status_code == 200:
            data = response.json()
            print(f"✅ Get buku tamu successful: {len(data)} records")
            return True
        else:
            print(f"❌ Get buku tamu failed: {response.status_code}")
            return False
    except Exception as e:
        print(f"❌ Get buku tamu error: {e}")
        return False

def test_emergency_contacts():
    """Test emergency contacts endpoints"""
    print("🔍 Testing emergency contacts...")
    
    try:
        response = requests.get(f"{BASE_URL}/emergency-contact")
        if response.status_code == 200:
            data = response.json()
            print(f"✅ Get emergency contacts successful: {len(data)} contacts")
            return True
        else:
            print(f"❌ Get emergency contacts failed: {response.status_code}")
            return False
    except Exception as e:
        print(f"❌ Get emergency contacts error: {e}")
        return False

def test_laporan():
    """Test laporan endpoints"""
    print("🔍 Testing laporan...")
    
    # Test create laporan
    unique_id = str(uuid.uuid4())[:8]
    laporan_data = {
        "laporanid": f"RP-{datetime.now().strftime('%Y%m%d')}-{unique_id}",
        "nama": "Test User",
        "laporan": "Test laporan harian",
        "tanggal": datetime.now().isoformat(),
        "foto": "data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAYEBQYFBAYGBQYHBwYIChAKCgkJChQODwwQFxQYGBcUFhYaHSUfGhsjHBYWICwgIyYnKSopGR8tMC0oMCUoKSj/2wBDAQcHBwoIChMKChMoGhYaKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCj/wAARCAABAAEDASIAAhEBAxEB/8QAFQABAQAAAAAAAAAAAAAAAAAAAAv/xAAUEAEAAAAAAAAAAAAAAAAAAAAA/8QAFQEBAQAAAAAAAAAAAAAAAAAAAAX/xAAUEQEAAAAAAAAAAAAAAAAAAAAA/9oADAMBAAIRAxEAPwCdABmX/9k="
    }
    
    try:
        response = requests.post(f"{BASE_URL}/laporan", data=laporan_data)
        if response.status_code == 200:
            print("✅ Create laporan successful")
        else:
            print(f"❌ Create laporan failed: {response.status_code}")
            return False
    except Exception as e:
        print(f"❌ Create laporan error: {e}")
        return False
    
    # Test get laporan
    try:
        response = requests.get(f"{BASE_URL}/laporan")
        if response.status_code == 200:
            data = response.json()
            print(f"✅ Get laporan successful: {len(data)} records")
            return True
        else:
            print(f"❌ Get laporan failed: {response.status_code}")
            return False
    except Exception as e:
        print(f"❌ Get laporan error: {e}")
        return False

def test_activity():
    """Test activity endpoints"""
    print("🔍 Testing activity...")
    
    # Test create activity
    unique_id = str(uuid.uuid4())[:8]
    activity_data = {
        "activityid": f"AC-{datetime.now().strftime('%Y%m%d')}-{unique_id}",
        "name": "Test Activity",
        "activity": "Test activity description",
        "images": "data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAYEBQYFBAYGBQYHBwYIChAKCgkJChQODwwQFxQYGBcUFhYaHSUfGhsjHBYWICwgIyYnKSopGR8tMC0oMCUoKSj/2wBDAQcHBwoIChMKChMoGhYaKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCj/wAARCAABAAEDASIAAhEBAxEB/8QAFQABAQAAAAAAAAAAAAAAAAAAAAv/xAAUEAEAAAAAAAAAAAAAAAAAAAAA/8QAFQEBAQAAAAAAAAAAAAAAAAAAAAX/xAAUEQEAAAAAAAAAAAAAAAAAAAAA/9oADAMBAAIRAxEAPwCdABmX/9k=",
        "datetime": datetime.now().isoformat()
    }
    
    try:
        response = requests.post(f"{BASE_URL}/activity", data=activity_data)
        if response.status_code == 200:
            print("✅ Create activity successful")
        else:
            print(f"❌ Create activity failed: {response.status_code}")
            return False
    except Exception as e:
        print(f"❌ Create activity error: {e}")
        return False
    
    # Test get activity
    try:
        response = requests.get(f"{BASE_URL}/activity")
        if response.status_code == 200:
            data = response.json()
            print(f"✅ Get activity successful: {len(data)} records")
            return True
        else:
            print(f"❌ Get activity failed: {response.status_code}")
            return False
    except Exception as e:
        print(f"❌ Get activity error: {e}")
        return False

def run_all_tests():
    """Run all API tests"""
    print("🚀 Starting API Tests...")
    print("=" * 50)
    
    tests = [
        test_health_check,
        test_login,
        test_emergency_contacts,
        test_buku_tamu,
        test_laporan,
        test_activity
    ]
    
    passed = 0
    total = len(tests)
    
    for test in tests:
        try:
            if test():
                passed += 1
        except Exception as e:
            print(f"❌ Test {test.__name__} crashed: {e}")
        print("-" * 30)
    
    print("=" * 50)
    print(f"📊 Test Results: {passed}/{total} tests passed")
    
    if passed == total:
        print("🎉 All tests passed!")
    else:
        print("⚠️  Some tests failed. Check the output above.")

if __name__ == "__main__":
    run_all_tests() 