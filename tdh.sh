#!/bin/bash

run_verbose_in_startup() {
    local session="$1"
    local path="$2"
    shift 2
    local cmd="$*"

    if ! tmux list-windows -t "$session" | grep -q "^startup"; then
        tmux new-window -t "$session" -c "$path" -n "startup"
    fi

    tmux send-keys -t "$session:startup" "$cmd" C-m
}

path=""
use_docker=false
use_sail=false
use_make=false
verbose=false

for arg in "$@"; do
    case "$arg" in
    --docker)
        use_docker=true
        ;;
    --sail)
        use_sail=true
        ;;
    --make)
        use_make=true
        ;;
    --verbose)
        verbose=true
        ;;
    *)
        path="$arg"
        ;;
    esac
done

path="${path:-$PWD}"
session=$(basename "$path")

if $use_docker && $use_sail; then
    echo "Error: do not use --docker and --sail at the same time."
    exit 1
fi

if ! tmux has-session -t "$session" 2>/dev/null; then
    tmux new-session -d -s "$session" -c "$path" -n nvim "nvim"
    tmux new-window -c "$path" -n "shell"

    if [ -d "$path/.git" ] || git -C "$path" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        tmux new-window -c "$path" -n "git" "lazygit"
    fi

    if $use_docker; then
        if [ -f "$path/docker-compose.yml" ]; then
            tmux new-window -c "$path" -n "docker" "lazydocker"

            if $verbose; then
                run_verbose_in_startup "$session" "$path" "docker compose -f \"$path/docker-compose.yml\" up -d --build; read"
            else
                docker compose -f "$path/docker-compose.yml" up -d --build >/dev/null 2>&1 &
            fi
        fi
    elif $use_sail; then
        if [ -x "$path/vendor/bin/sail" ]; then
            tmux new-window -c "$path" -n "docker" "lazydocker"

            if $verbose; then
                run_verbose_in_startup "$session" "$path" "\"$path/vendor/bin/sail\" up --build -d; read"
            else
                "$path/vendor/bin/sail" up -d --build >/dev/null 2>&1 &
            fi
        fi
    fi

    if $use_make; then
        if [ -f "$path/Makefile" ]; then
            if $verbose; then
                run_verbose_in_startup "$session" "$path" "make"
            else
                tmux new-window -c "$path" -n "make" "make; read"
            fi
        fi
    fi

    tmux select-window -t "$session:1"
fi

tmux attach-session -t "$session"
