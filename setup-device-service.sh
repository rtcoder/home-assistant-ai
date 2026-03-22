#!/bin/bash

# Skrypt do instalacji węzła głosowego Home Voice AI jako usługi systemd (Linux)

if [[ $EUID -ne 0 ]]; then
   echo "Błąd: Ten skrypt musi być uruchomiony z uprawnieniami roota (sudo)."
   echo "Użyj: sudo ./setup-device-service.sh"
   exit 1
fi

PROJECT_ROOT=$(pwd)
SERVICE_NAME="home-voice-ai-device"
SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"

# Wykrywanie komendy docker compose
if docker compose version >/dev/null 2>&1; then
    DOCKER_COMPOSE_CMD="$(which docker) compose"
elif docker-compose version >/dev/null 2>&1; then
    DOCKER_COMPOSE_CMD="$(which docker-compose)"
else
    echo "Błąd: Nie znaleziono docker compose ani docker-compose. Zainstaluj Docker przed uruchomieniem tego skryptu."
    exit 1
fi

echo "Instalacja usługi: ${SERVICE_NAME}"
echo "Katalog projektu: ${PROJECT_ROOT}"
echo "Komenda Docker Compose: ${DOCKER_COMPOSE_CMD}"

# Tworzenie pliku usługi
cat <<EOF > "${SERVICE_FILE}"
[Unit]
Description=Home Voice AI Device Service
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=${PROJECT_ROOT}
# Używamy dedykowanego pliku docker-compose dla urządzenia
ExecStart=${DOCKER_COMPOSE_CMD} -f docker-compose.device.yml up -d
ExecStop=${DOCKER_COMPOSE_CMD} -f docker-compose.device.yml down
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

# Przeładowanie systemd i włączenie usługi
systemctl daemon-reload
systemctl enable "${SERVICE_NAME}"

echo "-------------------------------------------------------"
echo "Usługa ${SERVICE_NAME} została pomyślnie zainstalowana."
echo "-------------------------------------------------------"
echo "Zarządzanie usługą:"
echo "  Start:          sudo systemctl start ${SERVICE_NAME}"
echo "  Stop:           sudo systemctl stop ${SERVICE_NAME}"
echo "  Status:         sudo systemctl status ${SERVICE_NAME}"
echo "  Logi:           journalctl -u ${SERVICE_NAME} -f"
echo "  Autostart:      WŁĄCZONY"
echo "-------------------------------------------------------"
