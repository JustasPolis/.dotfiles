{ pkgs, inputs, outputs, unstable, ... }: {
  imports = [
    ./scripts
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.hello.nixosModules.default
    inputs.nordvpn.nixosModules.default
  ];

  programs = {
    fish = {
      enable = true;
      loginShellInit = ''
        echo 1 | sudo tee /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode > /dev/null 
        echo disabled | sudo tee /sys/devices/*/*/*/power/wakeup > /dev/null 
          if test -z "$DISPLAY" -a "$XDG_VTNR" -eq 1
             exec "Hyprland" > /dev/null
          end
      '';
      interactiveShellInit = ''
        set fish_greeting
      '';
    };
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };
    direnv = { enable = true; };
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    pulseaudio = { enable = true; };
    i2c = { enable = true; };
  };

  nixpkgs = {
    config = { allowUnfree = true; };
    overlays = [
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
  };

  environment = {
    pathsToLink = [ "/libexec" ];
    systemPackages = with pkgs; [
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
      nil
      alejandra
      zoxide
      inputs.gtk-waybar.packages.${pkgs.system}.default
      foliate
      gnumake
    ];
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 2;
      };
      efi = { canTouchEfiVariables = true; };
    };
    kernelParams = [ "quiet" ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users = { justin = import ./home.nix; };
  };

  services.hello.enable = true;

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 3d";
    };
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
    optimise = { automatic = true; };
  };

  xdg = {
    portal = {
      enable = true;
      wlr.enable = false;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };

  networking = {
    hostName = "nixos";
    networkmanager = { enable = true; };
    firewall = { enable = true; };
  };

  time = { timeZone = "Europe/Vilnius"; };

  i18n = { defaultLocale = "en_US.UTF-8"; };

  users = {
    users = {
      justin = {
        shell = pkgs.fish;
        isNormalUser = true;
        description = "Justin";
        extraGroups = [ "networkmanager" "wheel" "audio" "nordvpn" ];

      };
    };
  };

  fonts = {
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      roboto
      material-icons
    ];
  };

  system = { stateVersion = "23.11"; };

  security = {
    rtkit = { enable = true; };
    pam = {
      services = { swaylock = { }; };
      loginLimits = [{
        domain = "@users";
        item = "rtprio";
        type = "-";
        value = 1;
      }];
    };
    sudo = {
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

  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.devmon.enable = true;
  services.mullvad-vpn.enable = false;
  services.dbus.enable = true;

  services.upower.enable = true;

  services.logind.extraConfig = ''
    HandlePowerKey=ignore
    HandleLidSwitch=ignore
    HandleLidSwitchExternalPower=ignore
    HandleLidSwitchDocked=ignore
    LidSwitchIgnoreInhibited=yes
    HandleHibernateKey=ignore
    HandleSuspendKey=ignore
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

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", DRIVER=="usb", ATTR{power/wakeup}="disabled"
    ACTION=="add", SUBSYSTEM=="pci", DRIVER=="pcieport", ATTR{power/wakeup}="disabled"
  '';

}
