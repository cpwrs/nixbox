{
  flake.modules.nixos.toaster = {
    lib,
    modulesPath,
    config,
    ...
  }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "sr_mod"];
    boot.initrd.kernelModules = [];
    boot.kernelModules = ["kvm-intel"];
    boot.extraModulePackages = [];

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/33e8b576-10b2-4a1c-8763-da93f790d09d";
      fsType = "ext4";
    };

    swapDevices = [
      {device = "/dev/disk/by-uuid/a951d816-878d-4e91-96c7-475f40eb6fec";}
    ];

    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    boot.loader.grub = {
      enable = true;
      device = "/dev/nvme0n1";
      useOSProber = true;
    };
  };
}
