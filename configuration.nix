{ config, pkgs, lib, inputs, outputs, unstable, fork, ... }: {
  imports = [
    ./scripts
    ./programs
    ./boot
    ./services
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users = { justin = import ./home.nix; };
  };

  environment.pathsToLink = [ "/libexec" ];

  users.users.justin.shell = pkgs.fish;
  nix.settings.auto-optimise-store = true;
  nix.optimise.automatic = true;

  xdg.portal = {
    enable = true;
    wlr.enable = false;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 3d";
  };

  systemd.services."before-suspend" = {
    description = "Sets up the suspend";
    wantedBy = [ "suspend.target" ];
    before = [ "systemd-suspend.service" ];
    script = ''
      percentage=$(/run/current-system/sw/bin/upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -oP 'percentage:\s+\K\d+')
      echo "$(date '+%Y-%m-%d %H:%M:%S') going to sleep battery $percentage%" >> /home/justin/suspend.log
      /run/current-system/sw/bin/rfkill block bluetooth
      /run/current-system/sw/bin/rfkill block wlan
    '';
    serviceConfig.Type = "oneshot";
  };
  systemd.services."after-suspend" = {
    description = "sets up after suspend";
    wantedBy = [ "suspend.target" ];
    after = [ "systemd-suspend.service" ];
    script = ''
       percentage=$(/run/current-system/sw/bin/upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -oP 'percentage:\s+\K\d+')
       echo "$(date '+%Y-%m-%d %H:%M:%S') woke up battery $percentage%" >> /home/justin/suspend.log
      # /run/current-system/sw/bin/rfkill unblock bluetooth
       /run/current-system/sw/bin/rfkill unblock wlan
    '';
    serviceConfig.Type = "oneshot";
  };
  networking.hostName = "nixos"; # Define your hostname.

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true;

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Vilnius";
  i18n.defaultLocale = "en_US.UTF-8";

  security.rtkit.enable = true;
  hardware.pulseaudio.enable = true;

  users.users.justin = {
    isNormalUser = true;
    description = "Justin";
    extraGroups = [ "networkmanager" "wheel" "audio" ];
  };

  nixpkgs.config.allowUnfree = true;
  hardware.i2c.enable = true;

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
  ];

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    roboto
    material-icons
  ];

  networking.firewall.enable = true;

  security.pam.services.swaylock = { };
  security.pam.services.waylock = { };

  system.stateVersion = "23.11";

  security.pam.loginLimits = [{
    domain = "@users";
    item = "rtprio";
    type = "-";
    value = 1;
  }];

  security.sudo = {
    enable = true;
    extraRules = [{
      commands = [
        {
          command = "${pkgs.systemd}/bin/systemctl suspend";
          options = [ "NOPASSWD" ];
        }
        {
          command = "${pkgs.systemd}/bin/reboot";
          options = [ "NOPASSWD" ];
        }
        {
          command = "${pkgs.systemd}/bin/poweroff";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/systemctl stop bluetooth";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/systemctl start bluetooth";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/cpupower";
          options = [ "NOPASSWD" ];
        }
        {
          command =
            "/run/current-system/sw/bin/tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference";
          options = [ "NOPASSWD" ];
        }
        {
          command =
            "/run/current-system/sw/bin/tee /sys/devices/*/*/*/power/wakeup";
          options = [ "NOPASSWD" ];
        }
        {
          command =
            "/run/current-system/sw/bin/tee /sys/bus/platform/drivers/ideapad_acpi/*";
          options = [ "NOPASSWD" ];
        }

      ];
      groups = [ "wheel" ];
    }];
  };
}
