#!/bin/bash
git remote set-url origin git@github.com:triwats/dotfiles.git

# Wire the Claude Code status line without symlinking a file Claude mutates.
CS=~/.claude/settings.json
[ -f "$CS" ] || { mkdir -p ~/.claude; echo '{}' > "$CS"; }
jq '. + {statusLine:{type:"command",command:"~/.claude/statusline.sh",padding:0}}' \
  "$CS" > "$CS.tmp" && mv "$CS.tmp" "$CS"
