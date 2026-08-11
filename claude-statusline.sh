#!/usr/bin/env bash
# ~/.claude/statusline.sh — powerline status line for Claude Code.
#
# Reads the session JSON on stdin — see https://code.claude.com/docs/en/statusline
# Requires: jq, and a Nerd Font (Ghostty bundles JetBrains Mono NF).
#
# Test:
#   echo '{"workspace":{"current_dir":"'"$PWD"'"},"context_window":{"used_percentage":42}}' | ~/.claude/statusline.sh

input=$(cat)

# ----------------------------------------------------------------- glyphs ----
# Private-use-area codepoints. Some editors silently strip these — if the bar
# renders without icons, that's what happened. Blank a value to fall back to
# bare text; only SEP/SUB are structural.
SEP=''        # solid right chevron — segment boundary
SUB=''        # thin right chevron — divider within a segment
ICON_DIR=''
ICON_GIT=''
ICON_MIC=''

# ------------------------------------------------------------------ parse ----
# One jq pass. The delimiter must NOT be whitespace: bash collapses runs of
# IFS-whitespace, which silently drops empty fields and shifts everything after.
US=$'\x1f'
IFS="$US" read -r sid pid cur_dir proj_dir wt_name ctx_pct cost_usd cost_cents \
    api_ms lines_add lines_del fast effort vim_mode agent_name rl5 pr_num pr_state <<<"$(
  jq -r '
    [ (.session_id                      // "")
    , (.prompt_id                       // "")
    , (.workspace.current_dir           // "")
    , (.workspace.project_dir           // "")
    , (.worktree.name // .workspace.git_worktree // "")
    , (.context_window.used_percentage  // -1 | floor)
    , (.cost.total_cost_usd             // 0)
    , ((.cost.total_cost_usd            // 0) * 100 | floor)
    , (.cost.total_api_duration_ms      // 0 | floor)
    , (.cost.total_lines_added          // 0)
    , (.cost.total_lines_removed        // 0)
    , (.fast_mode                       // false)
    , (.effort.level                    // "")
    , (.vim.mode                        // "")
    , (.agent.name                      // "")
    , (.rate_limits.five_hour.used_percentage // -1 | floor)
    , (.pr.number                       // "")
    , (.pr.review_state                 // "")
    ] | map(tostring) | join("\u001f")' <<<"$input" 2>/dev/null
)"
[ -n "$cur_dir" ] || cur_dir="$PWD"

# ----------------------------------------------------------------- render ----
prev_bg=""
out=""

# seg <bg> <fg> <text> — emits the transition chevron, then the segment body.
seg() {
  local bg=$1 fg=$2 text=$3
  if [ "$bg" = "$prev_bg" ]; then
    # Same background as the neighbour: a solid chevron would be invisible
    # (fg == bg), so fall back to the thin divider in the segment's own fg.
    out+=$'\033[48;5;'"$bg"'m'$'\033[38;5;'"$fg"'m'"$SUB"
  elif [ -n "$prev_bg" ]; then
    out+=$'\033[38;5;'"$prev_bg"'m'$'\033[48;5;'"$bg"'m'"$SEP"
  fi
  out+=$'\033[48;5;'"$bg"'m'$'\033[38;5;'"$fg"'m'" $text "
  prev_bg=$bg
}

# ---- vim mode (only when vim bindings are on) ----
case "$vim_mode" in
  NORMAL) seg 202 232 "N" ;;
  INSERT) seg  35 232 "I" ;;
  VISUAL) seg  99 232 "V" ;;
esac

# ---- driving subagent ----
[ -n "$agent_name" ] && seg 54 189 "$agent_name"

# ---- path: project-relative when inside the project, else ~-shortened ----
if [ -n "$proj_dir" ] && [ "${cur_dir#"$proj_dir"}" != "$cur_dir" ]; then
  path="${proj_dir##*/}${cur_dir#"$proj_dir"}"
else
  path="${cur_dir/#$HOME/~}"
fi
if [ "$(tr -cd '/' <<<"$path" | wc -c)" -gt 3 ]; then
  path="…/$(rev <<<"$path" | cut -d/ -f1-3 | rev)"
fi
seg 31 231 "${ICON_DIR:+$ICON_DIR }$path"

# ---- git (cached: this re-runs every render, and git status is the slow bit) ----
cache="${TMPDIR:-/tmp}/claude-sl-git-${cur_dir//\//_}"
if [ -f "$cache" ] && [ $(( $(date +%s) - $(stat -f %m "$cache" 2>/dev/null || echo 0) )) -lt 3 ]; then
  git_info=$(<"$cache")
else
  git_info=""
  if branch=$(git -C "$cur_dir" symbolic-ref --quiet --short HEAD 2>/dev/null) \
     || branch=$(git -C "$cur_dir" rev-parse --short HEAD 2>/dev/null); then
    dirty=$(git -C "$cur_dir" status --porcelain --untracked-files=no 2>/dev/null | wc -l | tr -d ' ')
    ab=$(git -C "$cur_dir" rev-list --left-right --count HEAD...@{u} 2>/dev/null)
    git_info="${branch}${US}${dirty}${US}${ab}"
  fi
  printf '%s' "$git_info" >"$cache" 2>/dev/null
fi

if [ -n "$git_info" ]; then
  IFS="$US" read -r branch dirty ab <<<"$git_info"
  g="${ICON_GIT:+$ICON_GIT }$branch"
  [ -n "$wt_name" ] && g+=" $SUB $wt_name"
  [ "${dirty:-0}" -gt 0 ] 2>/dev/null && g+="*"
  read -r ahead behind <<<"$ab"
  [ "${ahead:-0}" -gt 0 ]  2>/dev/null && g+=" ⇡$ahead"
  [ "${behind:-0}" -gt 0 ] 2>/dev/null && g+=" ⇣$behind"
  if [ "${dirty:-0}" -gt 0 ] 2>/dev/null; then seg 130 231 "$g"; else seg 28 231 "$g"; fi
fi

# ---- eval time ----
# Per-turn model time: the delta in total_api_duration_ms since this prompt_id
# first appeared. API duration rather than wall clock means it freezes the
# moment the turn ends, instead of counting your idle time.
if [ -n "$pid" ]; then
  tcache="${TMPDIR:-/tmp}/claude-sl-turn-${sid:-none}"
  base=""
  if [ -f "$tcache" ]; then
    IFS="$US" read -r cached_pid cached_base <<<"$(<"$tcache")"
    [ "$cached_pid" = "$pid" ] && base="$cached_base"
  fi
  if [ -z "$base" ]; then
    base="$api_ms"
    printf '%s%s%s' "$pid" "$US" "$base" >"$tcache" 2>/dev/null
  fi
  eval_ms=$(( api_ms - base ))
  [ "$eval_ms" -lt 0 ] && eval_ms=0
  if [ "$eval_ms" -ge 1000 ]; then
    s=$(( eval_ms / 1000 ))
    if   [ "$s" -ge 3600 ]; then et="$(( s / 3600 ))h $(( (s % 3600) / 60 ))m"
    elif [ "$s" -ge 60 ];   then et="$(( s / 60 ))m $(( s % 60 ))s"
    else                         et="${s}s"; fi
    seg 136 232 "$et"
  fi
fi

# ---- context window: colour ramps green → red as it fills ----
if [ "${ctx_pct:--1}" -ge 0 ] 2>/dev/null; then
  if   [ "$ctx_pct" -lt 50 ]; then cbg=22
  elif [ "$ctx_pct" -lt 75 ]; then cbg=94
  elif [ "$ctx_pct" -lt 90 ]; then cbg=130
  else                             cbg=124; fi
  seg "$cbg" 231 "${ctx_pct}%"
fi

# ---- code churn this session (no money, no tokens — just lines touched) ----
if [ "${lines_add:-0}" -gt 0 ] 2>/dev/null || [ "${lines_del:-0}" -gt 0 ] 2>/dev/null; then
  seg 238 250 "+${lines_add}/-${lines_del}"
fi

# ---- 5-hour limit, surfaced only once it starts to matter ----
if [ "${rl5:--1}" -ge 60 ] 2>/dev/null; then
  [ "$rl5" -ge 85 ] && rbg=124 || rbg=95
  seg "$rbg" 231 "5h ${rl5}%"
fi

# ---- pull request ----
if [ -n "$pr_num" ]; then
  case "$pr_state" in
    approved)          seg  22 231 "#$pr_num ✓" ;;
    changes_requested) seg 124 231 "#$pr_num ✗" ;;
    *)                 seg  54 189 "#$pr_num"   ;;
  esac
fi

# ---- voice ----
# A custom status line suppresses the footer's "hold space to speak" hint, so
# this puts it back. There is no voice field in the payload, so this reflects
# configured state from settings.json, not live mic activity. Cached 60s.
vcache="${TMPDIR:-/tmp}/claude-sl-voice"
if [ -f "$vcache" ] && [ $(( $(date +%s) - $(stat -f %m "$vcache" 2>/dev/null || echo 0) )) -lt 60 ]; then
  voice=$(<"$vcache")
else
  voice=$(jq -r 'if (.voice.enabled // .voiceEnabled // false)
                 then (.voice.mode // "on") else "" end' \
            "$HOME/.claude/settings.json" 2>/dev/null)
  printf '%s' "$voice" >"$vcache" 2>/dev/null
fi
[ -n "$voice" ] && seg 60 231 "${ICON_MIC:+$ICON_MIC }$voice"

# ---- flags: only the non-default states ----
flags=""
[ "$fast" = "true" ] && flags+="fast"
case "$effort" in xhigh|max) flags+="${flags:+ $SUB }$effort" ;; esac
[ -n "$flags" ] && seg 54 189 "$flags"

# ---- close the bar ----
out+=$'\033[0m'$'\033[38;5;'"$prev_bg"'m'"$SEP"$'\033[0m'
printf '%s\n' "$out"
