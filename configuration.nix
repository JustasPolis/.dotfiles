{ config, pkgs, lib, inputs, outputs, nixpkgs-unstable, nixpkgs-personal, ... }:
let
  dbus-hyprland-environment = pkgs.writeTextFile {
    name = "dbus-hyprland-environment";
    destination = "/bin/dbus-hyprland-environment";
    executable = true;
    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=hyprland
      systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    '';
  };
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS gnome_schema=org.gnome.desktop.interface gsettings set $gnome_schema gtk-theme 'rose-pine'
           gsettings set $gnome_schema font-antialiasing 'grayscale'
           gsettings set $gnome_schema font-hinting 'slight'
           gsettings set $gnome_schema font-name 'Roboto Medium, 10'
           gsettings set $gnome_schema document-font-name 'Roboto Medium, 10'
           gsettings set $gnome_schema monospace-font-name 'JetBrainsMono NF Medium, 13'
           gsettings set $gnome_schema cursor-theme 'Bibata-Modern-Ice'
           gsettings set $gnome_schema cursor-size 24 gsettings set $gnome_schema toolbar-icons-size 'small' gsettings set org.gnome.mutter auto-maximize 'false'
    '';
  };
  power-settings = pkgs.writeShellScriptBin "power-settings" ''
        ac_adapter_status=$(cat /sys/class/power_supply/ACAD/online)

    if [[ $ac_adapter_status -eq 1 ]]; then
        # If ACAD/online is 1, set the governor to performance
        sudo cpupower frequency-set --governor performance
        echo "performance" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference
    elif [[ $ac_adapter_status -eq 0 ]]; then
        # If ACAD/online is 0, set the governor to powersave
        sudo cpupower frequency-set --governor powersave
        echo "balance_power" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference
    else
        # Handle other cases if needed
        echo "Unexpected value in AC status: $ac_adapter_status"
    fi  '';
in {
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users = { justin = import ./home.nix; };
  };

  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.devmon.enable = true;
  environment.pathsToLink = [ "/libexec" ];
  programs.fish.enable = true;
  programs.fish.loginShellInit = ''
    if test -z "$DISPLAY" -a "$XDG_VTNR" -eq 1
       exec "Hyprland" > /dev/null
    end
  '';
  users.users.justin.shell = pkgs.fish;
  programs.fish.interactiveShellInit = ''
    set fish_greeting
  '';
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 2;
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

  powerManagement.resumeCommands = ''
    echo "This should show up in the journal after resuming."
  '';

  networking.hostName = "nixos"; # Define your hostname.

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  services.blueman.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Vilnius";
  i18n.defaultLocale = "en_US.UTF-8";

  sound.enable = true;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.justin = {
    isNormalUser = true;
    description = "Justin";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  nixpkgs.config.allowUnfree = true;
  services.mullvad-vpn.enable = false;
  services.dbus.enable = true;

  environment.systemPackages = with pkgs; [
    git
    fzf
    dbus-hyprland-environment
    fishPlugins.fzf-fish
    starship
    fd
    bat
    brightnessctl
    pamixer
    socat
    killall
    configure-gtk
    glib
    rose-pine-gtk-theme
    bibata-cursors
    power-settings
    linuxKernel.packages.linux_xanmod_latest.cpupower
    mpv
    nixpkgs-unstable.legacyPackages.${pkgs.system}.hyprshot
    hyprshade
    #nixpkgs-personal.legacyPackages.${pkgs.system}.swaylock
    nixpkgs-unstable.legacyPackages.${pkgs.system}.swaylock-effects
  ];

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    roboto
  ];

  networking.firewall.enable = true;

  security.pam.services.swaylock = { };
  security.pam.services.waylock = { };

  services.upower.enable = true;

  services.logind.extraConfig = ''
    HandlePowerKey=ignore
    HandleLidSwitch=ignore
    HandleLidSwitchExternalPower=ignore
    HandleLidSwitchDocked=ignore
  '';

  services.acpid = {
    enable = true;
    lidEventCommands = "systemctl suspend";
  };

  services.acpid.handlers = {
    ac-power = {
      event = "ac_adapter/*";
      action = ''
         vals=($1)  # space separated string to array of multiple values
         case ''${vals[3]} in
             00000000)
        /run/current-system/sw/bin/cpupower frequency-set --governor powersave
        echo "balance_power" | /run/current-system/sw/bin/tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference 
                 ;;
             00000001)
        /run/current-system/sw/bin/cpupower frequency-set --governor performance
        echo "performance" | /run/current-system/sw/bin/tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference 
                 ;;
             *)
                 echo unknown >> /tmp/acpi.log
                 ;;
         esac
      '';
    };
  };

  system.stateVersion = "23.11";

  security.pam.loginLimits = [{
    domain = "@users";
    item = "rtprio";
    type = "-";
    value = 1;
  }];

  boot.kernelParams = [ "quiet" ];

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", DRIVER=="usb", ATTR{power/wakeup}="enabled"
  '';

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
      ];
      groups = [ "wheel" ];
    }];
  };
}
