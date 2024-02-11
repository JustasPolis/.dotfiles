{ pkgs, ... }:
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
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS gnome_schema=org.gnome.desktop.interface
           gsettings set $gnome_schema gtk-theme 'rose-pine-gtk'
           gsettings set $gnome_schema font-antialiasing 'grayscale'
           gsettings set $gnome_schema font-hinting 'slight' gsettings set $gnome_schema font-name 'Roboto Medium, 10'
           gsettings set $gnome_schema document-font-name 'Roboto Medium, 10'
           gsettings set $gnome_schema monospace-font-name 'JetBrainsMono NF Medium, 13'
           gsettings set $gnome_schema cursor-theme 'Bibata-Modern-Ice'
           gsettings set $gnome_schema cursor-size 24 gsettings set $gnome_schema toolbar-icons-size 'small' gsettings set org.gnome.mutter auto-maximize 'false'
           gsettings set $gnome_schema color-scheme 'prefer-dark'
    '';
  };
  power-settings = pkgs.writeShellScriptBin "power-settings" ''
    ac_adapter_status=$(cat /sys/class/power_supply/ACAD/online)

    if [[ $ac_adapter_status -eq 1 ]]; then
        # If ACAD/online is 1, set the governor to performance
        sudo ${pkgs.linuxKernel.packages.linux_xanmod_latest.cpupower}/bin/cpupower frequency-set --governor performance
        echo "performance" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference
    elif [[ $ac_adapter_status -eq 0 ]]; then
        # If ACAD/online is 0, set the governor to powersave
        sudo ${pkgs.linuxKernel.packages.linux_xanmod_latest.cpupower}/bin/cpupower frequency-set --governor powersave
        echo "balance_power" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference
    else
        # Handle other cases if needed
        echo "Unexpected value in AC status: $ac_adapter_status"
    fi
  '';
in {
  environment.systemPackages =
    [ dbus-hyprland-environment configure-gtk power-settings ];
}
