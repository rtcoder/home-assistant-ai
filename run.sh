#!/bin/bash

# 1. Sprawdzenie czy istnieje docker
if ! command -v docker &> /dev/null
then
    echo "Błąd: Docker nie jest zainstalowany. Zainstaluj Docker i spróbuj ponownie."
    exit 1
fi

echo "Docker jest zainstalowany."

# 2. Sprawdzenie czy obrazy są już gotowe do uruchomienia
# Sprawdzamy obraz dla serwera
if [ -z "$(docker-compose images -q server)" ]; then
    echo "Obraz serwera nie jest gotowy. Budowanie obrazu..."
    docker-compose build server mqtt-broker
else
    echo "Obrazy są gotowe do uruchomienia."
fi

# 3. Sprawdzenie czy kontener stoi
# Sprawdzamy status kontenera serwera
CONTAINER_NAME="home-voice-ai-server"
if [ "$(docker ps -q -f name=$CONTAINER_NAME -f status=running)" ]; then
    echo "Info: Serwer $CONTAINER_NAME już działa."
    exit 0
else
    echo "Uruchamianie serwera i brokera MQTT..."
    docker-compose up -d
fi
