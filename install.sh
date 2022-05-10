#!/usr/bin/env bash
set -eu pipefail

SCRIPT_DIR="$(realpath "$(dirname "$0")")"

ln -s "$SCRIPT_DIR/.tmux.conf" "$HOME/.tmux.conf"
ln -s "$SCRIPT_DIR/.emacs" "$HOME/.emacs"
