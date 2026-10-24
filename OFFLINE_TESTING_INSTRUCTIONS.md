# VERZSE - Secure Offline Chatbot 

Follow these instruction steps to select a model, boot up the environment, and package it into a completely offline macOS standalone experience.

## 1. Local Architecture Setup (Llama.cpp)

You'll need `llama.cpp` to run models smoothly on Apple Silicon or any standard CPU.

1. **Clone and Compile llama.cpp**:
   Open a terminal and run:
   ```bash
   git clone https://github.com/ggerganov/llama.cpp
   cd llama.cpp
   make -j
   ```
   *This compiles the `server` binary natively for macOS. Move or symlink this cloned `llama.cpp` directory into the root of this `verzse/` project.*

2. **Download an Offline Context Model**:
   We recommend **Meta-Llama-3-8B-Instruct.Q4_K_M.gguf** for an outstanding balance of intelligence and performance on laptops.
   * Download the `.gguf` file from a site like HuggingFace (TheBloke or QuantFactory repositories).
   * Create a folder called `models/` inside this project and place your downloaded `.gguf` file there.
   * *Verify that the filename matches `MODEL_PATH` inside the `start.sh` configuration.*

## 2. API Backend Implementation

VERZSE uses a Python backend proxy that safely interfaces the local hardware with the browser UI layer and buffers Server-Sent Events (SSE).

1. Optionally, use a virtual environment:
   ```bash
   python3 -m venv venv
   source venv/bin/activate
   ```
2. Download dependencies:
   ```bash
   pip install -r backend/requirements.txt
   ```

## 3. Package the App for Total Offline Operation

Use the provided PyInstaller script to bake the Flask application code into an OS-native executable binary file.

1. Issue Execute Permissions:
   ```bash
   chmod +x build.sh
   ```
2. Run the `build.sh` pipeline:
   ```bash
   ./build.sh
   ```
   *This will compile your python project and produce a native executable inside the `./dist/app` folder.*
   *At this stage, your `verzse` folder is fully portable to any Mac with identical architecture, unreliant on external CDNs or Python interpreters.*

## 4. Execution & Testing (Offline Demonstration)

Finally, prove the offline design is working robustly:

1. Turn off your Wi-Fi or physically disconnect internet.
2. In the terminal, from the `verzse/` project root, run:
   ```bash
   chmod +x start.sh
   ./start.sh
   ```
   This orchestrator will automatically spin up the `llama.cpp` background inference server, start up the compiled Python `app` HTTP framework, and then natively `open` the `frontend/index.html` interface straight in your primary default web browser.
3. **Chat**: Test message latency and AI streaming directly in the UI. Total privacy, total local hardware.
