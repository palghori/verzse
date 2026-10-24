<div align="center">

# 🤖 VERZSE
### Secure, Private, Fully Offline AI Chatbot

**Your intelligence. Your machine. Zero cloud.**

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux%20%7C%20Windows-lightgrey.svg)
![Model](https://img.shields.io/badge/model-Llama%203.1%208B-orange.svg)
![Status](https://img.shields.io/badge/status-active-brightgreen.svg)

</div>

---

VERZSE is a **100% offline AI chatbot** that runs entirely on your own hardware. No internet connection required. No data sent to any server. No subscriptions. Your conversations stay on your machine — always.

It uses [llama.cpp](https://github.com/ggerganov/llama.cpp) to run quantized LLM models locally, a lightweight Python/Flask backend as the middleware, and a beautiful glassmorphism chat interface that opens directly in your browser.

---

## ✨ Features

- 🔒 **Fully Offline** — Zero network calls during inference. Works without Wi-Fi.
- 🧠 **Powered by Llama 3.1 8B** — State-of-the-art open-source LLM running on your CPU/GPU.
- ⚡ **Real-time Streaming** — Tokens stream live to your browser using Server-Sent Events (SSE).
- 💬 **Conversational Memory** — Maintains full chat history within a session.
- 🎨 **Premium UI** — Dark glassmorphism interface with smooth animations.
- 📦 **Portable** — Build into a standalone binary with one command. No Python required on the target machine.
- 🖥️ **Cross-Platform** — macOS, Linux, and Windows supported.

---

## 🏗️ Architecture

```
┌──────────────────────┐
│  Browser (HTML/JS)   │  ← frontend/index.html
│  Glassmorphism UI    │
└──────────┬───────────┘
           │ HTTP POST + SSE
           ▼
┌──────────────────────┐
│  Flask Backend       │  ← backend/app.py  (port 5000)
│  Python Proxy API    │
└──────────┬───────────┘
           │ OpenAI-compatible API
           ▼
┌──────────────────────┐
│  llama.cpp Server    │  (port 8080)
│  Local Inference     │
└──────────┬───────────┘
           │ Loads model
           ▼
┌──────────────────────┐
│  .gguf Model File    │  ← models/  (~4.9 GB)
│  Llama 3.1 8B Q4_KM  │
└──────────────────────┘
```

---

## 🚀 Quick Start

### Prerequisites

- macOS, Linux, or Windows (WSL)
- Python 3.9+
- `git` and `cmake` installed

### Step 1 — Clone the Repository

```bash
git clone https://github.com/palghori/VERZSE.git
cd VERZSE
```

### Step 2 — Download a Model

Download a quantized `.gguf` model file and place it inside the `models/` folder.

**Recommended model:** [`Llama-3.1-8B-Instruct-Q4_K_M.gguf`](https://huggingface.co/bartowski/Meta-Llama-3.1-8B-Instruct-GGUF)

```bash
mkdir -p models
# Move your downloaded .gguf file here:
mv ~/Downloads/Llama-3.1-8B-Instruct-Q4_K_M.gguf ./models/
```

### Step 3 — Compile llama.cpp

```bash
git clone https://github.com/ggerganov/llama.cpp
cd llama.cpp
cmake -B build
cmake --build build --config Release -j
cd ..
```

### Step 4 — Set Up Python Environment

```bash
python3 -m venv venv
source venv/bin/activate      # On Windows: venv\Scripts\activate
pip install -r backend/requirements.txt
```

### Step 5 — Launch VERZSE

```bash
chmod +x start.sh
./start.sh
```

VERZSE will automatically:
1. 🚀 Start the llama.cpp inference server on port 8080
2. 🐍 Start the Flask API backend on port 5000
3. 🌐 Open the chat interface in your default browser

---

## 📁 Project Structure

```
VERZSE/
├── backend/
│   ├── app.py              # Flask API — SSE proxy to llama.cpp
│   └── requirements.txt    # Python dependencies
├── frontend/
│   └── index.html          # Full chat UI (self-contained)
├── models/                 # ⚠️  Place your .gguf model here (not included)
├── llama.cpp/              # ⚠️  Clone & compile separately (not included)
├── start.sh                # 🚀 Main launcher script
├── build.sh                # 📦 PyInstaller build script
├── auto_install.sh         # ⚙️  One-click installer helper
├── app.spec                # PyInstaller spec file
└── OFFLINE_TESTING_INSTRUCTIONS.md
```

> **Note:** `models/` and `llama.cpp/` are excluded from this repository via `.gitignore` because of their size. Follow the setup steps above to get them.

---

## 📦 Building a Standalone Binary (Optional)

Package the Python backend into a native executable so users don't need Python installed:

```bash
chmod +x build.sh
./build.sh
```

The compiled binary will be at `./dist/app`. You can then distribute the entire project folder (excluding `models/` and `llama.cpp/`) as a portable package.

---

## ⚙️ Configuration

The backend connects to llama.cpp at `http://localhost:8080` by default. You can change the port or model parameters in [backend/app.py](backend/app.py):

```python
LLAMA_API_URL = "http://localhost:8080/v1/chat/completions"
```

In [start.sh](start.sh), you can tune inference parameters:

```bash
$LLAMA_CPP_PATH -m "$MODEL_PATH" --port 8080 --threads 6 -c 2048
```

| Flag | Description |
|---|---|
| `--threads` | Number of CPU threads to use (default: 6) |
| `-c` | Context window size in tokens (default: 2048) |
| `--port` | llama.cpp server port (default: 8080) |

---

## 🔒 Privacy & Security

VERZSE is **designed from the ground up for privacy:**

- ✅ All inference runs **100% locally** on your machine
- ✅ No telemetry, analytics, or usage data collection
- ✅ No accounts, logins, or API keys required
- ✅ Works with **Wi-Fi completely disabled**
- ✅ Chat history is held only in RAM — cleared on app restart

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Inference Engine | [llama.cpp](https://github.com/ggerganov/llama.cpp) |
| AI Model | Llama 3.1 8B Instruct (GGUF quantized) |
| Backend API | Python 3 + Flask 3.0 |
| Streaming Protocol | Server-Sent Events (SSE) |
| Frontend | Vanilla HTML5 + CSS3 + JavaScript |
| Packaging | PyInstaller |

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to open a [GitHub Issue](../../issues) or submit a pull request.

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

> The AI model weights (Llama 3.1) are subject to [Meta's Llama License](https://llama.meta.com/llama-downloads/). Please review it before commercial use.

---

<div align="center">
Made with ❤️ — Runs entirely on your machine.
</div>
