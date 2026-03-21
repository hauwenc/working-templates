#!/usr/bin/env bash
# Claude Code status line — candy-themed prompt with context and rate-limit info
# Cross-platform: Linux, macOS, Windows (Git Bash / MSYS2)

input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')

# Shorten home directory to ~
home="$HOME"
display_cwd="${cwd/#$home/\~}"

# Git branch info (skip optional locks)
git_branch=""
if git -C "$cwd" --no-optional-locks rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
  branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    if git -C "$cwd" --no-optional-locks diff --quiet 2>/dev/null && \
       git -C "$cwd" --no-optional-locks diff --cached --quiet 2>/dev/null; then
      git_branch="\033[0;33m[${branch}]\033[0m "
    else
      git_branch="\033[0;33m[${branch} \033[0;31m*\033[0;33m]\033[0m "
    fi
  fi
fi

# Context window usage
used_pct_raw=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
if [ -z "$used_pct_raw" ]; then
  used_pct="-"
else
  used_pct=$(printf '%.0f' "$used_pct_raw")
fi

# Total tokens used this session (input + output, cumulative)
total_in=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
total_out=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
total_tokens=$((total_in + total_out))

# Rate limits (5-hour and 7-day)
rate_5h_raw=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
rate_7d_raw=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
if [ -z "$rate_5h_raw" ]; then rate_5h="-"; else rate_5h=$(printf '%.0f' "$rate_5h_raw"); fi
if [ -z "$rate_7d_raw" ]; then rate_7d="-"; else rate_7d=$(printf '%.0f' "$rate_7d_raw"); fi

# Color helper: green <50%, yellow 50-80%, red >80%
color_pct() {
  local val="$1"
  if [ "$val" != "-" ] && [ "$val" -ge 80 ] 2>/dev/null; then echo "\033[0;31m"
  elif [ "$val" != "-" ] && [ "$val" -ge 50 ] 2>/dev/null; then echo "\033[0;33m"
  else echo "\033[0;32m"; fi
}
ctx_color=$(color_pct "$used_pct")
rate_5h_color=$(color_pct "$rate_5h")
rate_7d_color=$(color_pct "$rate_7d")

time_str=$(date +%H:%M:%S)
user_name="${USER:-${USERNAME:-$(whoami)}}"
host_name="${HOSTNAME%%.*}"
[ -z "$host_name" ] && host_name=$(hostname 2>/dev/null | cut -d. -f1)

printf "\033[1;32m%s@%s\033[0m \033[0;34m[%s]\033[0m \033[0;37m[%s]\033[0m %b${ctx_color}[ctx:%s%%]\033[0m \033[0;36m[tok:%s]\033[0m ${rate_5h_color}[5h:%s%%]\033[0m ${rate_7d_color}[7d:%s%%]\033[0m \033[0;34m->\033[0m" \
  "$user_name" "$host_name" "$time_str" "$display_cwd" "$git_branch" "$used_pct" "$total_tokens" "$rate_5h" "$rate_7d"
