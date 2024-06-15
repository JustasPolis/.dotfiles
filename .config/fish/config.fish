starship init fish | source
direnv hook fish | source
alias ls="exa --icons"
abbr --add nixrebuild 'sudo nixos-rebuild switch --flake ~/.dotfiles/.#justin'
set fzf_fd_opts --hidden --max-depth 3
alias imgpreview="swayimg -c swayimg 2> /dev/null"
set EDITOR nvim
set BAT_THEME "ansi"
set -g fish_key_bindings fish_vi_key_bindings

#bind -M insert \t accept-autosuggestion
#bind -M insert \cn 'commandline -f complete'
#bind -M insert \cp 'commandline -f complete-and-search'

bind yy fish_clipboard_copy
bind p fish_clipboard_paste
zoxide init --cmd cd fish | source
set -x PATH $PATH ~/.cargo/bin

bind -M default \cz 'fg 2>/dev/null; commandline -f repaint'
bind -M insert \cz 'fg 2>/dev/null; commandline -f repaint'

set fish_color_valid_path
set fish_color_redirection cyan
set fish_color_history_current
set fish_pager_color_prefix normal
set fish_color_selection white

set -Ux FZF_DEFAULT_OPTS "\
--ansi \
--border rounded \
--color='16,bg+:-1,gutter:-1,prompt:5,pointer:5,marker:6,border:4,label:4,header:italic' \
--marker=' ' \
--no-info \
--no-separator \
--pointer='👉' \
--reverse"

set -Ux FZF_TMUX_OPTS "-p 55%,60%"

set -Ux FZF_CTRL_R_OPTS "\
--border-label=' history ' \
--prompt='  '"
