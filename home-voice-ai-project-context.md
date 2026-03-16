# Home Voice AI

## Project goal

We are building a **local, privacy‑focused voice assistant for home
automation**, similar to Google Nest / Alexa but:

-   fully self‑hosted
-   privacy‑first
-   Polish language support
-   extensible with local AI models
-   multi-room voice nodes
-   optional displays in rooms

The system should work like a **distributed voice assistant**.

Example interaction:

User in kitchen:

"hej dom jaka będzie pogoda jutro"

System:

1.  Kitchen microphone detects wake word
2.  Audio is sent to the central server
3.  Server transcribes speech
4.  AI interprets request
5.  Action is executed
6.  Response is sent back to **only that room**
7.  Speaker plays response
8.  Optional screen displays additional information

------------------------------------------------------------------------

# High level architecture

System has two main parts.

repo ├ server └ device

Server = central brain\
Device = voice nodes installed in rooms.

------------------------------------------------------------------------

# Hardware architecture

## Central server

Runs on:

MacBook Pro M4 Max 128GB RAM (development)\
Later possibly Mac Mini AI server.

Responsibilities:

-   speech recognition
-   LLM inference
-   agent logic
-   integrations
-   routing responses

------------------------------------------------------------------------

## Voice nodes

Each room contains:

-   Raspberry Pi
-   microphone array
-   speaker
-   optional display

Example nodes:

-   kitchen
-   living_room
-   bedroom
-   office
-   bathroom

------------------------------------------------------------------------

# Multi-room behaviour

Important rule:

Response should be played **only on the speaker that detected the wake
word**.

Example:

Kitchen node hears:

"hej dom jaka pogoda"

Response must go only to:

kitchen speaker

------------------------------------------------------------------------

# Wake word handling

Wake word detection is done **locally on each node**.

Example wake word:

"hej dom"

Process:

1 device detects wake word 2 device locks session 3 device records audio
4 audio is sent to server

------------------------------------------------------------------------

# Request flow

User speech ↓ Device wake word detection ↓ Device records audio ↓ Audio
sent to server ↓ Speech to text ↓ AI intent detection ↓ Agent logic ↓
Optional action execution ↓ Text response ↓ Text to speech ↓ Audio
returned to device ↓ Speaker output ↓ Optional display rendering

------------------------------------------------------------------------

# Server responsibilities

Server is responsible for:

-   STT (speech-to-text)
-   LLM reasoning
-   intent detection
-   agent actions
-   integrations
-   TTS (text-to-speech)
-   routing response to correct device
-   managing conversation sessions

------------------------------------------------------------------------

# Device responsibilities

Device must stay lightweight.

Responsibilities:

-   wake word detection
-   recording audio
-   sending audio to server
-   playing audio response
-   optional screen rendering

Devices should contain minimal logic.

------------------------------------------------------------------------

# Communication

Devices communicate with server via network.

Possible transports:

MQTT (preferred)\
HTTP\
WebSocket

MQTT topics example:

voice/kitchen/request\
voice/kitchen/response\
voice/kitchen/display

------------------------------------------------------------------------

# Server software architecture

server ├ api ├ audio ├ llm ├ agent ├ integrations ├ mqtt ├ sessions └
main

------------------------------------------------------------------------

## api

Handles HTTP or websocket endpoints used by devices.

Example:

POST /voice/query

Payload:

{ device_id: "kitchen-1", room: "kitchen", audio: "...binary..." }

------------------------------------------------------------------------

## audio

Handles audio pipeline.

Modules:

stt.py\
tts.py\
audio_utils.py

Responsibilities:

audio → text\
text → speech

------------------------------------------------------------------------

## llm

Interface to local LLM runtime.

LLM runtime:

Ollama lub OpenClaw (openclaw.ai)

LLM tasks:

-   natural language understanding
-   intent extraction
-   generating conversational response

------------------------------------------------------------------------

## agent

Responsible for interpreting requests and triggering actions.

Example:

"jaka pogoda"

intent:

weather.get

action:

call weather API

------------------------------------------------------------------------

## integrations

External integrations:

weather\
home automation\
calendar\
system monitoring

------------------------------------------------------------------------

## mqtt

Handles communication with devices.

Example topics:

voice/device/request\
voice/device/response\
voice/device/wake

------------------------------------------------------------------------

## sessions

Manages conversational state.

Example:

active_room = kitchen\
session_timeout = 10s

------------------------------------------------------------------------

# Device software architecture

device ├ audio ├ wakeword ├ communication ├ display ├ config └ main

------------------------------------------------------------------------

## audio

Handles microphone and speaker.

Modules:

microphone.py\
recorder.py\
speaker.py

------------------------------------------------------------------------

## wakeword

Wake word detection engine.

Example engine:

Porcupine

Process:

audio stream → wake word → trigger recording.

------------------------------------------------------------------------

## communication

Handles communication with server.

Modules:

mqtt_client.py\
api_client.py

Responsibilities:

send audio\
receive responses\
receive screen commands

------------------------------------------------------------------------

## display

Optional screen rendering.

Example widgets:

clock\
weather\
calendar\
AI response

------------------------------------------------------------------------

## config

Device configuration file.

Example:

device.yaml

device_id: kitchen-1\
room: kitchen\
server: 192.168.1.10\
mic: respeaker\
speaker: usb\
display: hdmi

------------------------------------------------------------------------

## main loop

Device runtime loop:

while true\
detect wake word\
record audio\
send audio to server\
wait response\
play response\
render screen

------------------------------------------------------------------------

# Design goals

privacy first\
local AI models\
modular architecture\
multi-room support\
minimal device logic\
centralized AI processing

------------------------------------------------------------------------

# Development strategy

Step 1\
Single device + server prototype

Step 2\
Stable audio pipeline

Step 3\
LLM intent detection

Step 4\
Multi-room support

Step 5\
Display UI

Step 6\
Home automation integrations

------------------------------------------------------------------------

# Long term vision

A fully local distributed AI home assistant system with:

-   multiple rooms
-   conversational AI
-   local knowledge
-   home automation
-   privacy by design
