# Path to Oh My Fish install.

# Unbindall
bind --erase --all

set -q XDG_DATA_HOME
  and set -gx OMF_PATH "$XDG_DATA_HOME/omf"
  or set -gx OMF_PATH "$HOME/.local/share/omf"

# Customize Oh My Fish configuration path.
#set -gx OMF_CONFIG "/Users/tristan/.config/omf"

# Add break on command to ensure new line
function fish_user_key_bindings
  bind \cc 'echo; commandline | cat; commandline ""; commandline -f repaint'
end

# Git Information
# Fish git prompt
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showupstream 'yes'
set __fish_git_prompt_color_branch yellow
set __fish_git_prompt_color_upstream_ahead green
set __fish_git_prompt_color_upstream_behind red
# Status Chars
set __fish_git_prompt_char_dirtystate '⚡'
set __fish_git_prompt_char_stagedstate '→'
set __fish_git_prompt_char_untrackedfiles '☡'
set __fish_git_prompt_char_stashstate '↩'
set __fish_git_prompt_char_upstream_ahead '+'
set __fish_git_prompt_char_upstream_behind '-'

set -q FZF_LEGACY_KEYBINDINGS
or set -l FZF_LEGACY_KEYBINDINGS 1

if test "$FZF_LEGACY_KEYBINDINGS" -eq 1
    bind \ct '__fzf_find_file'
    bind \cr '__fzf_reverse_isearch'
    bind \cx '__fzf_find_and_execute'
    bind \ec '__fzf_cd'
    bind \eC '__fzf_cd_with_hidden'

    if bind -M insert >/dev/null ^/dev/null
        bind -M insert \ct '__fzf_find_file'
        bind -M insert \cr '__fzf_reverse_isearch'
        bind -M insert \cx '__fzf_find_and_execute'
        bind -M insert \ec '__fzf_cd'
        bind -M insert \eC '__fzf_cd_with_hidden'
    end
else
    bind \cf '__fzf_find_file'
    bind \cr '__fzf_reverse_isearch'
    bind \ex '__fzf_find_and_execute'
    bind \ed '__fzf_cd'
    bind \eD '__fzf_cd_with_hidden'

    if bind -M insert >/dev/null ^/dev/null
        bind -M insert \cf '__fzf_find_file'
        bind -M insert \cr '__fzf_reverse_isearch'
        bind -M insert \ex '__fzf_find_and_execute'
        bind -M insert \ed '__fzf_cd'
        bind -M insert \eD '__fzf_cd_with_hidden'
    end
end

source $OMF_PATH/init.fish
