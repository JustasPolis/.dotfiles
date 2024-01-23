{ config, pkgs, ... }: {
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
