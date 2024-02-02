{ config, pkgs, lib, inputs, system, ... }: {

  home.username = "justin";
  home.homeDirectory = "/home/justin";
  home.file.".config/hypr".source = ./.config/hypr;
  home.file.".config/kitty".source = ./.config/kitty;
  home.file.".config/wallpapers".source = ./.config/wallpapers;
  home.file.".config/swayidle/config".source = ./.config/swayidle/config;
  home.file.".config/swaylock/config".source = ./.config/swaylock/config;
  home.file.".config/fish/config.fish".source = ./.config/fish/config.fish;
  home.file.".config/fish/functions".source = ./.config/fish/functions;
  home.file.".config/starship.toml".source = ./.config/starship/starship.toml;
  home.file.".config/nvim".source = ./.config/nvim;
  home.file.".config/swayimg/config".source = ./.config/swayimg/config;
  home.file.".config/gtk-4.0".source = ./.config/gtk-4.0;
  home.file.".config/wofi".source = ./.config/wofi;
  #home.file.".config/eww".source = ./.config/eww;
  home.file.".config/lf".source = ./.config/lf;
  home.file.".config/bat".source = ./.config/bat;

  nixpkgs.config = { allowUnfree = true; };

  home.packages = with pkgs; [
    kitty
    nixfmt
    ripgrep
    jq
    file
    yq-go
    neofetch
    swayidle
    hyprpaper
    neovim
    eza
    lua-language-server
    wofi
    eww-wayland
    imagemagick
    perl538Packages.FileMimeInfo
    lf
    swayimg
    stylua
    wl-clipboard
    sway-audio-idle-inhibit
    firefox-unwrapped
    celluloid
    transmission-gtk
    shfmt
    floorp
    trash-cli
  ];

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
