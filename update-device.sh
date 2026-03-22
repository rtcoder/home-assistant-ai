#!/bin/bash

# Sprawdzenie czy istnieje git
if ! command -v git &> /dev/null
then
    echo "Błąd: Git nie jest zainstalowany. Zainstaluj git i spróbuj ponownie."
    exit 1
fi

# Sprawdzenie czy istnieje docker
if ! command -v docker &> /dev/null
then
    echo "Błąd: Docker nie jest zainstalowany. Zainstaluj Docker i spróbuj ponownie."
    exit 1
fi

# 1. Pobranie najnowszych zmian
echo "Pobieranie najnowszych zmian z repozytorium (git pull)..."
git pull

# 2. Sprawdzenie czy kontener urządzenia był uruchomiony
DEVICE_CONTAINER="home-voice-ai-device"
WAS_DEVICE_RUNNING=$(docker ps -q -f name=$DEVICE_CONTAINER -f status=running)

# 3. Przebudowanie obrazu urządzenia
echo "Budowanie obrazu urządzenia..."
docker-compose -f docker-compose.device.yml build

# 4. Ponowne uruchomienie jeśli było uruchomione
if [ -n "$WAS_DEVICE_RUNNING" ]; then
    echo "Aktualizacja urządzenia (docker-compose up -d)..."
    docker-compose -f docker-compose.device.yml up -d
    echo "Urządzenie zostało zaktualizowane i uruchomione ponownie."
else
    echo "Urządzenie nie było uruchomione. Obraz został przebudowany, ale kontener pozostaje wyłączony."
fi
