# Path to your oh-my-zsh installation.
export ZSH=/Users/chris/.oh-my-zsh

# --- zsh-proper configuration. --- #
autoload -U zmv
autoload -U zargs

alias mmv="noglob zmv -W"

setopt PROMPT_SUBST

# --- oh-my-zsh configuration --- #
# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="krycho"

# Uncomment following line if you want to disable autosetting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy-mm-dd"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(brew ember-cli git tmux zsh-syntax-highlighting gulp)

source $ZSH/oh-my-zsh.sh

# Finish by loading non-zsh specific configuration.
source $HOME/.osrc
source $HOME/.profile
