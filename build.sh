#!/bin/bash
echo "Building VERZSE Backend with PyInstaller..."

# Ensure we're in the right directory
cd "$(dirname "$0")"

# Ensure virtual environment exists
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
fi

# Activate venv and install requirements
source venv/bin/activate
pip install -r backend/requirements.txt
pip install pyinstaller

# Build the standalone binary from the python script
pyinstaller --onefile --distpath ./dist --workpath ./build --specpath ./ backend/app.py

echo ""
echo "=========================================================="
echo "Build complete!"
echo "Your offline executable is located at: ./dist/app"
echo "You can now package the entire 'verzse' folder for offline use."
echo "=========================================================="
