{
  flake.modules.nixos.bluetooth = {
    config,
    lib,
    ...
  }: let
    inherit (lib.modules) mkIf;
  in {
    services.blueman.enable = mkIf (config.hardware.facter.report.hardware.bluetooth or [] != []) true;
  };
}
