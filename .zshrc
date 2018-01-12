HISTFILE=~/.zsh_history
SAVEHIST=1000

# export mac os paths
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/sbin:/usr/sbin"

# preferred editor for local and remote sessions
# set vim for SSH sessions, but MacVim for Local
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='mvim'
fi

# aliases
alias mvim="/Applications/MacVim.app/contents/MacOS/MacVim"
alias showjava "/usr/libexec/java_home -V" # Show java versions MacOS
alias ls='ls -FG'
alias ll='ls -lartFG'
alias view='vim -R'
alias publicip='curl http://ifconfig.me'
alias nsupdate='rlwrap nsupdate'

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
  zgen load sindresorhus/pure
  zgen load junegunn/fzf
  zgen load junegunn/fzf shell/completion.zsh
  zgen load junegunn/fzf shell/key-bindings.zsh
  zgen load rupa/z
  zgen load felixr/docker-zsh-completion
  zgen load supercrabtree/k
  zgen save
fi

# Source other scripts
source digsearch

# Use FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# This has to be at the end to function
zgen load zsh-users/zsh-syntax-highlighting

