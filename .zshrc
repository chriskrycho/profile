# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Add zpython to module path
module_path=($module_path /usr/local/lib/zpython)

autoload -U zmv
autoload -U zargs
setopt PROMPT_SUBST

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="krycho"

# Aliases 
alias zshconfig="$EDITOR ~/.zshrc"
alias ohmyzsh="$EDITOR ~/.oh-my-zsh"
alias krychotheme="$EDITOR ~/.oh-my-zsh/themes/krycho.zsh-theme"
alias mmv="noglob zmv -W"

# Set to this to use case-sensitive completion
CASE_SENSITIVE="true"

# Uncomment following line if you want to disable autosetting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(bower brew ember-cli git gulp karma mercurial node npm nvm osx pip python themes tmux zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# Finish by loading non-zsh specific configuration.
source $HOME/.profile
