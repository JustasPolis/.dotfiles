{ config, pkgs, unstable, fork, local, ... }: {
  nixpkgs.overlays = [
    (final: prev: {
      ddcutil = prev.ddcutil.overrideAttrs (previousAttrs: rec {
        version = "2.1.0";
        src = prev.fetchurl {
          url = "https://www.ddcutil.com/tarballs/ddcutil-${version}.tar.gz";
          hash = "sha256-YiJrkxcoLVI/GTW8S5gMHFY30zjs0xnj5yZPmBCF5q0=";
        };
      });
    })
  ];

  environment.pathsToLink = [ "/libexec" ];
  environment.systemPackages = with pkgs; [
    git
    fzf
    fishPlugins.fzf-fish
    starship
    fd
    bat
    brightnessctl
    pamixer
    socat
    killall
    glib
    rose-pine-gtk-theme
    bibata-cursors
    jc
    linuxKernel.packages.linux_xanmod_latest.cpupower
    mpv
    unstable.hyprshot
    hyprshade
    ddcutil
    unstable.swaylock-effects
    curl
    unzip
    gzip
    home-manager
    unstable.neovim
  ];
}

