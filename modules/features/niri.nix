{ self, inputs, ... }:
{
  flake.nixosModules.niri =
    { pkgs, lib, ... }:
    {
      programs.niri = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
      };

      environment.systemPackages = [
        pkgs.nerd-fonts.jetbrains-mono
        pkgs.corefonts
      ];
      services.upower.enable = true;

      fonts.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        rubik
        noto-fonts
      ];

      stylix = {
        enable = true;
        autoEnable = false;

        # this shouldn't actually affect anything since no stylix targets are enabled
        base16Scheme = {
          base00 = "212121";
          base01 = "303030";
          base02 = "353535";
          base03 = "4A4A4A";
          base04 = "B2CCD6";
          base05 = "EEFFFF";
          base06 = "EEFFFF";
          base07 = "FFFFFF";
          base08 = "F07178";
          base09 = "F78C6C";
          base0A = "FFCB6B";
          base0B = "C3E88D";
          base0C = "89DDFF";
          base0D = "82AAFF";
          base0E = "C792EA";
          base0F = "FF5370";
        };

        cursor.package = pkgs.bibata-cursors;
        cursor.name = "Bibata-Modern-Classic";
        cursor.size = 24;

        fonts = {
          monospace = {
            package = pkgs.jetbrains-mono;
            name = "JetBrainsMono";
          };
          sansSerif = {
            package = pkgs.rubik;
            name = "Rubik";
          };
          serif = {
            package = pkgs.noto-fonts;
            name = "Noto Serif";
          };
        };
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
            "voxtype"
          ];

          xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

          input.keyboard.xkb.layout = "us,ua";

          input.touchpad = {
            natural-scroll = _: { };
          };

          extraConfig = ''
            output "Dell Inc. DELL S2721QS 5971N43" {
                position x=-2560 y=0
            }
            output "Dell Inc. DELL S2721QS DV61N43"  {
              position x=-5120 y=0
            }
          '';

          window-rule = {
            geometry-corner-radius = 20;
            clip-to-geometry = true;
          };

          debug.honor-xdg-activation-with-invalid-serial = true;

          layout.gaps = 5;
          input.focus-follows-mouse = _: { };

          binds = {
            "Mod+Return".spawn = lib.getExe pkgs.ghostty;

            "Mod+Q".close-window = _: { };
            "Mod+F".maximize-column = _: { };
            "Mod+G".fullscreen-window = _: { };
            "Mod+Shift+F".toggle-window-floating = _: { };
            "Mod+C".center-column = _: { };

            "Mod+H".focus-column-left = _: { };
            "Mod+L".focus-column-right = _: { };
            "Mod+K".focus-window-up = _: { };
            "Mod+J".focus-window-down = _: { };

            "Mod+Left".focus-monitor-left = _: { };
            "Mod+Right".focus-monitor-right = _: { };
            "Mod+Up".focus-monitor-up = _: { };
            "Mod+Down".focus-monitor-down = _: { };

            "Mod+Shift+H".move-column-left = _: { };
            "Mod+Shift+L".move-column-right = _: { };
            "Mod+Shift+K".move-window-up = _: { };
            "Mod+Shift+J".move-window-down = _: { };

            "Mod+Shift+Left".move-window-to-monitor-left = _: { };
            "Mod+Shift+Right".move-window-to-monitor-right = _: { };
            "Mod+Shift+Up".move-window-to-monitor-up = _: { };
            "Mod+Shift+Down".move-window-to-monitor-down = _: { };

            "Mod+Shift+S".screenshot = _: { };

            "Alt+Space".spawn-sh = "${
              (lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.myNoctalia)
            } ipc call launcher toggle";

            "Super+Delete".spawn-sh = "${
              (lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.myNoctalia)
            } ipc call lockScreen lock";

            "Super+Escape".spawn-sh = "${
              (lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.myNoctalia)
            } ipc call lockScreen lock";

            "Super+period".spawn-sh = "voxtype record toggle";

            "XF86AudioRaiseVolume".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+";
            "XF86AudioLowerVolume".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-";

            "Mod+Ctrl+H".set-column-width = "-5%";
            "Mod+Ctrl+L".set-column-width = "+5%";
            "Mod+Ctrl+J".set-window-height = "-5%";
            "Mod+Ctrl+K".set-window-height = "+5%";

            "Mod+R".switch-preset-column-width = _: { };
            "Mod+Shift+R".switch-preset-window-height = _: { };

            "Mod+bracketleft".consume-or-expel-window-left = _: { };
            "Mod+bracketright".consume-or-expel-window-right = _: { };

            "Mod+O".toggle-overview = _: { };

            "Mod+WheelScrollDown".focus-column-right = _: { };
            "Mod+WheelScrollUp".focus-column-left = _: { };
            "Mod+Ctrl+WheelScrollDown".focus-workspace-down = _: { };
            "Mod+Ctrl+WheelScrollUp".focus-workspace-up = _: { };
          };
        };
      };
    };
}
