{self, ...}: {
  flake.modules.nixos.carson = {
    lib,
    pkgs,
    ...
  }: let
    inherit (lib.generators) toGitINI toYAML;
    email = "me@carsonp.net";
    # All carsons are allowed_signers
    allowedSigners = pkgs.writeText "allowed_signers" (
      builtins.concatStringsSep "\n" (
        map (key: "${email} ${key}") (
          builtins.attrValues self.keys.carsons
        )
      )
      + "\n"
    );
  in {
    users.users.carson.packages = with pkgs; [
      git
      lazygit
    ];

    hjem.users.carson.xdg.config.files = {
      "git/config" = {
        clobber = true;
        generator = toGitINI;
        value = {
          user = {
            inherit email;
            name = "Carson Powers";
            signingkey = "~/.ssh/id_ed25519.pub";
          };
          init.defaultBranch = "master";
          gpg = {
            format = "ssh";
            ssh.allowedSignersFile = allowedSigners;
          };
          commit.gpgsign = true;
          branch.sort = "-committerdate";
          column.ui = "auto";
          tag.sort = "version:refname";
          diff = {
            algorithm = "histogram";
            colorMoved = "plain";
            mnemonicPrefix = true;
            renames = true;
          };
          push = {
            autoSetupRemote = true;
            followTags = true;
          };
          pull.rebase = true;
          fetch = {
            prune = true;
            pruneTags = true;
            all = true;
          };
          rerere = {
            enabled = true;
            autoupdate = true;
          };
          rebase.updateRefs = true;
          merge.tool = "nvimdiff";
        };
      };

      "lazygit/config.yml" = {
        clobber = true;
        generator = toYAML {};
        value = {
          gui = {
            border = "single";
            theme = {
              activeBorderColor = ["#aa93ff" "bold"];
              inactiveBorderColor = ["#3d3028"];
              searchingActiveBorderColor = ["white"];
            };
          };
          git.overrideGpg = true;
        };
      };
    };
  };
}
