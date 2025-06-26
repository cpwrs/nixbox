{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.symlink;
in {
  options.symlink = mkOption {
    type = types.attrsOf (types.either types.path types.lines);
    default = {};
    description = "Source of file or text to be symlinked";
  };

  config = mkIf (cfg != {}) {
    system.activationScripts.symlink = {
      text = lib.concatMapStringsSep "\n" (
        target: let
          storePath =
            if builtins.isPath cfg.${target}
            then cfg.${target}
            else pkgs.writeText (baseNameOf target) cfg.${target};
        in ''
          mkdir -p $(dirname "${target}")
          rm -f ${target}
          # Create symlink!
          ln -sf ${storePath} ${target}
        ''
      ) (builtins.attrNames cfg);
    };
  };
}
