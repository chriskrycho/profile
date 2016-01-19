# ZSH Theme - Preview: http://gyazo.com/8becc8a7ed5ab54a0262a470555c3eed.png
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

local current_dir='%{$terminfo[bold]$fg[blue]%} %~%{$reset_color%}'

local pyver=''
if which pyenv &> /dev/null; then
  pyver='%{$fg[red]%}‹py-$(pyenv version | sed -e "s/ (set.*$//")›%{$reset_color%}'
fi

local rubyver=''
if which rbenv &> /dev/null; then
  rubyver='%{$fg[red]%}‹rb-$(rbenv version | sed -e "s/ (set.*$//")›%{$reset_color%}'
fi

local nodever=''
if which nodenv &> /dev/null; then
  nodever='%{$fg[red]%}‹js-$(nodenv version | sed -e "s/ (set.*$//")›%{$reset_color%}'
fi

local rustver=''
if which multirust &> /dev/null; then
  rustver='%{$fg[red]%}‹rs-$(multirust which rustc | sed -E "s:.*toolchains/([^/]*)/.*:\1:")›%{$reset_color%}'
fi

# Display version control info
local git_info='$(git_prompt_info)%{$reset_color%}'
local hg_info='$(hg_prompt_info)%{$reset_color%}'

RPROMPT="${pyver}${nodever}${rustver}${rubyver}"

PROMPT="
╭─${current_dir} ${git_info}${hg_info}
╰─%B$%b "

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$reset_color%}"
ZSH_THEME_HG_PROMPT_PREFIX="%{$fg[yellow]%}‹"
ZSH_THEME_HG_PROMPT_SUFFIX="› %{$reset_color%}"
ZSH_THEME_HG_PROMPT_DIRTY="*"
