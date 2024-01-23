{ config, pkgs, inputs, ... }: {
  programs.fish.enable = true;
  programs.fish.loginShellInit = ''
    echo 1 | sudo tee /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode > /dev/null 
    echo disabled | sudo tee /sys/devices/*/*/*/power/wakeup > /dev/null 
      if test -z "$DISPLAY" -a "$XDG_VTNR" -eq 1
         exec "Hyprland" > /dev/null
      end
  '';
  programs.fish.interactiveShellInit = ''
    set fish_greeting
  '';

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  programs.direnv.enable = true;
}
