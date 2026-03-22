# Home Voice AI

Lokalny, prywatny asystent głosowy wspierający język polski, działający w architekturze rozproszonej (centralny serwer + węzły w pokojach).

## Szybki start (Docker / Podman)

Docker nie jest jedynym rozwiązaniem, ale zapewnia najszybszą izolację. Możesz zamiennie używać **Podman** (jeśli wolisz rootless) lub uruchamiać system bezpośrednio na hostingu (patrz: [Alternatywy dla Dockera](#alternatywy-dla-dockera)).

1. **Na serwerze:**
   ```bash
   ./run.sh
   ```
2. **Na urządzeniu (node):**
   ```bash
   ./run-device.sh
   ```

### Aktualizacja systemu

Aby pobrać najnowsze zmiany z repozytorium i zaktualizować kontenery:

1. **Na serwerze:**
   ```bash
   ./update.sh
   ```
2. **Na urządzeniu (node):**
   ```bash
   ./update-device.sh
   ```

*(Poniżej znajdziesz również instrukcje manualne oraz konfigurację autostartu).*

### Instalacja jako usługa (Autostart)

Jeśli chcesz, aby system uruchamiał się automatycznie po starcie systemu (Linux/systemd), użyj poniższych skryptów:

1. **Na serwerze:**
   ```bash
   sudo ./setup-service.sh
   ```
2. **Na urządzeniu (node):**
   ```bash
   sudo ./setup-device-service.sh
   ```

Skrypty te utworzą usługi systemowe, które będą zarządzać kontenerami Docker w tle.

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
docker exec -it home-voice-ai-server ollama pull llama3.1:8b
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

## Alternatywy dla Dockera

Jeśli nie chcesz używać Dockera, możesz zapewnić hermetyczność w następujący sposób:

1. **Podman:** Bezpośredni zamiennik Dockera. Skrypty `run.sh` oraz `setup-service.sh` są z nim kompatybilne (wystarczy alias `docker=podman`).
2. **Venv + Systemd:** Najlżejsza forma izolacji. 
   - Izolacja bibliotek Pythona (`python -m venv venv`).
   - Izolacja procesu i autostart przez `systemd` (patrz sekcja "Instalacja jako usługa").
   - Wymaga ręcznej instalacji zależności systemowych (np. `portaudio`, `nodejs`, `ollama`).
3. **Nix / NixOS:** Pozwala na pełną, deklaratywną izolację środowiska bez narzutu wirtualizacji (opcja dla zaawansowanych).

**Werdykt:** Docker/Podman jest zalecany dla **Serwera**, ponieważ ułatwia zarządzanie ciężkimi zależnościami (Ollama, modele 40GB+). Dla **Urządzeń** (Raspberry Pi) często lepszym rozwiązaniem jest `venv`, aby uniknąć problemów z dostępem do sterowników dźwięku (`ALSA/PulseAudio`).