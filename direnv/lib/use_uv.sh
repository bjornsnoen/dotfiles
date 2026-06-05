layout_uv() {
  # If a .venv directory already exists, reuse it, else create a new one
  if [ ! -d ".venv" ]; then
    uv venv -q
  fi
  source ".venv/bin/activate"
}
