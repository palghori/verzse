from flask import Flask, request, jsonify, Response
from flask_cors import CORS
import requests
import json
import logging

app = Flask(__name__)
CORS(app)  # Allow frontend to communicate with backend
logging.basicConfig(level=logging.INFO)

LLAMA_API_URL = "http://localhost:8080/v1/chat/completions"

# Simple in-memory chat history mapping session to conversation.
# For a single-user offline app, a global list works perfectly.
chat_history = [
    {"role": "system", "content": "You are VERZSE, a highly intelligent, premium, and offline AI assistant. Provide concise, helpful, and accurate answers formatted gracefully in markdown."}
]

@app.route('/chat', methods=['POST'])
def chat():
    data = request.json
    user_prompt = data.get("prompt", "")
    
    if not user_prompt:
        return jsonify({"error": "No prompt provided"}), 400

    # Append user message to history
    chat_history.append({"role": "user", "content": user_prompt})

    # Prepare payload for llama.cpp OpenAI-compatible streaming server
    payload = {
        "messages": chat_history,
        "stream": True,
        "temperature": 0.7,
        "max_tokens": 2048
    }

    def generate():
        try:
            # Stream response from llama.cpp
            with requests.post(LLAMA_API_URL, json=payload, stream=True) as r:
                r.raise_for_status()
                assistant_response = ""
                
                for line in r.iter_lines():
                    if line:
                        decoded_line = line.decode('utf-8')
                        if decoded_line.startswith('data: '):
                            data_str = decoded_line[6:]
                            
                            # Stream completion
                            if data_str.strip() == '[DONE]':
                                break
                                
                            try:
                                json_data = json.loads(data_str)
                                if "choices" in json_data and len(json_data["choices"]) > 0:
                                    delta = json_data["choices"][0].get("delta", {})
                                    content = delta.get("content", "")
                                    if content:
                                        assistant_response += content
                                        # Yield standard SSE format to the browser frontend
                                        yield f"data: {json.dumps({'content': content})}\n\n"
                            except json.JSONDecodeError:
                                continue
                
                # Append the full assistant response to the conversation history after streaming finishes
                if assistant_response:
                    chat_history.append({"role": "assistant", "content": assistant_response})
                    
        except requests.exceptions.RequestException as e:
            logging.error(f"Error communicating with local AI engine: {e}")
            yield f"data: {json.dumps({'error': 'Failed to reach AI. Ensure llama.cpp server is running at localhost:8080.'})}\n\n"

    return Response(generate(), mimetype='text/event-stream')

if __name__ == '__main__':
    # Threaded mode allows it to handle SSE efficiently
    app.run(host='127.0.0.1', port=5000, threaded=True)
