###########
#   ZSH   #
###########

# go fast
setopt NO_cdable_vars

# Initialize colors.
autoload -U colors
colors

setopt PROMPT_SUBST

# Zsh's globbing...
setopt no_nomatch
setopt no_correctall

# Load and run compinit
autoload -U compinit
compinit -i

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# use emacsish keybindings at prompt
bindkey -e

# make search up and down work, so partially type and cycle up/down to find relevant stuff
bindkey '^P' up-line-or-search
bindkey '^N' down-line-or-search

# Command history configuration
HISTFILE=$HOME/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups # ignore duplication command history list
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history # share command history data

# Allow for functions in the prompt.
setopt PROMPT_SUBST

# Autoload zsh functions.
fpath=(~/.zsh/functions $fpath)
autoload -U ~/.zsh/functions/*(:t)

# Enable auto-execution of functions.
typeset -ga preexec_functions
typeset -ga precmd_functions
typeset -ga chpwd_functions

# Append git functions needed for prompt.
preexec_functions+='preexec_update_git_vars'
precmd_functions+='precmd_update_git_vars'
chpwd_functions+='chpwd_update_git_vars'

PROMPT=$'%D{%T} %{${fg[yellow]}%}%~/$(prompt_git_info)%{${fg[default]}%} %# '

eval "$(direnv hook zsh)"

export EDITOR="vim"
alias vimz="vim \$(fzf)"

if [ -f "${HOME}/.gemrc.local" ]; then
  export GEMRC="${HOME}/.gemrc.local"
fi

export PAGER="less"
export LESS="-R"

alias l='ls -1AopG'
alias t='tree -L 1'
alias tt='tree -L 2'
alias ttt='tree -L 3'

export HOMEBREW_NO_ANALYTICS=1
export NVIM_TUI_ENABLE_TRUE_COLOR=1

export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/share/npm/bin:$PATH"
export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"
export PATH="./bin:$PATH"
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="/usr/local/opt/qt@5.5/bin:$PATH"
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="$HOME/.emacs.d/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
export NODE_VERSIONS=$NVM_DIR/versions/node
export NODE_VERSION_PREFIX=v
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

export FZF_DEFAULT_COMMAND="rg --files --hidden -g '!.git' "

source /usr/local/opt/chruby/share/chruby/chruby.sh
source /usr/local/opt/chruby/share/chruby/auto.sh

chruby 3.1.0

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
