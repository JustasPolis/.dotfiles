{
  config,
  pkgs,
  ...
}: {
  home.username = "justin";
  home.homeDirectory = "/home/justin";
  home.file.".config/hypr".source = config.lib.file.mkOutOfStoreSymlink ./.config/hypr;
  home.file.".config/kitty".source = config.lib.file.mkOutOfStoreSymlink ./.config/kitty;
  home.file.".config/wallpapers".source = config.lib.file.mkOutOfStoreSymlink ./.config/wallpapers;
  home.file.".config/fish/config.fish".source = config.lib.file.mkOutOfStoreSymlink ./.config/fish/config.fish;
  home.file.".config/fish/functions".source = config.lib.file.mkOutOfStoreSymlink ./.config/fish/functions;
  home.file.".config/starship.toml".source = config.lib.file.mkOutOfStoreSymlink ./.config/starship/starship.toml;
  home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink ./.config/nvim;
  home.file.".config/swayimg/config".source = config.lib.file.mkOutOfStoreSymlink ./.config/swayimg/config;
  home.file.".config/bat".source = ./.config/bat;
  home.file.".config/git".source = ./.config/git;

  nixpkgs.config = {allowUnfree = true;};

  home.packages = with pkgs; [
    kitty
    nixfmt
    ripgrep
    jq
    file
    yq-go
    neofetch
    eza
    imagemagick
    perl538Packages.FileMimeInfo
    lf
    swayimg
    stylua
    wl-clipboard
    sway-audio-idle-inhibit
    firefox
    celluloid
    transmission-gtk
    shfmt
    trash-cli
    nodePackages_latest.typescript-language-server
    nodePackages_latest.prettier
    typescript
  ];

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
