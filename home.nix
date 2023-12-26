{ config, pkgs, lib, inputs, system, ... }: {

  home.username = "justin";
  home.homeDirectory = "/home/justin";
  home.file.".config/hypr/hyprland.conf".source = ./hypr/hyprland.conf;
  home.file.".config/hypr/hyprpaper.conf".source = ./hypr/hyprpaper.conf;
  home.file.".config/kitty/kitty.conf".source = ./kitty/kitty.conf;
  home.file.".config/wallpapers".source = ./wallpapers;

  home.packages = with pkgs; [
    kitty
    nixfmt
    ripgrep
    jq
    yq-go
    firefox
    fzf
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
