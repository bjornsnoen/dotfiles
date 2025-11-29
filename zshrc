export ZSH="$HOME/.oh-my-zsh"
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/.npm-global/bin:$PATH
export PATH=$HOME/bin:$HOME/.local/bin:$PATH
export PATH="./vendor/bin:$PATH"
export PATH="node_modules/.bin:$PATH"
export PATH=$HOME/go/bin:$PATH
export PATH=/usr/bin/vendor_perl:$PATH
export PATH=$HOME/.local/share/gem/ruby/3.0.0/bin:$PATH
export EDITOR="nvim"
export XMLLINT_INDENT="    "
export PIPENV_VERBOSITY=-1
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
export RIPGREP_CONFIG_PATH=$HOME/.config/ripgreprc

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="avit"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
zstyle :omz:plugins:ssh-agent lazy yes
zstyle :omz:plugins:ssh-agent quiet yes
plugins=(tmux docker docker-compose fzf thefuck composer zsh-autosuggestions ssh-agent gpg-agent)

source $HOME/.aliases
export ASDF_NODEJS_AUTO_ENABLE_COREPACK=1
[[ -f ~/.asdf/asdf.sh ]] && source ~/.asdf/asdf.sh
fpath+=~/.zfunc

source $ZSH/oh-my-zsh.sh

# heroku autocomplete setup
HEROKU_AC_ZSH_SETUP_PATH=$HOME/.cache/heroku/autocomplete/zsh_setup && test -f $HEROKU_AC_ZSH_SETUP_PATH && source $HEROKU_AC_ZSH_SETUP_PATH;

#unsetopt BEEP
#unsetopt LIST_BEEP
#unsetopt HIST_BEEP
export COMPOSE_DOCKER_CLI_BUILD=1
export DOCKER_BUILDKIT=1
#export DOCKER_HOST=unix:///run/user/1000/docker.sock

setopt PROMPT_SUBST

show_virtual_env() {
  if [[ -n "$VIRTUAL_ENV" && -n "$DIRENV_DIR" ]]; then
      echo "($(basename $(dirname $VIRTUAL_ENV)))"
  fi
}
PS1='$(show_virtual_env)'$PS1

[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

eval "$(direnv hook zsh)"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
