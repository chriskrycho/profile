# ZSH Theme - Preview: http://gyazo.com/8becc8a7ed5ab54a0262a470555c3eed.png
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

local current_dir='%{$terminfo[bold]$fg[blue]%} %~%{$reset_color%}'

# Display version control info
local git_info='$(git_prompt_info)%{$reset_color%}'

RPROMPT="%*"

PROMPT="
╭─${current_dir} ${git_info}
╰─%B$%b "

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$reset_color%}"
