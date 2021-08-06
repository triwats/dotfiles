# Append to history on execution
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
  zgen load superbrothers/zsh-kubectl-prompt
  zgen load miekg/lean
  zgen save
fi

# Use FZF for history
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Use GPG agent for ssh for use with U2F keys
#export GPG_TTY="$(tty)"
#export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
#gpgconf --launch gpg-agent

## Case Statement to change behaviour based on OS
#case "$OSTYPE" in
#  darwin*)
#    # ...
#  ;;
#  linux*)
#    setxkbmap -layout us -option ctrl:nocaps
#    if [ "$(tty)" = "/dev/tty1" ]; then
#	    exec sway > /var/log/sway.log 2>&1
#    fi
#  ;;
#esac

# Ensure these is as the end as per documentation
# May need to install Starship separately
zgen load zsh-users/zsh-syntax-highlighting
export PATH="/opt/homebrew/opt/python@3.8/bin:$PATH"
