pkgs: with pkgs;
{
  script = ''
    printf "----------\n%s----------\n" "$(date)"
    ${pkgs.nix}/bin/nix-channel --update
    ${pkgs.nix}/bin/nix flake update --commit-lock-file 
    ${pkgs.nix}/bin/darwin-rebuild switch --flake .
  '';
  serviceConfig = {
    StartInterval = 86400; # every 24 hours
    RunAtLoad = false;
    WorkingDirectory = "/etc/nix-darwin";
    StandardOutPath = "/var/log/nixdarwin-upgrade.log";
    StandardErrorPath = "/var/log/nixdarwin-upgrade-error.log";
    UserName = "root";
  };
  path = [ pkgs.nix pkgs.git pkgs.coreutils pkgs.findutils ];
}
