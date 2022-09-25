#!/bin/bash

tmux_session() {
    set -euo pipefail
    if [ "$#" -eq 0 ]
    then
        echo "One argument with session name is needed"
        exit 1
    fi

    SESSION_NAME=$1

    tmux new-session -s "$SESSION_NAME" -d \; splitw -h \; splitw

    # Select window #1 and attach to the session
    tmux select-pane -t "$SESSION_NAME:1.1"
    tmux -2 attach-session -t "$SESSION_NAME"
    set +euo pipefail
}
