{ config, pkgs, lib, inputs, system, ... }: {

  home.username = "justin";
  home.homeDirectory = "/home/justin";

  #wayland.windowManager.hyprland.enable = true;
  home.file.".config/hypr/hyprland.conf".source = ./hypr/hyprland.conf;

  programs.git = {
    enable = true;
    userName = "Justin Polis";
    userEmail = "j.polikevicius@gmail.com";
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processer https://github.com/mikefarah/yq
    fzf
    firefox
	neovim
	kitty
	swaylock-effects
	neofetch
	swayidle
	hyprpaper
	neovim
  ];

  programs.bash = {
    enable = true;
    enableCompletion = true;
  };
  
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
