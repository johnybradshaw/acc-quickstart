#!/bin/bash
# Check if we're not already in a tmux session
if [ -z "$TMUX" ]; then
  # Attempt to attach to an existing session, create a new one if none exists
  tmux attach-session -t default || tmux new-session -s default
  exit
fi

# Once in a session
if [ "$TMUX" ]; then
  # Run commands
  neofetch # Show system info
  uptime # Show system uptime
fi