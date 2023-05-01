if not status --is-interactive
  exit
end

if type -q zoxide
  zoxide init fish | source
end

set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate ''
set __fish_git_prompt_showupstream 'none'
set fish_prompt_pwd_dir_length -1

function fish_prompt
  set_color -o black && echo -n (prompt_pwd)
  set_color -o green && echo -n (__fish_git_prompt)
  set_color black && echo -n " | "
  set_color normal
end

function fish_greeting
end

function fish_mode_prompt
end

function fish_user_key_bindings
  fish_vi_key_bindings
  for mode in insert default visual
    bind -M $mode \cf forward-char
  end
end

abbr -a ga "git add"
abbr -a gaa "git add --all"
abbr -a gc "git commit"
abbr -a gd "git diff"
abbr -a gs "git status"
abbr -a unsus "git commit --amend --no-edit --date (date)"
abbr -a v "nvim"
abbr -a vi "nvim"
abbr -a vim "nvim"
