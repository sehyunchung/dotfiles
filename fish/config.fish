# setup
export TERM="xterm-256color"

# my defaults
alias v="nvim"
alias config="nvim ~/.config/fish/config.fish"
alias ss="source ~/.config/fish/config.fish"
alias aa="nvim ~/.config/alacritty/alacritty.yml"
alias tt="nvim ~/.tmux.conf"
alias vv="nvim ~/.config/nvim/init.vim"

# git aliases
alias g="git"
alias ga="git add"
alias gb="git branch"
alias gst="git status"
alias gc="git commit"
alias gco="git checkout"
alias gp="git push"
alias gpu="git pull upstream"
alias gpud="git pull upstream develop"
alias gf="git diff"
alias gl="git log"

# fzf
set fzf_preview_window = ['right:50%', 'ctrl-/']
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# brew
set -g fish_user_paths "/opt/homebrew/sbin" $fish_user_paths

# list localhosts
alias listhost="lsof -iTCP:8000 -sTCP:LISTEN"

# work repos
alias ww="cd ~/Work/monolabs"
alias wfe="cd ~/Work/monolabs/fe-world"

# personal repos
alias pp="cd ~/Personal/"
alias ppb="cd ~/Personal/sehyunchung.dev"
alias pps="cd ~/Personal/sm-next"

