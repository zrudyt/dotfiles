export PATH="$XDG_BIN_HOME:$PATH"
export MANPAGER='vim +Man!'
export MANWIDTH=999

# Useful Functions
source "$ZDOTDIR/zsh-functions"

# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$XDG_CACHE_HOME/zsh/history"
setopt appendhistory

# some useful options (man zshoptions)
setopt autocd extendedglob nomatch menucomplete
setopt interactive_comments
stty stop undef		# Disable ctrl-s to freeze terminal.
zle_highlight=('paste:none')

# beeping is annoying
unsetopt BEEP

# Enable colors and change prompt:
autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

# Solarized color themes are distributed as database files for GNU dircolors,
# which is the application that sets up colors for GNU ls.  To activate the
# theme for all future shell sessions, copy or link the theme file to
# ~/.dir_colors, or include the command below in your shell startup file.
# See  https://github.com/seebi/dircolors-solarized for more information
#
#     eval `dircolors /path/to/dircolorsdb`

if [ "$(uname -s)" = "Linux" ]; then
    # eval `dircolors "$ZDOTDIR/dircolors/dircolors.ansi-dark"`
    eval `dircolors "$ZDOTDIR/dircolors/dircolors.256dark"`
fi

# Basic auto/tab complete:
autoload -Uz compinit
zstyle ':completion:*' menu select
# zstyle ':completion::complete:lsof:*' menu yes select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# Colors
autoload -Uz colors && colors

# Normal files to source
# zsh_add_file "zsh-exports"
zsh_add_file "zsh-vim-mode"
[ -f "$HOME/.aliases" ] && source "$HOME/.aliases" # zsh_add_file "zsh-aliases"
# zsh_add_file "zsh-prompt"

# Key-bindings
bindkey -s '^o' 'ranger^M'
bindkey -s '^f' 'zi^M'
bindkey -s '^s' 'ncdu^M'
# bindkey -s '^n' 'nvim $(fzf)^M'
# bindkey -s '^v' 'nvim\n'
bindkey -s '^z' 'zi^M'
bindkey '^[[P' delete-char
bindkey "^p" up-line-or-beginning-search # Up
bindkey "^n" down-line-or-beginning-search # Down
bindkey "^k" up-line-or-beginning-search # Up
bindkey "^j" down-line-or-beginning-search # Down
bindkey -r "^u"
bindkey -r "^d"

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Environment variables set everywhere
export EDITOR="vim"
export TERMINAL="st-256color"
export BROWSER="palemoon"

export NNTPSERVER="news.gmane.io"

### # Use lf to switch directories and bind it to ctrl-o
### lfcd () {
###     tmp="$(mktemp)"
###     lf -last-dir-path="$tmp" "$@"
###     if [ -f "$tmp" ]; then
###         dir="$(cat "$tmp")"
###         rm -f "$tmp"
###         [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
###     fi
### }
### bindkey -s '^o' 'lfcd\n'

# Plugins
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
# For more plugins: https://github.com/unixorn/awesome-zsh-plugins
# zsh_add_completion "esc/conda-zsh-completion" false
# More completions https://github.com/zsh-users/zsh-completions
#

# Autostart Tmux Session On Remote System When Logging In Via SSH
# https://ostechnix.com/autostart-tmux-session-on-remote-system-when-logging-in-via-ssh/
#
if [ -z "$TMUX" ] && [ "$(uname -n | cut -d'.' -f1)" = "starbase" ]; then
    tmux new -s default || tmux attach -t default
fi

