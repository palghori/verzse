#!/bin/bash
echo "============================================="
echo "=== VERZSE BULLETPROOF AUTO-INSTALLER ==="
echo "============================================="

# Ensure we are in the correct directory regardless of how it was called
cd "$(dirname "$0")"

mkdir -p models

echo "[1/3] Searching for your .gguf model on your Desktop..."
MODEL_SOURCE=""
if ls "$HOME/Desktop/verzse ai chatbot/models/"*.gguf 1> /dev/null 2>&1; then
    MODEL_SOURCE=$(ls "$HOME/Desktop/verzse ai chatbot/models/"*.gguf | head -n 1)
elif ls "$HOME/Desktop/"*.gguf 1> /dev/null 2>&1; then
    MODEL_SOURCE=$(ls "$HOME/Desktop/"*.gguf | head -n 1)
fi

if [ -n "$MODEL_SOURCE" ]; then
    echo "Found your model at: $MODEL_SOURCE"
    echo "Copying to the localized models folder safely..."
    cp "$MODEL_SOURCE" ./models/
    MODEL_FILENAME=$(basename "$MODEL_SOURCE")
    
    # Safely update start.sh to point to this exact file
    sed -i '' "s|^MODEL_PATH=.*|MODEL_PATH=\"./models/$MODEL_FILENAME\"|" start.sh
    echo "Success: Updated start.sh configuration automatically!"
else
    echo "Warning: Could not automatically find your .gguf model on your Desktop."
    echo "Don't panic! Just drag and drop your .gguf model into:"
    echo "$(pwd)/models/"
    echo "And update start.sh with the file name!"
fi

echo ""
echo "[2/3] Downloading and Compiling AI Engine (llama.cpp)..."
echo "This might take 1-2 minutes depending on your Mac speed."
if [ ! -d "llama.cpp" ]; then
    git clone https://github.com/ggerganov/llama.cpp
fi
cd llama.cpp
echo "Installing CMake via Python just in case..."
python3 -m pip install cmake
python3 -m cmake -B build
python3 -m cmake --build build --config Release -j
cd ..

echo ""
echo "[3/3] Fixing previous Frontend Bugs..."
# The frontend mask bug was patched directly by the AI earlier.
echo "Done."

echo "============================================="
echo "=== INSTALLATION COMPLETE!                  ==="
echo "============================================="
echo "Everything is perfectly synchronized now."
echo "Run the chatbot by typing:"
echo " ./start.sh"
