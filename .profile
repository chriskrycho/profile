#!/usr/local/bin/bash
# Common functionality for any OS, with any bash-like shell.
# 

# This configures the path... so we need to do it first!
source $HOME/.osrc

# Set global editor
export EDITOR=subl

# Aliases and functions used frequently
alias la='ls -A'
alias lall='ls -al'

# Software development aliases
function cfind() { find $1 \( -name "*.[ch]" -or -name "*.cpp" \); }
function cgrep() { cfind $1 | xargs egrep $2; }
function cgrepl() { cfind $1 | xargs egrep -l $2; }

# Format C-family code to match Quest coding guidelines
alias qstyle="astyle --style=google --indent=spaces=4 --break-closing-brackets --add-brackets --pad-oper --unpad-paren --pad-header --convert-tabs"

# Pandoc generate Markdown to HTML with custom CSS
function md2html() { pandoc -t html5 -f markdown_mmd+line_blocks+startnum -S -s $*; }
function md2docx() { pandoc -t docx -f markdown_mmd+mmd_title_block -S -s $*; }
function md2pdf() { pandoc -S -s -f markdown_mmd+line_blocks+startnum --latex-engine=/usr/texbin/xelatex $*; }

# Check for updates on pip installed software
alias pip_v="pip freeze --local | sed 's/==.*//' | xargs pip install -U"

# Logins
alias ckwf="ssh chriskrycho@web443.webfaction.com"

# Set up pyenv
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

# Setting paths for virtualenvwrapper
export VIRTUAL_ENV_DISABLE_PROMPT=true
