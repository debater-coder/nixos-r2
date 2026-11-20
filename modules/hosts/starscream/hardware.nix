{ self, inputs, ... }:
{
  flake.nixosModules.starscreamHardware =
    {
      config,
      lib,
      pkgs,
      modulesPath,
      ...
    }:

    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      boot.initrd.availableKernelModules = [
        "xhci_pci"
        "thunderbolt"
        "vmd"
        "nvme"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-intel" ];
      boot.extraModulePackages = [ ];

      fileSystems."/" = {
        device = "/dev/mapper/luks-93f5484d-8cb4-4224-a09b-1cf1f4011220";
        fsType = "ext4";
      };

      boot.initrd.luks.devices."luks-93f5484d-8cb4-4224-a09b-1cf1f4011220".device =
        "/dev/disk/by-uuid/93f5484d-8cb4-4224-a09b-1cf1f4011220";

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/05E4-D4FB";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };

      swapDevices = [
        {
          device = "/dev/disk/by-partuuid/1bcef962-937f-4c69-98d8-4f9133c343a3";
          randomEncryption.enable = true;
        }
      ];

      # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
      # (the default) this is the recommended approach. When using systemd-networkd it's
      # still possible to use this option, but it's recommended to use it in conjunction
      # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
      networking.useDHCP = lib.mkDefault true;
      # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
