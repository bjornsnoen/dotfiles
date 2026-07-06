#!/usr/bin/env bash
# Dracula custom plugin wrapper for tmux-copilot (user config, not part of
# either plugin repo). Dracula renders the segment; the binary provides text.
BINARY="$HOME/.tmux/plugins/tmux-copilot/bin/copilot-quota"
if [ -x "$BINARY" ]; then
  exec "$BINARY"
fi
echo "copilot: not built"
