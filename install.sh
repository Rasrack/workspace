#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
THIRDPARTY="${SCRIPT_DIR}/thirdparty"

ln -s -f "${THIRDPARTY}/oh-my-tmux/.tmux.conf" "${HOME}/.tmux.conf"
ln -s -f "${SCRIPT_DIR}/tmux.config.local" "${HOME}/.tmux.conf.local"
ln -s -f "${SCRIPT_DIR}/emacs_config" "${HOME}/.emacs"
