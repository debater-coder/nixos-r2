{ self, inputs, ... }:
{
  flake.nixosModules.niri =
    { pkgs, lib, ... }:
    {
      programs.niri = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
      };
    };

  perSystem =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    {
      packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs; # THIS PART IS VERY IMPORTAINT, I FORGOT IT IN THE VIDEO!!!
        settings = {
          spawn-at-startup = [
            (lib.getExe self'.packages.myNoctalia)
          ];

          xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

          input.keyboard.xkb.layout = "us,ua";

          input.touchpad = {
            natural-scroll = null;
          };

          window-rule = {
            geometry-corner-radius = 20;
            clip-to-geometry = true;
          };

          debug.honor-xdg-activation-with-invalid-serial = true;

          layout.gaps = 5;
          input.focus-follows-mouse = null;

          binds = {
            "Mod+Return".spawn = lib.getExe pkgs.kitty;

            "Mod+Q".close-window = null;
            "Mod+F".maximize-column = null;
            "Mod+G".fullscreen-window = null;
            "Mod+Shift+F".toggle-window-floating = null;
            "Mod+C".center-column = null;

            "Mod+H".focus-column-left = null;
            "Mod+L".focus-column-right = null;
            "Mod+K".focus-window-up = null;
            "Mod+J".focus-window-down = null;

            "Mod+Left".focus-monitor-left = null;
            "Mod+Right".focus-monitor-right = null;
            "Mod+Up".focus-monitor-up = null;
            "Mod+Down".focus-monitor-down = null;

            "Mod+Shift+H".move-column-left = null;
            "Mod+Shift+L".move-column-right = null;
            "Mod+Shift+K".move-window-up = null;
            "Mod+Shift+J".move-window-down = null;

            "Mod+Shift+Left".move-window-to-monitor-left = null;
            "Mod+Shift+Right".move-window-to-monitor-right = null;
            "Mod+Shift+Up".move-window-to-monitor-up = null;
            "Mod+Shift+Down".move-window-to-monitor-down = null;

            "Mod+Shift+S".screenshot = null;


            "Alt+Space".spawn-sh = "${
              (lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.myNoctalia)
            } ipc call launcher toggle";

            "Super+Delete".spawn-sh = "${
              (lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.myNoctalia)
            } ipc call lockScreen lock";

            "Super+Escape".spawn-sh = "${
              (lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.myNoctalia)
            } ipc call lockScreen lock";

            "XF86AudioRaiseVolume".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+";
            "XF86AudioLowerVolume".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-";

            "Mod+Ctrl+H".set-column-width = "-5%";
            "Mod+Ctrl+L".set-column-width = "+5%";
            "Mod+Ctrl+J".set-window-height = "-5%";
            "Mod+Ctrl+K".set-window-height = "+5%";

            "Mod+R".switch-preset-column-width = null;
            "Mod+Shift+R".switch-preset-window-height = null;

            "Mod+bracketleft".consume-or-expel-window-left = null;
            "Mod+bracketright".consume-or-expel-window-right = null;

            "Mod+O".toggle-overview = null;

            "Mod+WheelScrollDown".focus-column-left = null;
            "Mod+WheelScrollUp".focus-column-right = null;
            "Mod+Ctrl+WheelScrollDown".focus-workspace-down = null;
            "Mod+Ctrl+WheelScrollUp".focus-workspace-up = null;
          };
      };
    };
  };
}
