# Created by Zap installer
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "zap-zsh/zap-prompt"
plug "zsh-users/zsh-syntax-highlighting"

export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

alias v="nvim"
alias c="cursor"
alias cc="claude"
alias cl="clear"
alias ss="source ~/.zshrc"
alias bb="blackbox"
alias ww="~/Work"

alias pn="pnpm"
alias o="open"

# ls
alias ll="ls -la"
alias la="ls -a"
alias lt="ls -lt"

# git
alias gs="git status"
alias gd="git diff"
alias gds="git diff --staged"
alias gl="git log --oneline -20"
alias gp="git push"
alias gpf="git push --force-with-lease"
alias gpu="git pull"
alias ga="git add"
alias gaa="git add -a"
alias gcm="git commit -m"
alias gca="git commit --amend --no-edit"
alias gco="git checkout"
alias gsw="git switch"
alias gb="git branch"
alias gst="git status"
alias gstp="git stash pop"
alias gwt="git worktree"
alias gg="gitu"
alias crp:s="crepe-start"
alias crp:d="crepe-done"
alias crp:l="crepe-list"
alias crp:p="crepe-prune"

# navigation
alias ..="cd .."
alias ...="cd ../.."
alias md="mkdir -p"

alias gemini="npx https://github.com/google-gemini/gemini-cli"

alias pp="cd ~/personal/"
alias rr="cd ~/Library/Mobile\ Documents/com~apple~CloudDocs/Personal/research/"

alias crp="cd ~/Work/crepe"

# crepe config
CREPE_ROOT=~/Work/crepe
CREPE_BASE=develop

# crepe workspace launcher
crepe-start() {
  local issue="$1"
  [[ -z "$issue" ]] && { echo "Usage: crepe-start <branch>"; return 1; }

  local wt="$HOME/Work/$issue"

  echo ":: Updating $CREPE_BASE..."
  git -C "$CREPE_ROOT" fetch origin || { echo "x fetch failed"; return 1; }
  git -C "$CREPE_ROOT" checkout "$CREPE_BASE" 2>/dev/null || { echo "x checkout failed (dirty tree?)"; return 1; }
  git -C "$CREPE_ROOT" pull origin "$CREPE_BASE" || { echo "x pull failed"; return 1; }

  if [[ ! -d "$wt" ]]; then
    echo ":: Creating worktree: $issue"
    git -C "$CREPE_ROOT" worktree add "$wt" -b "$issue" "$CREPE_BASE" \
      || { echo "x worktree creation failed"; return 1; }
  else
    echo "-> Worktree $issue already exists, reusing"
  fi

  if [[ ! -f "$wt/frontend/.env" ]]; then
    if [[ -f "$wt/frontend/.env.dev.sample" ]]; then
      cp "$wt/frontend/.env.dev.sample" "$wt/frontend/.env"
      echo "-> Copied .env from sample"
    else
      echo "!! .env.dev.sample not found, skipping"
    fi
  fi

  echo ":: Installing dependencies..."
  (cd "$wt" && pn i) || { echo "x pnpm install failed"; return 1; }

  # cmux: claude (left) + relay (right)
  cmux new-workspace --cwd "$wt" --command "claude -n '$issue'"
  cmux rename-workspace "$issue"
  sleep 0.5  # wait for terminal init before splitting
  cmux new-split right
  sleep 0.3  # wait for split surface
  cmux send "pn --dir frontend relay"
  cmux send-key Enter

  echo "ok $issue ready"
}

# crepe workspace cleanup
crepe-done() {
  local issue="$1"
  [[ -z "$issue" ]] && { echo "Usage: crepe-done <branch>"; return 1; }

  local wt="$HOME/Work/$issue"

  # guard: uncommitted work
  if [[ -d "$wt" ]] && [[ -n $(git -C "$wt" status --porcelain 2>/dev/null) ]]; then
    echo "!! Uncommitted changes in $issue:"
    git -C "$wt" status --short
    read -q "reply?Force remove? [y/N] " || { echo "\nAborted."; return 1; }
    echo ""
  fi

  # close cmux workspace
  local ws_id
  ws_id=$(cmux list-workspaces 2>/dev/null | grep "$issue" | grep -o 'workspace:[0-9]*' | head -1)
  if [[ -n "$ws_id" ]]; then
    cmux close-workspace --workspace "$ws_id"
    echo "-> Closed workspace"
  fi

  # remove worktree
  if [[ -d "$wt" ]]; then
    git -C "$CREPE_ROOT" worktree remove --force "$wt"
    echo "-> Removed worktree"
  fi

  # delete local branch
  git -C "$CREPE_ROOT" branch -d "$issue" 2>/dev/null && echo "-> Deleted branch"

  echo "ok $issue cleaned up"
}

# list active crepe worktrees
crepe-list() {
  local ws_list
  ws_list=$(cmux list-workspaces 2>/dev/null)
  local wt_lines=("${(@f)$(git -C "$CREPE_ROOT" worktree list 2>/dev/null | tail -n +2)}")

  local line
  for line in "${wt_lines[@]}"; do
    local wt_path=${line%% *}
    local name=${wt_path:t}
    local branch=${line##*\[}
    branch=${branch%%\]*}
    local flags=""
    [[ -n $(git -C "$wt_path" status --porcelain 2>/dev/null) ]] && flags+=" dirty"
    [[ "$ws_list" == *"$name"* ]] && flags+=" cmux"
    printf "  %-28s %-28s%s\n" "$name" "[$branch]" "$flags"
  done
}

# prune worktrees whose branches are merged into base
crepe-prune() {
  echo ":: Fetching latest..."
  git -C "$CREPE_ROOT" fetch origin --prune || { echo "x fetch failed"; return 1; }

  local merged_arr=("${(@f)$(git -C "$CREPE_ROOT" branch --merged "origin/$CREPE_BASE" --format='%(refname:short)' 2>/dev/null)}")
  local wt_lines=("${(@f)$(git -C "$CREPE_ROOT" worktree list 2>/dev/null | tail -n +2)}")

  local -a prune_names prune_branches
  local skip_count=0

  local line
  for line in "${wt_lines[@]}"; do
    local wt_path=${line%% *}
    local name=${wt_path:t}
    local branch=${line##*\[}
    branch=${branch%%\]*}

    [[ "$branch" == "$CREPE_BASE" ]] && continue
    (( ${merged_arr[(Ie)$branch]} )) || continue

    if [[ -n $(git -C "$wt_path" status --porcelain 2>/dev/null) ]]; then
      printf "  %-28s [%s]  skip (dirty)\n" "$name" "$branch"
      ((skip_count++))
    else
      printf "  %-28s [%s]\n" "$name" "$branch"
      prune_names+=("$name")
      prune_branches+=("$branch")
    fi
  done

  [[ $skip_count -gt 0 ]] && echo "\n!! $skip_count dirty worktree(s) skipped"

  if [[ ${#prune_names[@]} -eq 0 ]]; then
    echo "Nothing to prune."
    return 0
  fi

  echo "\n${#prune_names[@]} worktree(s) to prune."
  read -q "reply?Remove? [y/N] " || { echo "\nAborted."; return 0; }
  echo ""

  local i
  for i in {1..${#prune_names[@]}}; do
    local name=${prune_names[$i]}
    local branch=${prune_branches[$i]}
    local wt="$HOME/Work/$name"

    echo ":: $name"
    local ws_id
    ws_id=$(cmux list-workspaces 2>/dev/null | grep "$name" | grep -o 'workspace:[0-9]*' | head -1)
    [[ -n "$ws_id" ]] && cmux close-workspace --workspace "$ws_id" && echo "   -> Closed workspace"
    [[ -d "$wt" ]] && git -C "$CREPE_ROOT" worktree remove "$wt" && echo "   -> Removed worktree"
    git -C "$CREPE_ROOT" branch -d "$branch" 2>/dev/null && echo "   -> Deleted branch: $branch"
  done

  echo "ok Pruned ${#prune_names[@]} worktree(s)"
}

# Added by Antigravity
export PATH="/Users/ren/.antigravity/antigravity/bin:$PATH"

# ghostty default editor config
export EDITOR="nvim"
export VISUAL="nvim"

source <(fzf --zsh)
eval "$(zoxide init zsh)"


# bun completions
[ -s "/Users/ren/.bun/_bun" ] && source "/Users/ren/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/ren/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

alias claude-mem='bun "/Users/ren/.claude/plugins/marketplaces/thedotmack/plugin/scripts/worker-service.cjs"'

# Load and initialise completion system
autoload -Uz compinit && compinit

# Entire CLI shell completion
source <(entire completion zsh)
