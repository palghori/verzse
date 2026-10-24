#!/bin/bash

# ==========================================================
# VERZSE OFFLINE LAUNCHER
# ==========================================================

cd "$(dirname "$0")"

# Clean up any crashed or orphaned VERZSE resources
pkill -f "dist/app" 2>/dev/null
pkill -f "app.py" 2>/dev/null
pkill -f "llama-server" 2>/dev/null

# Dynamic dependencies
LLAMA_CPP_PATH="./llama.cpp/build/bin/llama-server"
# Automatically find whichever .gguf model is located inside models/
MODEL_PATH=$(ls ./models/*.gguf 2>/dev/null | head -n 1)

echo "Initializing VERZSE Secure Offline Intelligence..."

# 1. Boot up the local AI Engine (llama.cpp)
if [ -f "$LLAMA_CPP_PATH" ] && [ -f "$MODEL_PATH" ]; then
    echo "[1/3] Starting Local Inference Engine (llama.cpp)..."
    $LLAMA_CPP_PATH -m "$MODEL_PATH" --port 8080 --threads 6 -c 2048 > llama_cpp.log 2>&1 &
    LLAMA_PID=$!
    echo "      -> Engine running on port 8080 (PID: $LLAMA_PID)"
else
    echo "Warning: Inference engine or model not found in."
    echo "Expected:"
    echo "  Engine: $LLAMA_CPP_PATH"
    echo "  Model:  $MODEL_PATH"
    echo "Proceeding to start backend anyway..."
    LLAMA_PID=""
fi

echo "[2/3] Starting VERZSE Platform API..."
# Use the virtual environment Python so all pip dependencies (Flask, etc.) are available
PYTHON="./venv/bin/python3"
if [ ! -f "$PYTHON" ]; then
    echo "Warning: Virtual environment not found at ./venv"
    echo "         Run: python3 -m venv venv && source venv/bin/activate && pip install -r backend/requirements.txt"
    echo "         Falling back to system Python3 (may fail if Flask is not installed globally)..."
    PYTHON="python3"
fi
$PYTHON backend/app.py > backend.log 2>&1 &
BACKEND_PID=$!
echo "      -> API running on port 5000 (PID: $BACKEND_PID)"

# Quick synchronization delay
sleep 3

# 3. Open UI in the local OS browser
echo "[3/3] Launching VERZSE Interface..."
FRONTEND_PATH="$(pwd)/frontend/index.html"

if [[ "$OSTYPE" == "darwin"* ]]; then
    open "$FRONTEND_PATH"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    xdg-open "$FRONTEND_PATH"
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    start "$FRONTEND_PATH"
else
    echo "Please open $FRONTEND_PATH manually in your browser."
fi

echo ""
echo "=========================================================="
echo " VERZSE is securely online and entirely offline."
echo " Press Ctrl+C in this terminal to shut down all systems."
echo "=========================================================="

# Graceful termination
trap "echo -e '\nShutting down VERZSE...'; kill $LLAMA_PID 2>/dev/null; kill $BACKEND_PID 2>/dev/null; exit 0" SIGINT SIGTERM

# Keep the terminal running to hold the PIDs
wait
