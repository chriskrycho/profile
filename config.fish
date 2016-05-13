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
set __fish_git_prompt_char_upstream_ahead '<'
set __fish_git_prompt_char_upstream_behind '>'


function fish_prompt
  set last_status $status

  printf '
╭─'
  set_color blue
  printf '%s' (whoami)
  set_color normal
  printf '@'
  set_color blue
  printf '%s' (hostname)
  set_color normal
  printf ':'

  set_color $fish_color_cwd
  printf '%s' (prompt_pwd)
  set_color normal

  printf '%s ' (__fish_git_prompt)

  set_color normal

  printf '
╰$ '
end

function fish_right_prompt
  printf (date "+$c2%H$c0:$c2%M$c0:$c2%S")
end

# Tool setup, completion, etc.
status --is-interactive; and source (pyenv init -|psub)
status --is-interactive; and source (nodenv init -|psub)
status --is-interactive; and source (rbenv init -|psub)
gulp --completion=fish | source
