{ config, pkgs, lib, inputs, system, ... }: {

  home.username = "justin";
  home.homeDirectory = "/home/justin";
  home.file.".config/hypr/hyprland.conf".source = ./hypr/hyprland.conf;
  home.file.".config/hypr/hyprpaper.conf".source = ./hypr/hyprpaper.conf;
  home.file.".config/kitty".source = ./kitty;
  home.file.".config/wallpapers".source = ./wallpapers;
  home.file.".config/swayidle/config".source = ./swayidle/config;
  home.file.".config/swaylock/config".source = ./swaylock/config;
  home.file.".config/fish/config.fish".source = ./fish/config.fish;
  home.file.".config/starship.toml".source = ./starship/starship.toml;
  home.file.".config/nvim".source = ./nvim;
  home.file.".config/gtk-3.0".source = ./gtk-3.0;
  home.file.".config/swayimg/config".source = ./swayimg/config;
  

  home.packages = with pkgs; [
    kitty
    nixfmt
    ripgrep
    jq
    yq-go
    firefox
    neovim
    swaylock-effects
    neofetch
    swayidle
    hyprpaper
    neovim
    eza
    clang
    nodejs
    go
    lua-language-server
    wofi
    eww-wayland
    glib
    imagemagick
    lf
    swayimg
    stylua
    wl-clipboard
    rustup
    vlc
  ];

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
