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
  set split_pwd (string split -r -m1 / (prompt_pwd))
  set_color white && echo -n "$split_pwd[1]/"
  set_color -o cyan && echo -n $split_pwd[2]
  set_color magenta && printf '%s ' (__fish_git_prompt)
  set_color -o magenta && echo -n "| "
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
