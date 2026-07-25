# shellcheck shell=bash

run_segment() {
  local binary="$HOME/.tmux/plugins/tmux-codex/bin/codex-quota"
  [ -x "$binary" ] || return 0
  "$binary"
}
