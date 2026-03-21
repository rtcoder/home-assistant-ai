# Home Voice AI

Lokalny, prywatny asystent głosowy wspierający język polski, działający w architekturze rozproszonej (centralny serwer + węzły w pokojach).

## Szybki start (Docker / Podman)

### Scenariusz A: Wszystko na jednej maszynie (Testowanie)

1. **Uruchomienie serwera, brokera i testowego urządzenia:**
   ```bash
   docker-compose up -d server mqtt-broker
   docker-compose -f docker-compose.device.yml up -d
   ```

### Scenariusz B: Rozproszona instalacja (Serwer + Węzły)

W tym scenariuszu serwer z brokerem działają na jednej maszynie (np. serwerze domowym), a urządzenia (np. Raspberry Pi) na osobnych.

1. **Na maszynie SERWEROWEJ:**
   ```bash
   docker-compose up -d
   ```
   To uruchomi Serwer AI oraz Broker MQTT.

2. **Na każdym URZĄDZENIU (node):**
   Upewnij się, że masz pliki `Dockerfile.device`, `docker-compose.device.yml` oraz katalog `device/` na urządzeniu, a następnie:
   ```bash
   export MQTT_BROKER=IP_TWOJEGO_SERWERA
   docker-compose -f docker-compose.device.yml up -d
   ```

*Uwaga: Węzły głosowe wymagają dostępu do urządzeń audio (`/dev/snd`), co działa najlepiej na Linuxie.*

## Pobieranie modeli LLM (Lokalnie)

**Uwaga:** Od teraz obrazy Docker serwera są budowane z domyślnie pobranymi modelami. Jeśli jednak chcesz pobrać je ręcznie lub zaktualizować, wykonaj poniższe komendy wewnątrz kontenera lub na hoście (jeśli masz zainstalowaną Ollamę):

```bash
# Wykonanie bezpośrednio w kontenerze serwera:
docker exec -it home-voice-ai-server ollama pull bielik
docker exec -it home-voice-ai-server ollama pull qwen2.5:32b
docker exec -it home-voice-ai-server ollama pull llama3.1:70b-instruct-q3_K_M
```

## Struktura projektu

- `server/` - Centralna jednostka przetwarzająca (STT, LLM, TTS).
- `device/` - Oprogramowanie dla węzłów głosowych (Raspberry Pi).
- `mosquitto/` - Konfiguracja brokera MQTT.

## Dokumentacja

- [Instalacja OpenClaw](OPENCLAW_INSTALL.md) - instrukcja dla asystenta AI.
- [Kontekst projektu](home-voice-ai-project-context.md) - szczegółowe założenia i architektura.

## Konfiguracja OpenClaw w Dockerze

Jeśli korzystasz z obrazu serwera, OpenClaw jest już zainstalowany. Aby go skonfigurować:

1. **Uruchom onboard w kontenerze:**
   ```bash
   docker exec -it home-voice-ai-server openclaw onboard
   ```
2. **Sprawdź status:**
   ```bash
   docker exec -it home-voice-ai-server openclaw status
   ```

Dane OpenClaw są przechowywane w wolumenie `./openclaw-data` na Twoim hoście.

## Rozwój

Projekt korzysta z:
- **Python 3.11+**
- **MQTT** (Mosquitto)
- **Ollama / OpenClaw** (runtime LLM)
- **Porcupine** (Wake word detection)