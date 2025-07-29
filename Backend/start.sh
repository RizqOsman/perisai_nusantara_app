#!/bin/bash

echo "🚀 Starting Perisai Nusantara Backend..."

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 is not installed. Please install Python 3.8 or higher."
    exit 1
fi

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "📦 Creating virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
echo "🔧 Activating virtual environment..."
source venv/bin/activate

# Install dependencies
echo "📥 Installing dependencies..."
pip install -r requirements.txt

# Create database directory
echo "🗄️ Creating database directory..."
mkdir -p database

# Run the application
echo "🌟 Starting FastAPI server..."
echo "📍 Server will be available at: http://172.15.1.21:8000"
echo "📚 API Documentation: http://172.15.1.21:8000/docs"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

python run.py 