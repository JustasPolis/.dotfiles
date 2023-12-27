{ config, pkgs, lib, inputs, system, ... }: {

  home.username = "justin";
  home.homeDirectory = "/home/justin";
  home.file.".config/hypr/hyprland.conf".source = ./hypr/hyprland.conf;
  home.file.".config/hypr/hyprpaper.conf".source = ./hypr/hyprpaper.conf;
  home.file.".config/kitty/kitty.conf".source = ./kitty/kitty.conf;
  home.file.".config/wallpapers".source = ./wallpapers;
  home.file.".config/swayidle/config".source = ./swayidle/config;
  home.file.".config/swaylock/config".source = ./swaylock/config;

  home.packages = with pkgs; [
    kitty
    nixfmt
    ripgrep
    jq
    yq-go
    fzf
    firefox
    neovim
    swaylock-effects
    neofetch
    swayidle
    hyprpaper
    neovim
  ];

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
