# Jak pobrać i zainstalować OpenClaw (openclaw.ai)

OpenClaw to nowoczesny, otwartoźródłowy asystent AI, którego możesz uruchomić na własnych urządzeniach. Obsługuje integrację z popularnymi komunikatorami (WhatsApp, Telegram, Discord, Signal i inne) oraz pozwala na pełną kontrolę nad Twoimi danymi i modelem AI.

## Wymagania wstępne
- **Node.js** (wersja >= 22)
- Menedżer pakietów: `npm`, `pnpm` lub `bun`
- System operacyjny: macOS, Linux lub Windows (przez WSL2)

## Instalacja w Dockerze (Serwer)

W naszym projekcie `Dockerfile.server` automatycznie instaluje OpenClaw. Jeśli używasz `docker-compose.yml`, wystarczy:

1. **Uruchomienie serwera:**
   ```bash
   docker-compose up -d server
   ```

2. **Skonfigurowanie OpenClaw wewnątrz kontenera:**
   ```bash
   docker exec -it home-voice-ai-server openclaw onboard
   ```
   *Ważne: W kontenerze nie używaj flagi `--install-daemon`, po prostu skonfiguruj swoje kanały i AI.*

## Instalacja (Zalecana)

Najprostszym sposobem instalacji jest użycie globalnego pakietu `npm` i kreatora konfiguracji.

1. Zainstaluj OpenClaw globalnie:
   ```bash
   npm install -g openclaw@latest
   ```

2. Uruchom kreator konfiguracji (onboarding):
   ```bash
   openclaw onboard --install-daemon
   ```
   Flaga `--install-daemon` spowoduje, że asystent będzie działał w tle jako usługa systemowa (launchd na macOS lub systemd na Linux).

3. Postępuj zgodnie z instrukcjami na ekranie, aby:
   - Skonfigurować dostawców AI:
     - **Ollama:** Kluczowe dla modeli lokalnych (Bielik, Qwen, Llama). Upewnij się, że Ollama działa na tym samym hostie lub jest dostępna w sieci.
   - Sparować kanały komunikacji (np. zeskanować kod QR dla WhatsApp).
   - Wybrać umiejętności (skills).

## Instalacja z kodów źródłowych (dla deweloperów)

Jeśli chcesz modyfikować kod lub używać najnowszej wersji rozwojowej:

1. Sklonuj repozytorium:
   ```bash
   git clone https://github.com/openclaw/openclaw.git
   cd openclaw
   ```

2. Zainstaluj zależności:
   ```bash
   pnpm install
   ```

3. Uruchom w trybie deweloperskim:
   ```bash
   pnpm run dev
   ```

## Użycie CLI

- **Sprawdzenie statusu:** `openclaw status`
- **Uruchomienie bramki:** `openclaw gateway --verbose`
- **Wysłanie wiadomości:** `openclaw message send --to <numer> --message "Cześć z OpenClaw"`
- **Interakcja z agentem:** `openclaw agent --message "Jaka jest pogoda?"`

## Przydatne linki
- [Oficjalna strona](https://openclaw.ai)
- [Dokumentacja](https://docs.openclaw.ai)
- [Repozytorium GitHub](https://github.com/openclaw/openclaw)
