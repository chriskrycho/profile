#!/usr/local/bin/bash
# Common functionality for my Mac setup. Works for any bash-like shell.
# 

# Set global editor
export EDITOR=subl

# Set path.
RUBY_DIR=/usr/local/opt/ruby/bin
NPM_DIR=/usr/local/share/npm/bin
SVN_DIR=/opt/subversion/bin
PSQL_DIR=/Applications/Postgres.app/Contents/Versions/9.3/bin
COMPOSER_DIR=/Users/chris/.composer/vendor/bin
PATH=/usr/local/bin:$RUBY_DIR:$NPM_DIR:$SVN_DIR:$PSQL_DIR:$COMPOSER_DIR:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/texbin:/usr/local/git/bin
export PATH=$PATH:.

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

# Quick launch apps
alias bw='open -a Byword.app'
alias word='open -a Microsoft\ Word.app'
alias marked='open -a Marked\ 2.app'

# Check for updates on pip installed software
alias pip_v="pip freeze --local | sed 's/==.*//' | xargs pip install -U"

# Various working areas
alias quest="cd /Users/chris/development/quest/workspace && source .questrc"
alias class="cd /Users/chris/Dropbox/sebts/classes"
alias personal="cd /Users/chris/development/personal_projects"
alias blog="cd /Users/chris/Dropbox/writing/nonfiction/chriskrycho.com"

# Logins
alias ckwf="ssh chriskrycho@web443.webfaction.com"

# Set paths for nvm and alias iojs to preferred behavior.
export NVM_DIR=$(brew --prefix)/var/nvm
source $(brew --prefix nvm)/nvm.sh
alias iojs="iojs --use-strict"

# Set up pyenv
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

# Setting paths for virtualenvwrapper
export VIRTUAL_ENV_DISABLE_PROMPT=true

# toggle iTerm Dock icon
function toggleiTerm() {
    pb='/usr/libexec/PlistBuddy'
    iTerm='/Applications/dev-tools/iTerm.app/Contents/Info.plist'
    
    echo "Do you wish to hide iTerm in Dock?"
    select ync in "Hide" "Show" "Cancel"; do
        case $ync in
            'Hide' )
                $pb -c "Add :LSUIElement bool true" $iTerm
                echo "relaunch iTerm to take effectives"
                break
                ;;
            'Show' )
                $pb -c "Delete :LSUIElement" $iTerm
                echo "run killall 'iTerm' to exit, and then relaunch it"
                break
                ;;
        'Cancel' )
            break
            ;;
        esac
    done
}