#!/usr/bin/env bash
set -eu pipefail

SCRIPT_DIR="$(dirname $0)"

ln -s "$SCRIPT_DIR/.tmux.conf" "$HOME/.tmux.conf"
