#!/bin/bash

# Start Ollama in the background
echo "Starting Ollama server..."
ollama serve &

# Wait for Ollama to be ready
echo "Waiting for Ollama to be ready..."
until curl -s localhost:11434/api/tags > /dev/null; do
  sleep 1
done

echo "Ollama is ready."

# Start the Python application
echo "Starting Python server..."
exec python server/main.py
