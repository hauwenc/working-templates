#!/bin/bash
# Claude Code notification script
# Identifies the terminal session and shows a desktop notification.
# If using a notification daemon that supports actions (dunst), clicking focuses the terminal.

# Find the Claude process (parent of this hook)
CLAUDE_PID=$PPID

# Walk up process tree to find terminal emulator, tmux, and the shell's TTY
PID=$CLAUDE_PID
TERM_PID=""
TERM_TYPE=""
SHELL_PID=""
for i in $(seq 1 15); do
    PID=$(ps -o ppid= -p "$PID" 2>/dev/null | tr -d ' ')
    [ -z "$PID" ] || [ "$PID" = "1" ] || [ "$PID" = "0" ] && break
    COMM=$(ps -o comm= -p "$PID" 2>/dev/null)
    case "$COMM" in
        bash|zsh|fish|sh)
            [ -z "$SHELL_PID" ] && SHELL_PID=$PID ;;
        gnome-terminal-*|konsole|xterm|alacritty|kitty|tilix|terminator|xfce4-terminal|lxterminal|mate-terminal|st|foot|wezterm*)
            TERM_PID=$PID; TERM_TYPE="window"; break ;;
        tmux*)
            TERM_PID=$PID; TERM_TYPE="tmux"; break ;;
    esac
done

# Get the TTY (pts) for the shell — unique per tab/pane
TAB_ID=""
if [ -n "$SHELL_PID" ]; then
    TAB_ID=$(ps -o tty= -p "$SHELL_PID" 2>/dev/null | tr -d ' ')
fi

# Assign a session number (auto-incremented, persisted per Claude PID)
SESSION_DIR="/tmp/claude-sessions"
mkdir -p "$SESSION_DIR"
SESSION_FILE="$SESSION_DIR/$CLAUDE_PID"
if [ ! -f "$SESSION_FILE" ]; then
    # Clean up stale sessions (PIDs that no longer exist)
    for f in "$SESSION_DIR"/*; do
        [ -f "$f" ] && ! kill -0 "$(basename "$f")" 2>/dev/null && rm -f "$f"
    done
    # Assign next available number
    NEXT=1
    while [ -f "$(grep -rl "^$NEXT$" "$SESSION_DIR" 2>/dev/null | head -1)" ] 2>/dev/null; do
        NEXT=$((NEXT + 1))
    done
    echo "$NEXT" > "$SESSION_FILE"
fi
SESSION_NUM=$(cat "$SESSION_FILE")

# Build session identifier
SESSION_LABEL="$(basename "$PWD") #$SESSION_NUM"
if [ "$TERM_TYPE" = "tmux" ]; then
    PANE_TITLE=$(tmux display-message -p '#{window_name}:#{pane_index}' 2>/dev/null)
    [ -n "$PANE_TITLE" ] && SESSION_LABEL="$SESSION_LABEL [$PANE_TITLE]"
elif [ "$TERM_TYPE" = "window" ]; then
    WIN_ID=$(xdotool search --pid "$TERM_PID" 2>/dev/null | head -1)
fi

# Set tab title so the user can match notification to tab
# Claude Code resets the title, but at notification time it's idle so this sticks
if [ -n "$TAB_ID" ]; then
    printf '\033]0;Claude #%s — %s\007' "$SESSION_NUM" "$(basename "$PWD")" > "/dev/$TAB_ID" 2>/dev/null
fi

# Send notification
# If dunstify is available, add click-to-focus action
if command -v dunstify &>/dev/null && [ -n "$WIN_ID" ]; then
    ACTION=$(dunstify --action="focus,Focus terminal" "Claude Code" "$SESSION_LABEL — needs your attention")
    [ "$ACTION" = "focus" ] && xdotool windowactivate "$WIN_ID" 2>/dev/null
else
    notify-send "Claude Code" "$SESSION_LABEL — needs your attention"
fi
