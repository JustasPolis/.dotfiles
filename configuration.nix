{
  pkgs,
  inputs,
  outputs,
  unstable,
  staging,
  ...
}: {
  imports = [
    ./scripts
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.hello.nixosModules.default
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
    direnv = {enable = true;};
    wireshark = {enable = true;};
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    pulseaudio = {
      enable = true;
      extraConfig = ''
        .ifexists module-dbus-protocol.so
        load-module module-dbus-protocol
        .endif
      '';
    };
    i2c = {enable = true;};
  };

  nixpkgs = {
    config = {allowUnfree = true;};
    overlays = [
      (final: prev: {
        ddcutil = prev.ddcutil.overrideAttrs (previousAttrs: rec {
          version = "2.1.0";
          src = prev.fetchurl {
            url = "https://www.ddcutil.com/tarballs/ddcutil-${version}.tar.gz";
            hash = "sha256-YiJrkxcoLVI/GTW8S5gMHFY30zjs0xnj5yZPmBCF5q0=";
          };
        });
        power-profiles-daemon = prev.power-profiles-daemon.overrideAttrs (previousAttrs: rec {
          version = "0.20";
          src = prev.fetchFromGitLab {
            domain = "gitlab.freedesktop.org";
            owner = "upower";
            repo = "power-profiles-daemon";
            rev = version;
            sha256 = "sha256-8wSRPR/1ELcsZ9K3LvSNlPcJvxRhb/LRjTIxKtdQlCA=";
          };
          doCheck = false;
        });
      })
    ];
  };

  environment = {
    pathsToLink = ["/libexec"];
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
      unstable.lua-language-server
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
      inputs.neovim-nightly-overlay.packages.${pkgs.system}.default
      nil
      alejandra
      zoxide
      #inputs.gtk-waybar.packages.${pkgs.system}.default
      foliate
      gnumake
      wgnord
      btop
      inputs.hyprlock.packages.${pkgs.system}.default
      inputs.hypridle.packages.${pkgs.system}.default
      power-profiles-daemon
      unstable.vscode
      staging.pulseaudio
      unstable.wl-screenrec
      unstable.bitwarden-cli
      unstable.obsidian
      unstable.networkmanagerapplet
    ];
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 2;
      };
      efi = {canTouchEfiVariables = true;};
    };
    kernelParams = ["quiet"];
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    users = {justin = import ./home.nix;};
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
      experimental-features = ["nix-command" "flakes"];
    };
    optimise = {automatic = true;};
  };

  xdg = {
    portal = {
      enable = true;
      wlr.enable = false;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
    };
  };

  networking = {
    hostName = "nixos";
    networkmanager = {enable = true;};
    firewall = {
      enable = true;
      logReversePathDrops = true;
      extraCommands = ''
        ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN
        ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN
      '';
      extraStopCommands = ''
        ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN || true
        ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN || true
      '';
    };
  };

  time = {timeZone = "Europe/Vilnius";};

  i18n = {defaultLocale = "en_US.UTF-8";};

  users = {
    users = {
      justin = {
        shell = pkgs.fish;
        isNormalUser = true;
        description = "Justin";
        extraGroups = ["networkmanager" "wheel" "audio" "nordvpn" "wireshark"];
      };
    };
  };

  fonts = {
    packages = with pkgs; [
      (nerdfonts.override {fonts = ["JetBrainsMono"];})
      roboto
      material-icons
      unstable.material-design-icons
    ];
  };

  system = {stateVersion = "23.11";};

  security = {
    rtkit = {enable = true;};
    pam = {
      services = {swaylock = {};};
      loginLimits = [
        {
          domain = "@users";
          item = "rtprio";
          type = "-";
          value = 1;
        }
      ];
    };
    sudo = {
      enable = true;
      extraRules = [
        {
          commands = [
            {
              command = "${pkgs.systemd}/bin/systemctl suspend";
              options = ["NOPASSWD"];
            }
            {
              command = "${pkgs.systemd}/bin/reboot";
              options = ["NOPASSWD"];
            }
            {
              command = "${pkgs.systemd}/bin/poweroff";
              options = ["NOPASSWD"];
            }
            {
              command = "/run/current-system/sw/bin/systemctl stop bluetooth";
              options = ["NOPASSWD"];
            }
            {
              command = "/run/current-system/sw/bin/systemctl start bluetooth";
              options = ["NOPASSWD"];
            }
            {
              command = "/run/current-system/sw/bin/cpupower";
              options = ["NOPASSWD"];
            }
            {
              command = "/run/current-system/sw/bin/tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference";
              options = ["NOPASSWD"];
            }
            {
              command = "/run/current-system/sw/bin/tee /sys/devices/*/*/*/power/wakeup";
              options = ["NOPASSWD"];
            }
            {
              command = "/run/current-system/sw/bin/tee /sys/bus/platform/drivers/ideapad_acpi/*";
              options = ["NOPASSWD"];
            }
          ];
          groups = ["wheel"];
        }
      ];
    };
  };

  systemd.services."before-suspend" = {
    description = "Sets up the suspend";
    wantedBy = ["suspend.target"];
    before = ["systemd-suspend.service"];
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
    wantedBy = ["suspend.target"];
    after = ["systemd-suspend.service"];
    script = ''
      percentage=$(/run/current-system/sw/bin/upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -oP 'percentage:\s+\K\d+')
      echo "$(date '+%Y-%m-%d %H:%M:%S') woke up battery $percentage%" >> /home/justin/suspend.log
      /run/current-system/sw/bin/rfkill unblock bluetooth
      /run/current-system/sw/bin/rfkill unblock wlan
    '';
    serviceConfig.Type = "oneshot";
  };

  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.devmon.enable = true;
  services.mullvad-vpn.enable = false;
  services.dbus.enable = true;
  services.dbus.packages = with pkgs; [power-profiles-daemon];
  services.udev.packages = with pkgs; [power-profiles-daemon];
  systemd.packages = with pkgs; [power-profiles-daemon];

  services.upower.enable = true;
  services.upower.criticalPowerAction = "PowerOff";

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
            ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set balanced
                ;;
            00000001)
            ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set performance
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
