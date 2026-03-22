#!/bin/bash

# 1. Sprawdzenie czy istnieje docker
if ! command -v docker &> /dev/null
then
    echo "Błąd: Docker nie jest zainstalowany. Zainstaluj Docker i spróbuj ponownie."
    exit 1
fi

echo "Docker jest zainstalowany."

# 2. Sprawdzenie czy obraz urządzenia jest gotowy do uruchomienia
# Używamy docker-compose.device.yml
if [ -z "$(docker-compose -f docker-compose.device.yml images -q device)" ]; then
    echo "Obraz urządzenia nie jest gotowy. Budowanie obrazu..."
    docker-compose -f docker-compose.device.yml build
else
    echo "Obraz urządzenia jest gotowy."
fi

# 3. Sprawdzenie czy kontener stoi
CONTAINER_NAME="home-voice-ai-device"
if [ "$(docker ps -q -f name=$CONTAINER_NAME -f status=running)" ]; then
    echo "Info: Urządzenie $CONTAINER_NAME już działa."
    exit 0
else
    echo "Uruchamianie urządzenia..."
    docker-compose -f docker-compose.device.yml up -d
fi
