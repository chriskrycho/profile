set greeting_text (printf "\e[1;3m--Glorify God. Love people.--\e[0m")
set cols (tput cols)
set text_len (string length $greeting_text)

set space (printf "%.0f" (math (math $cols - $text_len) / 2))

set padding (printf "%*s" $space)
set -gx fish_greeting (printf "%s%s" $padding $greeting_text)

set normal (set_color normal)
set magenta (set_color magenta)
set yellow (set_color yellow)
set green (set_color green)
set red (set_color red)
set gray (set_color -o black)

# Fish git prompt
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showupstream 'yes'
set __fish_git_prompt_color_branch yellow
set __fish_git_prompt_color_upstream_ahead green
set __fish_git_prompt_color_upstream_behind red

# Status Chars
set __fish_git_prompt_char_dirtystate '!'
set __fish_git_prompt_char_stagedstate '+'
set __fish_git_prompt_char_untrackedfiles '?'
set __fish_git_prompt_char_stashstate '%'
set __fish_git_prompt_char_upstream_ahead '↑'
set __fish_git_prompt_char_upstream_behind '↓'

function fish_prompt
  set last_status $status
  printf '
╭──'
  set_color blue 
  printf '%s' (whoami)
  set_color normal
  printf '@'
  set_color blue
  printf '%s' (prompt_hostname)
  printf ' '
  set_color $fish_color_cwd
  printf '%s' (prompt_pwd)
  set_color normal

  printf '%s' (__fish_git_prompt)

  set_color normal
  printf '
╰→ '
end

function fish_right_prompt
  # printf (date "+$c2%H$c0:$c2%M$c0:$c2%S")
end

function add_to_path
  set NEW_ENTRY $argv[1]
  string match -r $NEW_ENTRY $PATH > /dev/null; or set -gx PATH $NEW_ENTRY $PATH
end

# PATH updates
add_to_path $HOME/.cargo/bin
add_to_path $HOME/bin

# -- Tool config --
set -gx RUST_SRC_PATH $HOME/.multirust/toolchains/stable-x86_64-apple-darwin/lib/rustlib/src/rust/src

# GPG config
set -gx GPG_TTY (tty)

# Aliases
alias git "hub"
alias vless "vim -u /usr/share/vim/vim80/macros/less.vim"
alias caret "open -a 'Caret Beta.app'"

# env/shims/etc.
status --is-interactive; and source (pyenv init -|psub)

set -gx ATOM_PATH /Applications/dev

set -gx EDITOR "code"

set -gx VOLTA_HOME "$HOME/.volta"
test -s "$VOLTA_HOME/load.fish"; and source "$VOLTA_HOME/load.fish"

string match -r ".volta" "$PATH" > /dev/null; or set -gx PATH "$VOLTA_HOME/bin" $PATH