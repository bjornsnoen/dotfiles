# Dracula palette for tmux-powerline.
TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR="#44475a"
TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR="#f8f8f2"

# Reuse tmux-powerline's window formats and separator setup with our defaults.
source "${TMUX_POWERLINE_DIR_THEMES}/default.sh"

TMUX_POWERLINE_WINDOW_STATUS_CURRENT=(
  "#[fg=#44475a,bg=#8be9fd]"
  "$TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR"
  "#[fg=#282a36,bg=#8be9fd] #I #W#F "
  "#[fg=#8be9fd,bg=#44475a]"
  "$TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR"
)

TMUX_POWERLINE_WINDOW_STATUS_STYLE=(
  "fg=#f8f8f2,bg=#44475a"
)

TMUX_POWERLINE_WINDOW_STATUS_FORMAT=(
  "#[fg=#f8f8f2,bg=#44475a] #I #W#F "
)

TMUX_POWERLINE_LEFT_STATUS_SEGMENTS=(
  "smiley #50fa7b #282a36"
)

TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS=(
  "copilot_quota #8be9fd #282a36"
  "codex_quota #bd93f9 #282a36"
  "battery #ff79c6 #282a36"
  "weather #ffb86c #282a36"
  "datetime #6272a4 #f8f8f2"
)
