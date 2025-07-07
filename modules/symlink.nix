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
    description = "File, directory, or text to symlink";
  };

  config = mkIf (cfg != {}) {
    system.activationScripts.symlink = {
      deps = ["users"];
      text = lib.concatMapStringsSep "\n" (
        target: let
          storePath =
            if builtins.isPath cfg.${target}
            then cfg.${target}
            else pkgs.writeText (baseNameOf target) cfg.${target};
        in ''
          mkdir -p $(dirname "${target}")
          
          if [ -L ${target} ] && [ "$(readlink "${target}")" = "${storePath}" ]; then
            echo "Symlink ${target} already exists and points to correct store path, skipping"
          else
            rm -rf ${target}
            ln -sf ${storePath} ${target}
            echo "Created/updated symlink: ${target} -> ${storePath}"
          fi
        ''
      ) (builtins.attrNames cfg);
    };
  };
}
