{ config, pkgs, ... }: {
  security.rtkit.enable = true;
  security.pam.services.swaylock = { };
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
