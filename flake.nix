{
  description = "nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      nix.settings.experimental-features = [ "nix-command" "flakes" ];
      nix.settings.sandbox = "relaxed";
      nixpkgs.config = import ./conf/nixpkgs.config.nix { lib = pkgs.lib; };
      nixpkgs.hostPlatform = "aarch64-darwin";
      nixpkgs.overlays = [
        (final: prev: {
          ffmpeg = prev.ffmpeg.overrideAttrs (old: {
            postFixup = (old.postFixup or "") + ''
              for f in "$out"/lib/*.dylib; do
                if [ -f "$f" ]; then
                  /usr/bin/codesign --force --sign - "$f"
                fi
              done
              if [ -d "$out/bin" ]; then
                for f in "$out"/bin/*; do
                  if [ -f "$f" ]; then
                    /usr/bin/codesign --force --sign - "$f"
                  fi
                done
              fi
            '';
          });
          fish = prev.fish.overrideAttrs (old: {
            doCheck = false;
            doInstallCheck = false;
          });
        })
      ];
      environment = {
        etc."gitconfig".text = ''
          [safe]
            directory = /etc/nix-darwin
        '';
        etc."newsyslog.d/nixdarwin-upgrade.conf".text = ''
          # logfilename                          mode count size when  flags
          /var/log/nixdarwin-upgrade.log          644  3     512  *     J
          /var/log/nixdarwin-upgrade-error.log    644  3     512  *     J
        '';
        shells = [ pkgs.bash ];
        systemPackages = import ./conf/environment.systemPackages.nix pkgs;
        variables = {
          EDITOR = "nvim";
          VISUAL = "nvim";
        };
      };

      fonts.packages = import ./conf/fonts.packages.nix pkgs;
      
      homebrew = {
        enable  = true;
        taps    = [ "cirruslabs/cli" ];
        brews   = import ./conf/homebrew.brews.nix;
        casks   = import ./conf/homebrew.casks.nix;
        masApps = import ./conf/homebrew.masApps.nix;
      };

      launchd.daemons.nixDarwinUpgrade = import ./conf/launchd.daemons.nixDarwinUpgrade.nix pkgs;
      programs = import ./conf/programs.nix;
      security = import ./conf/security.nix;
      system = import ./conf/system.nix self;
    };
  in
  {
    darwinConfigurations."mbp16" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };
  };
}

