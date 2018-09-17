# Append to history on execution
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=$HISTSIZE

setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY

# export mac os paths
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/sbin:/usr/sbin:/Library/Frameworks/Python.framework/Versions/2.7/bin/:/usr/local/lib/python2.7/site-packages:/usr/local/bin/python:/Library/Frameworks/Python.framework/Versions/2.7/bin"

# preferred editor for local and remote sessions
# set vim for SSH sessions, but MacVim for Local
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='mvim'
fi

# aliases
alias mvim="/Applications/MacVim.app/contents/MacOS/MacVim"
alias vim="nvim"
alias showjava "/usr/libexec/java_home -V" # Show java versions MacOS
alias ls='ls -FG'
alias ll='ls -lartFG'
alias view='vim -R'
alias publicip='curl http://ifconfig.me'
alias nsupdate='rlwrap nsupdate'
alias k='kubectl'

# call z.sh
. /Users/$USER/Work/z/z.sh

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

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
  zgen save
fi

# Source other scripts
source ~/digsearch

# Use FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# This has to be at the end to function
zgen load zsh-users/zsh-syntax-highlighting

# python virtualenvwrapper 
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Devel
source /usr/local/bin/virtualenvwrapper.sh

# Inclusion of GOPATH
export GOPATH="$HOME/Work/go"
export PATH=$PATH:$GOPATH/bin

# Enable completion for gcloud
if [ -f '/Users/watsont/gcp/google-cloud-sdk/completion.zsh.inc' ]; then source '/Users/watsont/gcp/google-cloud-sdk/completion.zsh.inc'; fi
