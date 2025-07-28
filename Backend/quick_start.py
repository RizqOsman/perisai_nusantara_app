#!/usr/bin/env python3
"""
Quick Start Script untuk Perisai Nusantara Backend
"""

import os
import sys
import subprocess
import time

def print_banner():
    """Print banner aplikasi"""
    print("""
    ╔══════════════════════════════════════════════════════════════╗
    ║                    PERISAI NUSANTARA                        ║
    ║                        BACKEND                              ║
    ║                                                              ║
    ║  🛡️  Sistem Manajemen Keamanan dan Fasilitas               ║
    ║  📱 GuardApp - Mobile Application                          ║
    ║  🚀 FastAPI Backend dengan SQLite Database                 ║
    ╚══════════════════════════════════════════════════════════════╝
    """)

def check_python():
    """Check Python version"""
    print("🔍 Checking Python installation...")
    try:
        version = sys.version_info
        if version.major >= 3 and version.minor >= 8:
            print(f"✅ Python {version.major}.{version.minor}.{version.micro} - OK")
            return True
        else:
            print(f"❌ Python {version.major}.{version.minor}.{version.micro} - Need Python 3.8+")
            return False
    except Exception as e:
        print(f"❌ Python check failed: {e}")
        return False

def setup_environment():
    """Setup Python environment"""
    print("\n🔧 Setting up environment...")
    
    # Create virtual environment if not exists
    if not os.path.exists("venv"):
        print("📦 Creating virtual environment...")
        subprocess.run([sys.executable, "-m", "venv", "venv"], check=True)
        print("✅ Virtual environment created")
    else:
        print("ℹ️  Virtual environment already exists")
    
    # Create database directory
    os.makedirs("database", exist_ok=True)
    print("✅ Database directory ready")

def install_dependencies():
    """Install Python dependencies"""
    print("\n📥 Installing dependencies...")
    
    # Determine activation command based on OS
    if os.name == 'nt':  # Windows
        pip_cmd = "venv\\Scripts\\pip"
    else:  # Linux/Mac
        pip_cmd = "venv/bin/pip"
    
    try:
        subprocess.run([pip_cmd, "install", "-r", "requirements.txt"], check=True)
        print("✅ Dependencies installed successfully")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ Failed to install dependencies: {e}")
        return False

def start_server():
    """Start the FastAPI server"""
    print("\n🚀 Starting FastAPI server...")
    
    # Determine python command based on OS
    if os.name == 'nt':  # Windows
        python_cmd = "venv\\Scripts\\python"
    else:  # Linux/Mac
        python_cmd = "venv/bin/python"
    
    try:
        print("📍 Server will be available at: http://localhost:8000")
        print("📚 API Documentation: http://localhost:8000/docs")
        print("📖 ReDoc: http://localhost:8000/redoc")
        print("\n⏳ Starting server... (Press Ctrl+C to stop)")
        print("-" * 60)
        
        # Start the server
        subprocess.run([python_cmd, "run.py"])
        
    except KeyboardInterrupt:
        print("\n\n🛑 Server stopped by user")
    except Exception as e:
        print(f"❌ Failed to start server: {e}")

def main():
    """Main function"""
    print_banner()
    
    # Check Python
    if not check_python():
        print("\n❌ Please install Python 3.8 or higher")
        sys.exit(1)
    
    # Setup environment
    setup_environment()
    
    # Install dependencies
    if not install_dependencies():
        print("\n❌ Failed to install dependencies")
        sys.exit(1)
    
    # Start server
    start_server()

if __name__ == "__main__":
    main() 