#!/usr/bin/env bash
# Fuzzy find for a directory in $HOME to open a new tmux session with.

if [ -z "$SESH_PATH" ]; then
  echo "Warning: Environment variable SESH_PATH is not set."
  echo "Add directories to SESH_PATH to use sesh."
  exit 1
fi

tmux_paths=$(tmux ls -F "#{session_path}" 2>/dev/null)
sesh_paths=""
while IFS=':' read -ra PATHS; do
  for search_dir in "${PATHS[@]}"; do
    expanded_dir=$(eval echo "$search_dir")
    if [ -d "$expanded_dir" ]; then
      found=$(find "$expanded_dir" -mindepth 0 -maxdepth 1 -type d 2>/dev/null)
      sesh_paths="${sesh_paths}${found}"$'\n'
    fi
  done
done <<< "$SESH_PATH"

path=$(
  {
    echo "$sesh_paths"
    echo "$tmux_paths" | awk '{print "\033[32m" $0 "\033[0m"}' # Color tmux paths with existing sessions green
  } | sort -u | fzf  --prompt="path > " --ansi --tmux center,50% --color='border:grey' --border-label="tmux sesh" --border='sharp' --border-label-pos=3
)

# Strip ANSI
# shellcheck disable=SC2001
path=$(echo "$path" | sed 's/\x1b\[[0-9;]*m//g')

if [ -z "$path" ]; then
  exit 0
fi

if [ ! -d "$path" ]; then
  echo "Error: Directory '$path' does not exist"
  exit 1
fi

# Check if the chosen path has a tmux session
grep -qxF "$path" <<< "$tmux_paths"
exists=$?

if [ $exists -ne 0 ]; then
  # News session with unique name
  base_name=$(basename "$path" | tr '.' '-')
  session="$base_name"
  counter=1
  while tmux has-session -t "$session" 2>/dev/null; do
    session="${base_name}-${counter}"
    ((counter++))
  done

  tmux new -d -s "$session" -c "$path"
  tmux send -t "$session:0" 'nvim' C-m # Open nvim window 0
  tmux neww -t "$session:1" -c "$path" # Term in window 1
  # Lazygit in window 2 if path is git repo
  if [ -d "$path/.git" ]; then
    tmux neww -t "$session:2" -c "$path"
    tmux send -t "$session:2" 'lazygit' C-m
  fi
  # Select window 0
  tmux selectw -t "$session:0"
else
  # Session name lookup from path
  session=$(tmux ls -F "#{session_name}:#{session_path}" 2>/dev/null | grep ":$path$" | cut -d: -f1 | head -n1)
fi

# Attach
if [ -n "$TMUX" ]; then
  tmux switchc -t "$session"
else
  tmux attach -t "$session"
fi

exit 0
