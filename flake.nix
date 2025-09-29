{
  description = "nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.shells = [ pkgs.bash ];
      environment.systemPackages = with pkgs;
        [
          ansible
          aria2
          arping
          bash
          bash-completion
          btop
          coreutils
          curl
          docker
          docker-compose
          dos2unix
          dosbox-x
          ffmpeg
          findutils
          fping
          gawk
          gdbm
          gnused
          graphviz
          iftop
          imagemagick
          inetutils
          jq
          gnumake
          minicom
          mkvtoolnix
          moreutils
          mosh
          mpv
          mtr
          neovim
          netcat
          nmap
          opusTools
          openssh
          pass
          picocom
          pstree
          pwgen
          python3
          rclone
          restic
          ripgrep
          rsync
          ruff
          shellcheck
          smartmontools
          socat
          sox
          stockfish
          vim
          watch
          wget
          wireguard-tools
          zig
          zlib       
        ];

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      programs.bash.enable = true;
      
      security.pam.services.sudo_local.touchIdAuth = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;
      
      system.defaults = {
        dock.autohide = true;
        finder.AppleShowAllExtensions = true;
        finder.FXPreferredViewStyle = "clmv";
      };
      
      system.primaryUser = "hays";

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#mbp16
    darwinConfigurations."mbp16" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };
  };
}
