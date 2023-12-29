starship init fish | source
alias ls="exa --icons"
abbr --add nixrebuild 'sudo nixos-rebuild switch --flake ~/.dotfiles/.#justin'
set fzf_fd_opts --hidden --max-depth 3
