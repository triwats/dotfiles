HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=$HISTSIZE

setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY

# export mac os paths
export PATH="$PATH:/usr/bin:/bin:/usr/local/games:/usr/games:/sbin:/usr/sbin:/usr/local/bin/"

# preferred editor for local and remote sessions
export EDITOR='vim'

# aliases
alias grep="grep"
alias vi="vim"
alias vim="vim"
alias ls='ls -FG'
alias ll='ls -lartFGh'
alias view='vim -R'
alias publicip='curl http://ifconfig.me'
alias diff='diff --side-by-side -W $(( $(tput cols) - 2 ))'
alias h='helm'
alias tf='terraform'
alias k='kubectl'
alias kx='kubectx'
alias kc='kubectl config current-context'

# Set emacs keybinding (ctrl+a usage etc)
bindkey -e

# load zgen
source "${HOME}/.zgen/zgen.zsh"

if ! zgen saved; then
  echo "Creating a zgen save"
  zgen load mafredri/zsh-async
  zgen load junegunn/fzf
  zgen load junegunn/fzf shell/completion.zsh
  zgen load junegunn/fzf shell/key-bindings.zsh
  zgen load felixr/docker-zsh-completion
  zgen load lukechilds/zsh-nvm
  zgen load superbrothers/zsh-kubectl-prompt
  zgen save
fi

# use FZF for history
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

precmd() { print "" }
parse_git_branch() {
    git symbolic-ref --short HEAD 2> /dev/null
}

setopt prompt_subst
PROMPT='%B[%b%T%B]%b %B%n%b@%m %9c %{%F{red}%}$(parse_git_branch)%{%F{none}%}$ '

export PATH="/opt/homebrew/opt/node@18/bin:$PATH"

export USE_GKE_GCLOUD_AUTH_PLUGIN=True

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # this loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # this loads nvm bash_completion

# pnpm
export PNPM_HOME="/Users/tristan.watson/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
