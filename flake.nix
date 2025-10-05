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
        systemPackages = import ./systemPackages.nix pkgs;
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
          "blockblock"
          "busycontacts"
          "caffeine"
          "calibre"
          "daisydisk"
          "discord"
          "firefox@esr"
          "firefox@developer-edition"
          "element"
          "ghostty"
          "gimp"
          "handbrake-app"
          "hex-fiend"
          "jellyfin-media-player"
          "kitty"
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
          "utm"
          "virtualbox"
          "visual-studio-code"
          "vlc"
          "vscodium"
          "wezterm"
          "wireshark-app"
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

      launchd.daemons.nixDarwinUpgrade = {
        script = ''
          printf "----------\n%s----------\n" "$(date)"
          nix-channel  --update
          nix flake update 
          /run/current-system/sw/bin/darwin-rebuild switch --flake .
        '';
        serviceConfig = {
          StartInterval = 86400; # every 24 hours
          RunAtLoad = true;
          WorkingDirectory = "/etc/nix-darwin";
          StandardOutPath = "/var/log/nixdarwin-upgrade.log";
          StandardErrorPath = "/var/log/nixdarwin-upgrade-error.log";
          UserName = "root";
        };
        path = [ pkgs.nix ];
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
          #enableSSHSupport = true;
        };

        nix-index.enable = true;
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

