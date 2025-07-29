#!/usr/bin/env python3
"""
Script untuk setup lengkap backend Perisai Nusantara
"""

import os
import sys
import subprocess
import time
import requests

def run_command(command, description):
    """Run a command and handle errors"""
    print(f"🔄 {description}...")
    try:
        result = subprocess.run(command, shell=True, check=True, capture_output=True, text=True)
        print(f"✅ {description} completed")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ {description} failed: {e}")
        print(f"   Error: {e.stderr}")
        return False

def check_python():
    """Check if Python is installed"""
    print("🔍 Checking Python installation...")
    try:
        result = subprocess.run([sys.executable, "--version"], capture_output=True, text=True)
        print(f"✅ Python found: {result.stdout.strip()}")
        return True
    except Exception as e:
        print(f"❌ Python not found: {e}")
        return False

def create_virtual_environment():
    """Create virtual environment"""
    if os.path.exists("venv"):
        print("ℹ️  Virtual environment already exists")
        return True
    
    return run_command(f"{sys.executable} -m venv venv", "Creating virtual environment")

def install_dependencies():
    """Install Python dependencies"""
    if os.name == 'nt':  # Windows
        activate_cmd = "venv\\Scripts\\activate && pip install -r requirements.txt"
    else:  # Linux/Mac
        activate_cmd = "source venv/bin/activate && pip install -r requirements.txt"
    
    return run_command(activate_cmd, "Installing dependencies")

def create_database_directory():
    """Create database directory"""
    try:
        os.makedirs("database", exist_ok=True)
        print("✅ Database directory created")
        return True
    except Exception as e:
        print(f"❌ Failed to create database directory: {e}")
        return False

def start_server():
    """Start the FastAPI server"""
    print("🚀 Starting FastAPI server...")
    
    if os.name == 'nt':  # Windows
        activate_cmd = "venv\\Scripts\\activate && python run.py"
    else:  # Linux/Mac
        activate_cmd = "source venv/bin/activate && python run.py"
    
    try:
        # Start server in background
        if os.name == 'nt':  # Windows
            process = subprocess.Popen(activate_cmd, shell=True)
        else:  # Linux/Mac
            process = subprocess.Popen(activate_cmd, shell=True, preexec_fn=os.setsid)
        
        print("✅ Server started in background")
        print("📍 Server URL: http://172.15.1.21:8000")
        print("📚 API Docs: http://172.15.1.21:8000/docs")
        
        return process
    except Exception as e:
        print(f"❌ Failed to start server: {e}")
        return None

def wait_for_server():
    """Wait for server to be ready"""
    print("⏳ Waiting for server to be ready...")
    max_attempts = 30
    for i in range(max_attempts):
        try:
            response = requests.get("http://172.15.1.21:8000/", timeout=5)
            if response.status_code == 200:
                print("✅ Server is ready!")
                return True
        except:
            pass
        
        time.sleep(1)
        if (i + 1) % 5 == 0:
            print(f"   Still waiting... ({i + 1}/{max_attempts})")
    
    print("❌ Server failed to start within 30 seconds")
    return False

def initialize_database():
    """Initialize database with sample data"""
    print("🗄️  Initializing database...")
    
    try:
        response = requests.post("http://172.15.1.21:8000/init-db", timeout=10)
        if response.status_code == 200:
            print("✅ Database initialized")
            return True
        else:
            print(f"❌ Database initialization failed: {response.status_code}")
            return False
    except Exception as e:
        print(f"❌ Database initialization error: {e}")
        return False

def update_frontend_urls():
    """Update frontend URLs to use local backend"""
    print("🔄 Updating frontend URLs...")
    
    if os.name == 'nt':  # Windows
        activate_cmd = "venv\\Scripts\\activate && python update_frontend_urls.py"
    else:  # Linux/Mac
        activate_cmd = "source venv/bin/activate && python update_frontend_urls.py"
    
    return run_command(activate_cmd, "Updating frontend URLs")

def run_tests():
    """Run API tests"""
    print("🧪 Running API tests...")
    
    if os.name == 'nt':  # Windows
        activate_cmd = "venv\\Scripts\\activate && python test_api.py"
    else:  # Linux/Mac
        activate_cmd = "source venv/bin/activate && python test_api.py"
    
    return run_command(activate_cmd, "Running API tests")

def main():
    """Main setup function"""
    print("🚀 Perisai Nusantara Backend Setup")
    print("=" * 50)
    
    # Check Python
    if not check_python():
        print("❌ Python is required. Please install Python 3.8 or higher.")
        return False
    
    # Create virtual environment
    if not create_virtual_environment():
        print("❌ Failed to create virtual environment")
        return False
    
    # Install dependencies
    if not install_dependencies():
        print("❌ Failed to install dependencies")
        return False
    
    # Create database directory
    if not create_database_directory():
        print("❌ Failed to create database directory")
        return False
    
    # Start server
    server_process = start_server()
    if not server_process:
        print("❌ Failed to start server")
        return False
    
    # Wait for server
    if not wait_for_server():
        print("❌ Server failed to start")
        return False
    
    # Initialize database
    if not initialize_database():
        print("❌ Failed to initialize database")
        return False
    
    # Update frontend URLs
    update_frontend_urls()
    
    # Run tests
    run_tests()
    
    print("\n" + "=" * 50)
    print("🎉 Setup completed successfully!")
    print("\n📋 What's been set up:")
    print("✅ Python virtual environment")
    print("✅ Dependencies installed")
    print("✅ Database created and initialized")
    print("✅ FastAPI server running")
    print("✅ Frontend URLs updated")
    print("✅ API tests completed")
    
    print("\n🔗 Useful URLs:")
    print("📍 Server: http://172.15.1.21:8000")
    print("📚 API Docs: http://172.15.1.21:8000/docs")
    print("📖 ReDoc: http://172.15.1.21:8000/redoc")
    
    print("\n👤 Sample Login:")
    print("📧 Email: admin@perisai.com")
    print("🔑 Password: admin123")
    
    print("\n🛠️  Next Steps:")
    print("1. Open your Flutter app")
    print("2. Update the API base URL to: http://172.15.1.21:8000")
    print("3. Test the login functionality")
    print("4. Start using the app!")
    
    print("\n⚠️  Note: Keep this terminal open to keep the server running")
    print("   Press Ctrl+C to stop the server")
    
    try:
        # Keep the script running
        server_process.wait()
    except KeyboardInterrupt:
        print("\n🛑 Stopping server...")
        if os.name == 'nt':  # Windows
            server_process.terminate()
        else:  # Linux/Mac
            os.killpg(os.getpgid(server_process.pid), 15)
        print("✅ Server stopped")

if __name__ == "__main__":
    main() 