#!/usr/bin/env bash
# visual-prompt-engine installer for macOS and Linux
#
#   curl -fsSL https://raw.githubusercontent.com/Masethung-Creative/Visual-Prompt-Engine/main/install.sh | bash
#   curl -fsSL .../install.sh | bash -s -- --agent all
#   ./install.sh --agent codex --project
#   ./install.sh --uninstall
#
# Options
#   --agent <list>   claude | codex | copilot | all   (comma-separated, default: claude)
#   --project        install into the current project folder instead of your home folder
#   --uninstall      remove the skill
#   -h, --help       show this help

set -euo pipefail

REPO="${VPE_REPO:-Masethung-Creative/Visual-Prompt-Engine}"
BRANCH="${VPE_BRANCH:-main}"
SKILL="visual-prompt-engine"
SUBPATH="plugins/${SKILL}/skills/${SKILL}"

AGENTS="claude"
SCOPE="user"
ACTION="install"

info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
ok()   { printf '\033[1;32m ✓\033[0m %s\n' "$*"; }
fail() { printf '\033[1;31m ✗\033[0m %s\n' "$*" >&2; exit 1; }

usage() { sed -n '2,15p' "$0" 2>/dev/null | sed 's/^# \{0,1\}//'; exit 0; }

while [ $# -gt 0 ]; do
  case "$1" in
    --agent)     [ $# -ge 2 ] || fail "--agent needs a value"; AGENTS="$2"; shift 2 ;;
    --agent=*)   AGENTS="${1#*=}"; shift ;;
    --project)   SCOPE="project"; shift ;;
    --uninstall) ACTION="uninstall"; shift ;;
    -h|--help)   usage ;;
    *)           fail "Unknown option: $1 (use --help)" ;;
  esac
done

[ "$AGENTS" = "all" ] && AGENTS="claude,codex,copilot"

skills_dir() {
  local agent="$1"
  if [ "$SCOPE" = "project" ]; then
    case "$agent" in
      claude)  echo "$PWD/.claude/skills" ;;
      codex)   echo "$PWD/.agents/skills" ;;
      copilot) echo "$PWD/.github/skills" ;;
      *)       return 1 ;;
    esac
  else
    case "$agent" in
      claude)  echo "$HOME/.claude/skills" ;;
      codex)   echo "$HOME/.agents/skills" ;;
      copilot) echo "$HOME/.copilot/skills" ;;
      *)       return 1 ;;
    esac
  fi
}

# Locate the skill source: the local clone if run from one, otherwise download.
SRC=""
TMP=""
cleanup() { if [ -n "$TMP" ]; then rm -rf "$TMP"; fi; }
trap cleanup EXIT

get_source() {
  local here
  here="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || true)"
  if [ -n "$here" ] && [ -f "$here/$SUBPATH/SKILL.md" ]; then
    SRC="$here/$SUBPATH"
    return
  fi
  command -v curl >/dev/null 2>&1 || fail "curl is required"
  command -v tar  >/dev/null 2>&1 || fail "tar is required"
  TMP="$(mktemp -d)"
  info "Downloading ${REPO}@${BRANCH}"
  curl -fsSL "https://codeload.github.com/${REPO}/tar.gz/refs/heads/${BRANCH}" | tar -xz -C "$TMP" \
    || fail "Download failed — check the repository name and your internet connection"
  SRC="$(find "$TMP" -maxdepth 1 -mindepth 1 -type d | head -n1)/$SUBPATH"
  [ -f "$SRC/SKILL.md" ] || fail "SKILL.md not found in downloaded archive"
}

[ "$ACTION" = "install" ] && get_source

IFS=',' read -r -a LIST <<< "$AGENTS"
for agent in "${LIST[@]}"; do
  agent="$(echo "$agent" | tr '[:upper:]' '[:lower:]' | tr -d ' ')"
  dir="$(skills_dir "$agent")" || fail "Unknown agent '$agent' (use claude, codex, copilot or all)"
  target="$dir/$SKILL"
  if [ "$ACTION" = "uninstall" ]; then
    if [ -d "$target" ]; then rm -rf "$target"; ok "Removed from $agent: $target"
    else info "Not installed for $agent ($target)"; fi
  else
    mkdir -p "$dir"
    rm -rf "$target"
    cp -R "$SRC" "$target"
    ok "Installed for $agent: $target"
  fi
done

[ "$ACTION" = "install" ] && info "Done. Restart your agent, then ask for a cinematic image or video prompt."
exit 0
