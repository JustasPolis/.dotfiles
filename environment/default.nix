{ config, pkgs, unstable, fork, ... }: {
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
    fork.ddcutil
    unstable.swaylock-effects
    curl
    unzip
    gzip
  ];
}

