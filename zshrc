# Append to history on execution
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=$HISTSIZE

setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY

# export mac os paths
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/sbin:/usr/sbin:/Library/Frameworks/Python.framework/Versions/2.7/bin/:/usr/local/lib/python2.7/site-packages:/usr/local/bin/python:/Library/Frameworks/Python.framework/Versions/2.7/bin:/Users/tristan.watson/Library/Python/2.7/bin:~/bin/"

# preferred editor for local and remote sessions
# set vim for SSH sessions, but MacVim for Local
export EDITOR='vim'

# aliases
alias vi="vim"
alias vim="vim"
alias ls='ls -FG'
alias ll='ls -lartFG'
alias view='vim -R'
alias publicip='curl http://ifconfig.me'
alias diff='diff --side-by-side -W $(( $(tput cols) - 2 ))'
alias h='helm'
alias tf='terraform'
alias k='kubectl'
alias kx='kubectx'

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
  zgen load sindresorhus/pure
  zgen load superbrothers/zsh-kubectl-prompt
  zgen save
fi

# Use FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Allow searching of Hidden files
let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -l -g ""'

# Use GPG agent for ssh for use with Yubikeys
export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

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

# Ensure this is as the end as per documentation
zgen load zsh-users/zsh-syntax-highlighting

# Ensure that we're using Python 3
export PATH="/usr/local/opt/python/libexec/bin:/usr/local/sbin:$PATH"
source $HOME/Library/Python/3.7/bin/virtualenvwrapper.sh
export WORKON_HOME=$HOME/venvs
export PROJECT_HOME=$HOME/src

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/tristan.watson/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/tristan.watson/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/tristan.watson/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/tristan.watson/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
