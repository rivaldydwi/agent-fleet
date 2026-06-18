# 🤖 Agent Fleet

A self-hosted AI agent infrastructure powered by [OpenClaw](https://openclaw.ai) — running on bare metal, managed with Docker, and accessible via Telegram.

## Overview

This repository contains the infrastructure configuration for a personal AI agent fleet. Instead of relying on cloud-based AI assistants, every agent runs locally on a self-hosted server, with isolated memory and a dedicated purpose.

All agents share a single entry point through the **OpenClaw Gateway**, which handles routing, session management, and Telegram integration.

```
Telegram
    │
    ▼
┌─────────────────────┐
│   OpenClaw Gateway  │  ← Single bot token, central router
│   (port 18789)      │
└──────────┬──────────┘
           │
     ┌─────┴──────┐──────────────┐
     ▼            ▼              ▼
┌─────────┐ ┌──────────┐ ┌────────────┐
│ Career  │ │ Sensei   │ │ Portofolio │
│ Agent   │ │ Agent    │ │ Agent      │
│ :18790  │ │ :18792   │ │ :18791     │
└─────────┘ └──────────┘ └────────────┘
```

## Agents

| Container | Role | Port |
|---|---|---|
| `openclaw` | Gateway — single entry point, Telegram router | 18789 |
| `openclaw-career` | Career advisor — DevOps/Cloud Engineering transition | 18790 |
| `openclaw-portofolio` | Portfolio manager — tracks and develops project portfolio | 18791 |
| `openclaw-sensei` | Japanese tutor — focused on JLPT N2 (Kotoba, Kanji, Grammar) | 18792 |

## Architecture

- **Gateway Pattern** — One Telegram bot token handles all agents. No need to manage multiple bots.
- **Isolated Memory** — Each agent runs in its own Docker container with a dedicated volume. No context bleeding between agents.
- **Persistent Workspace** — Agent memory and workspace survive container restarts via Docker volumes.
- **Proactive Mode** — Agents can run scheduled tasks autonomously via OpenClaw's heartbeat/cron system.

## Infrastructure

| Component | Spec |
|---|---|
| Hardware | Dell OptiPlex 3000 Mini PC |
| CPU | Intel Core i5-12500T (12th Gen) |
| RAM | 16GB |
| OS | Ubuntu 24.04 LTS |
| Runtime | Docker + Docker Compose |
| Remote Access | Tailscale VPN |
| Timezone | Asia/Tokyo |

## Project Structure

```
agent-fleet/
├── docker-compose.yml   # Agent fleet (career, portofolio, sensei)
├── start_agent.sh       # Agent startup script
└── README.md
```

> **Note:** The OpenClaw Gateway (`openclaw`) is managed separately from this compose file, as it serves as the central router for all agents.

## Getting Started

### Prerequisites

- Docker & Docker Compose
- OpenClaw installed or pulled via `npm install -g openclaw`
- A Telegram bot token from [@BotFather](https://t.me/botfather)
- Google Gemini API key from [Google AI Studio](https://aistudio.google.com/apikey)

### Setup

1. Clone this repository:
   ```bash
   git clone https://github.com/rivaldydwi/agent-fleet.git
   cd agent-fleet
   ```

2. Configure the OpenClaw Gateway:
   ```bash
   docker run --rm -it -v openclaw-data:/root/.openclaw node:24 sh -c \
     "npm install -g openclaw && openclaw configure"
   ```

3. Start the agent fleet:
   ```bash
   docker compose up -d
   ```

4. Verify all agents are running:
   ```bash
   docker ps | grep openclaw
   ```

### Environment Variables

Each agent container uses the following environment variables:

| Variable | Description |
|---|---|
| `TZ` | Timezone (default: `Asia/Tokyo`) |

> API keys and bot tokens are configured inside each agent's OpenClaw workspace volume, not as environment variables. This keeps credentials isolated per agent.

## Monitoring

This fleet is monitored via a separate Prometheus + Grafana stack. See [portofolio-devops](https://github.com/rivaldydwi/portofolio-devops) for the monitoring infrastructure.

## Related Projects

- [portofolio-devops](https://github.com/rivaldydwi/portofolio-devops) — The DevOps infrastructure powering this server (Terraform, CI/CD, monitoring)
