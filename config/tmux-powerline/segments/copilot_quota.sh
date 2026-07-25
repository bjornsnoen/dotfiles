# shellcheck shell=bash

run_segment() {
  local binary="$HOME/.tmux/plugins/tmux-copilot/bin/copilot-quota"
  [ -x "$binary" ] || return 0
  "$binary"
}
