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

# 2. Sprawdzenie czy kontenery były uruchomione
SERVER_CONTAINER="home-voice-ai-server"
MQTT_CONTAINER="home-voice-ai-mqtt"

WAS_SERVER_RUNNING=$(docker ps -q -f name=$SERVER_CONTAINER -f status=running)
WAS_MQTT_RUNNING=$(docker ps -q -f name=$MQTT_CONTAINER -f status=running)

# 3. Przebudowanie obrazów (jeśli zaszły zmiany w Dockerfile lub requirements)
echo "Budowanie obrazów Docker..."
docker-compose build

# 4. Ponowne uruchomienie kontenerów jeśli były uruchomione
if [ -n "$WAS_SERVER_RUNNING" ] || [ -n "$WAS_MQTT_RUNNING" ]; then
    echo "Aktualizacja kontenerów (docker-compose up -d)..."
    docker-compose up -d
    echo "Serwer został zaktualizowany i uruchomiony ponownie."
else
    echo "Kontenery nie były uruchomione. Obrazy zostały przebudowane, ale kontenery pozostają wyłączone."
fi
