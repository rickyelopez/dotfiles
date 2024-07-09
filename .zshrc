#!/usr/bin/zsh

# uncomment to profile startup
# also uncomment the `zprof` call at the end of this file
# zmodload zsh/zprof

# source additional files if they exist
[[ -f $HOME/dotfiles_priv/.privrc ]] && source $HOME/dotfiles_priv/.privrc ]]
[[ -f $HOME/dotfiles/.vars ]] && source $HOME/dotfiles/.vars
[[ -f $HOME/dotfiles/.aliases ]] && source $HOME/dotfiles/.aliases

# load antidote/plugins
zsh_plugins=${ZDOTDIR:-$HOME}/.zsh_plugins
if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
    (
    source ~/.antidote/antidote.zsh
    antidote bundle <${zsh_plugins}.txt >${zsh_plugins}.zsh
    )
fi

source ${zsh_plugins}.zsh

[[ -x pokemon-colorscripts ]] && pokemon-colorscripts --no-title -s -r

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH="$HOME/bin:/usr/local/bin:$PATH"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# export ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
plugins=(
  git
  dnf
)

# Don't define aliaes from the git plugin
zstyle ':omz:plugins:git' aliases no

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh


# Tell Maven to use brew java instead of mac one
if [ -f /usr/libexec/java_home ]; then
    export JAVA_HOME=$(/usr/libexec/java_home -v 1.8 2>/dev/null)
fi

PYENV_ROOT="$HOME/.pyenv"
if [[ -x $PYENV_ROOT/bin/pyenv ]]; then
    export PYENV_ROOT
    export PATH="$PYENV_ROOT/bin:$PATH"

    eval "$(pyenv init --path)"
    # eval "$(pyenv init -)"
fi

if [[ -s "$HOME/.autojump/etc/profile.d/autojump.sh" ]]; then
    source "$HOME/.autojump/etc/profile.d/autojump.sh" 
elif [[ -s "/etc/profile.d/autojump.sh" ]]; then
    source "/etc/profile.d/autojump.sh" 
elif [[ -s "/usr/share/autojump/autojump.sh" ]]; then
    source "/usr/share/autojump/autojump.sh"
elif [[ -s "/opt/homebrew/etc/profile.d/autojump.sh" ]]; then
    source "/opt/homebrew/etc/profile.d/autojump.sh"
fi


# disabling this for now because I have no idea what it does
# [[ "$(uname 2> /dev/null)" != "Linux" ]] && autoload -U compinit && compinit -u

# set up fzf zsh integration
if hash fzf 2>/dev/null; then
    # note: this requires a relatively new version of fzf to work
    source <(fzf --zsh)
fi

export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# uncomment to profile startup
# zprof
