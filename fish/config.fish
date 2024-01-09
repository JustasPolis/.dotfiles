starship init fish | source
alias ls="exa --icons"
abbr --add nixrebuild 'sudo nixos-rebuild switch --flake ~/.dotfiles/.#justin'
set fzf_fd_opts --hidden --max-depth 3
alias imgpreview="swayimg -c swayimg 2> /dev/null"
set EDITOR nvim
set -g fish_key_bindings fish_vi_key_bindings

bind yy fish_clipboard_copy
bind p fish_clipboard_paste


