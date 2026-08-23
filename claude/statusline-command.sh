#!/usr/bin/env bash
# Claude Code status line - styled to match the user's Starship prompt
# (clean dir + purple branch with  glyph + yellow [!?] status flags)

input=$(cat)

# Colors (ANSI)
BOLD_CYAN="\033[1;36m"
BOLD_PURPLE="\033[1;35m"
BOLD_YELLOW="\033[1;33m"
GREEN="\033[0;32m"
RESET="\033[0m"
DIM="\033[2m"

# Nerd Font branch glyph (literal U+E0A0 — renders with JetBrainsMono Nerd Font)
BRANCH_GLYPH=""

# Current directory (basename, like Starship's truncated dir)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
dir_name=$(basename "$cwd")

# Git branch
branch=$(git -C "$cwd" -c gc.auto=0 symbolic-ref --short HEAD 2>/dev/null)

# Git status flags, Starship-style: + staged, ! modified, ? untracked
git_info=""
if [ -n "$branch" ]; then
  porcelain=$(git -C "$cwd" -c gc.auto=0 status --porcelain 2>/dev/null)
  flags=""
  echo "$porcelain" | grep -qE '^[MADRC]'  && flags="${flags}+"   # staged
  echo "$porcelain" | grep -qE '^.[MD]'     && flags="${flags}!"   # modified (worktree)
  echo "$porcelain" | grep -q  '^??'        && flags="${flags}?"   # untracked
  git_info=$(printf "${BOLD_PURPLE}%s %s${RESET}" "$BRANCH_GLYPH" "$branch")
  if [ -n "$flags" ]; then
    git_info=$(printf "%b ${BOLD_YELLOW}[%s]${RESET}" "$git_info" "$flags")
  fi
fi

# Model display name
model=$(echo "$input" | jq -r '.model.display_name // empty')

# Context window: used percentage
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
[ -n "$used" ] && ctx_str=$(printf "ctx:%.0f%%" "$used") || ctx_str=""

# Token counts from last API call
in_tok=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
out_tok=$(echo "$input" | jq -r '.context_window.current_usage.output_tokens // empty')
tok_str=""
if [ -n "$in_tok" ] && [ -n "$out_tok" ]; then
  tok_str=$(printf "in:%s out:%s" "$in_tok" "$out_tok")
elif [ -n "$in_tok" ]; then
  tok_str=$(printf "in:%s" "$in_tok")
fi

# Session cost (approx; input $3/M, output $15/M)
cost_str=""
if [ -n "$in_tok" ] && [ -n "$out_tok" ]; then
  cost_str=$(echo "$in_tok $out_tok" | awk '{printf "$%.4f", $1/1000000*3.00 + $2/1000000*15.00}')
fi

# Build the line
line=$(printf "${BOLD_CYAN}%s${RESET}" "$dir_name")
[ -n "$git_info" ] && line="$line $git_info"
[ -n "$model" ]    && line="$line ${DIM}[$model]${RESET}"
[ -n "$ctx_str" ]  && line="$line ${DIM}$ctx_str${RESET}"
[ -n "$cost_str" ] && line="$line ${GREEN}${DIM}$cost_str${RESET}"
[ -n "$tok_str" ]  && line="$line ${DIM}$tok_str${RESET}"

printf "%b\n" "$line"
