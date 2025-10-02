{
  description = "nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      nixpkgs.hostPlatform = "aarch64-darwin";
      
      environment = {
        shells = [ pkgs.bash ];
        systemPackages = with pkgs;
        [
          ansible
          aria2
          arping
          awscli2
          bash
          bash-completion
          btop
          colordiff
          coreutils
          curl
          dnsutils
          docker
          docker-compose
          dos2unix
          dosbox-x
          ffmpeg
          findutils
          fping
          gawk
          gdbm
          gh
          git
          gnugrep
          gnused
          graphviz
          htop
          iftop
          imagemagick
          imgcat
          intermodal
          inetutils
          iperf
          jq
          gnumake
          mas
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
          screen
          shellcheck
          smartmontools
          socat
          sox
          stockfish
          tree
          uv
          vim
          vimPlugins.nvim-treesitter.withAllGrammars
          watch
          wezterm
          wget
          wireguard-tools
          xld
          yq
          zig
          zlib       
        ];
      };

      fonts.packages = with pkgs; [
        fira-code
        fira-code-symbols
        nerd-fonts.jetbrains-mono
        mplus-outline-fonts.githubRelease
        noto-fonts
        noto-fonts-emoji
      ];
      
      homebrew = {
        enable = true;

        casks = [
          "1password"
          "1password-cli"
          "alt-tab"
          "balenaetcher"
          "busycontacts"
          "caffeine"
          "daisydisk"
          "discord"
          "firefox@esr"
          "firefox@developer-edition"
          "element"
          "ghostty"
          "gimp"
          "handbrake-app"
          "jellyfin-media-player"
          "knockknock"
          "logseq"
          "lulu"
          "maintenance"
          "movist-pro"
          "rectangle"
          "signal"
          "slack"
          "splice"
          "steam"
          "vlc"
          "vscodium"
          "zed"
          "zoom"
        ];

        masApps = {
          "Logic Pro" = 634148309;
          "Microsoft Remote Desktop" = 1295203466;
          "MindNode" = 1289197285;
          "TestFlight" = 899247664;
          "The Unarchiver" = 425424353;
          "WireGuard" = 1451685025;
        };
      };

      # Necessary for recommended use of flakes for managing nix-darwin
      nix.settings.experimental-features = [ "nix-command" "flakes" ];

      programs = {
        bash = {
          enable = true;
          completion.enable = true;
        };

        direnv.enable = true;

        gnupg.agent = {
          enable = true;
          enableSSHSupport = true;
        };

        nix-index.enable = true;

        vim = {
          enable = true;
          enableSensible = true;
        };
      };

      security.pam.services.sudo_local.touchIdAuth = true;

      system = {
        # Set Git commit hash for darwin-version.
        configurationRevision = self.rev or self.dirtyRev or null;

        startup.chime = false;

        defaults = {
          dock.autohide = true;

          finder = {
            AppleShowAllFiles = true;
            AppleShowAllExtensions = true;
            FXPreferredViewStyle = "clmv";
          };

          SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
        };
      
        primaryUser = "hays";
      };

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;
    };
  in
  {
    darwinConfigurations."mbp16" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };
  };
}
