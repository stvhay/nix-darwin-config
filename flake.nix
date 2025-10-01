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
      environment.shells = [ pkgs.bash ];
      environment.systemPackages = with pkgs;
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
        uv
        vim
        watch
        wezterm
        wget
        wireguard-tools
        xld
        yq
        zig
        zlib       
      ];
  
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
      };

      # Necessary for recommended use of flakes for managing nix-darwin
      nix.settings.experimental-features = "nix-command flakes";

      programs.bash.enable = true;
      security.pam.services.sudo_local.touchIdAuth = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;
      
      system.startup.chime = false;
      system.defaults = {
        dock.autohide = true;
        finder.AppleShowAllFiles = true;
        finder.AppleShowAllExtensions = true;
        finder.FXPreferredViewStyle = "clmv";
        SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
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
    darwinConfigurations."mbp16" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };
  };
}
