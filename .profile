#!/usr/local/bin/bash
# Common functionality for any OS, with any bash-like shell.
#

# Path to personal scripts
SCRIPTS=/Users/chris/Dropbox/dev/scripts
# Path to personally-installed tools.
HOMEBIN=$HOME/bin
export PATH=$SCRIPTS:$HOMEBIN:$PATH

# Set global editor
export EDITOR=atom

# Aliases and functions used frequently
# Use `git` as a `hub` alias (and thus superset).
eval "$(hub alias -s)"

alias takeover="tmux detach -a"

[ -s "/Users/chris/.dnx/dnvm/dnvm.sh" ] && . "/Users/chris/.dnx/dnvm/dnvm.sh" # Load dnvm
