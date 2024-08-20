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

# update without prompting
DISABLE_UPDATE_PROMPT="true"

# display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# don't mark untracked files in vcs dirs
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load?
plugins=(
  git
  dnf
)

# Don't define aliaes from the git plugin
zstyle ':omz:plugins:git' aliases no

source $ZSH/oh-my-zsh.sh

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


[[ "$(uname 2> /dev/null)" != "Linux" ]] && autoload -U compinit && compinit -u

# set up fzf zsh integration
if hash fzf 2>/dev/null; then
    # note: this requires a relatively new version of fzf to work
    source <(fzf --zsh)
fi

# set up autocomplete for fx
if hash fx 2>/dev/null; then
    source <(fx --comp zsh)
fi

export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# uncomment to profile startup
# zprof
