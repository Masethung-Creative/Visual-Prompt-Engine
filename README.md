<div align="center">

# 🎬 Visual Prompt Engine

**Cinematographer-grade prompts for AI image and video models — as an Agent Skill.**

Turns a scene idea, script beat or emotion into precise camera, lens and lighting telemetry for
Midjourney · Stable Diffusion / SDXL / ComfyUI · Flux · DALL-E / GPT-Image · Imagen · Ideogram · Runway · Kling · Veo · Sora · Pika · Luma

![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)
![Platforms](https://img.shields.io/badge/platforms-macOS%20%7C%20Linux%20%7C%20Windows-lightgrey)
![Agent Skills](https://img.shields.io/badge/format-SKILL.md-orange)

</div>

---

## Contents

- [Quick install](#quick-install)
- [Supported agents](#supported-agents)
- [Installer options](#installer-options)
- [Other install methods](#other-install-methods)
- [Usage](#usage)
- [What the skill does](#what-the-skill-does)
- [Repository structure](#repository-structure)
- [Uninstall](#uninstall)
- [Contributing](#contributing)
- [License](#license)

---

## Quick install

| Platform | Command |
|---|---|
| **macOS / Linux** (Terminal) | `curl -fsSL https://raw.githubusercontent.com/Masethung-Creative/Visual-Prompt-Engine/main/install.sh \| bash` |
| **Windows** (PowerShell) | `irm https://raw.githubusercontent.com/Masethung-Creative/Visual-Prompt-Engine/main/install.ps1 \| iex` |
| **Claude Code** (any OS) | `/plugin marketplace add Masethung-Creative/Visual-Prompt-Engine`<br>`/plugin install visual-prompt-engine@visual-prompt-engine` |
| **Any agent** (Node.js 22+) | `npx skills add Masethung-Creative/Visual-Prompt-Engine` |
| **Claude app** (web, desktop, mobile) | Download `visual-prompt-engine.skill` from [Releases](../../releases/latest) and upload it in Claude's skill settings |

The terminal and PowerShell installers install for **Claude Code** by default. To install for every supported agent at once:

```bash
# macOS / Linux
curl -fsSL https://raw.githubusercontent.com/Masethung-Creative/Visual-Prompt-Engine/main/install.sh | bash -s -- --agent all
```

```powershell
# Windows PowerShell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/Masethung-Creative/Visual-Prompt-Engine/main/install.ps1))) -Agent all
```

Restart your agent after installing.

---

## Supported agents

| Agent | `--agent` value | User install location | Project install location (`--project`) |
|---|---|---|---|
| Claude Code | `claude` | `~/.claude/skills/` | `./.claude/skills/` |
| OpenAI Codex CLI | `codex` | `~/.agents/skills/` | `./.agents/skills/` |
| GitHub Copilot (VS Code / CLI) | `copilot` | `~/.copilot/skills/` | `./.github/skills/` |
| Cursor, Gemini CLI, OpenCode, Amp, Goose and others | — | use `npx skills add` | use `npx skills add` |
| ChatGPT, Gemini web (no skill support) | — | paste `SKILL.md` into custom instructions; upload `references/` as knowledge files | — |

On Windows, `~` means your user folder, for example `C:\Users\<you>`.
Skill folder locations are set by each tool and can change; check the tool's documentation if an agent does not pick the skill up.

---

## Installer options

| macOS / Linux | Windows | Meaning |
|---|---|---|
| `--agent claude` | `-Agent claude` | Install for one agent (default) |
| `--agent claude,codex` | `-Agent "claude,codex"` | Install for several agents |
| `--agent all` | `-Agent all` | Claude Code, Codex and Copilot |
| `--project` | `-Project` | Install into the current project instead of your user folder |
| `--uninstall` | `-Uninstall` | Remove the skill |
| `--help` | `Get-Help .\install.ps1` | Show help |

---

## Other install methods

### From a cloned copy

```bash
git clone https://github.com/Masethung-Creative/Visual-Prompt-Engine
cd Visual-Prompt-Engine
./install.sh --agent all          # macOS / Linux
.\install.ps1 -Agent all          # Windows PowerShell
```

If PowerShell blocks the script, run once: `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`

### Fully manual

Copy the folder `plugins/visual-prompt-engine/skills/visual-prompt-engine/` into your agent's skills folder from the table above.

---

## Usage

Describe the shot in plain words:

> A woman waiting alone at a rain-soaked bus stop at night. Feels lonely. Give me Midjourney and SDXL prompts.

You get:

1. **Telemetry table** — the 8 slots: framing, camera geometry, subject, Z-depth, lighting, atmosphere, optics, capture & grade
2. **Paste-ready prompts** — universal natural language, Midjourney (with parameters), Stable Diffusion (positive, negative, settings)
3. **Motion block** for video tools, when asked
4. **Continuity locks** for multi-shot or character-consistent work
5. **Variations** — one-line slot swaps

---

## What the skill does

| Capability | Description |
|---|---|
| 8-slot syntax matrix | Every visual decision stated as a measurable value |
| Emotion-to-optics dictionary | "Heroic", "lonely", "paranoid" → focal length, angle, contrast ratio, Kelvin |
| Token-decay ordering | Structure first, style last; colour bound to nouns to prevent bleed |
| Conflict checks | Removes contradictions such as macro + extreme wide, high-key + noir |
| Platform formats | Natural-language models, Midjourney, Stable Diffusion, video generators |
| Continuity locks | Character and look strings for consistent multi-shot sequences |
| ControlNet recipes | Pose, depth and edge conditioning stacks for ComfyUI |

Full taxonomies live in `references/` (Stage 1: composition, camera and lighting · Stage 2: optics, sensor and colour · Stage 3: the prompt engine).

---

## Repository structure

```
visual-prompt-engine/
├── .claude-plugin/
│   └── marketplace.json            Claude Code marketplace catalogue
├── .github/workflows/
│   ├── validate.yml                Checks structure and installers on every push
│   └── release.yml                 Builds the .skill file when a version tag is pushed
├── plugins/
│   └── visual-prompt-engine/
│       ├── .claude-plugin/
│       │   └── plugin.json         Plugin manifest
│       └── skills/
│           └── visual-prompt-engine/
│               ├── SKILL.md        The engine workflow
│               └── references/     Stage 1–3 reference taxonomies
├── install.sh                      macOS / Linux installer
├── install.ps1                     Windows PowerShell installer
├── README.md
├── CHANGELOG.md
├── CONTRIBUTING.md
├── LICENSE
├── .gitattributes                  Correct line endings on every OS
└── .gitignore
```

---

## Uninstall

| Platform | Command |
|---|---|
| macOS / Linux | `curl -fsSL https://raw.githubusercontent.com/Masethung-Creative/Visual-Prompt-Engine/main/install.sh \| bash -s -- --uninstall --agent all` |
| Windows | `& ([scriptblock]::Create((irm https://raw.githubusercontent.com/Masethung-Creative/Visual-Prompt-Engine/main/install.ps1))) -Uninstall -Agent all` |
| Claude Code plugin | `/plugin uninstall visual-prompt-engine@visual-prompt-engine` |

---

## Contributing

Improvements are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSE) © 2026 K. Sivasarathy
