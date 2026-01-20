{
  description = "nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      nix.settings.experimental-features = [ "nix-command" "flakes" ];
      nixpkgs.config = import ./conf/nixpkgs.config.nix { lib = pkgs.lib; };
      nixpkgs.hostPlatform = "aarch64-darwin";
      
      environment = {
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
        casks   = import ./conf/homebrew.casks.nix ;
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

