{ config, pkgs, lib, inputs, system, ... }: {

  home.username = "justin";
  home.homeDirectory = "/home/justin";

  home.file.".config/hypr/hyprland.conf".source = ./hypr/hyprland.conf;

  home.packages = with pkgs; [
    nixfmt
    ripgrep
    jq
    yq-go
    firefox
    fzf
    neovim
    kitty
    swaylock-effects
    neofetch
    swayidle
    hyprpaper
    neovim
  ];

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
