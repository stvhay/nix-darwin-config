pkgs: with pkgs;
{
  script = ''
    printf "----------\n%s----------\n" "$(date)"
    nix-channel  --update
    nix flake update 
    darwin-rebuild switch --flake .
  '';
  serviceConfig = {
    StartInterval = 86400; # every 24 hours
    RunAtLoad = true;
    WorkingDirectory = "/etc/nix-darwin";
    StandardOutPath = "/var/log/nixdarwin-upgrade.log";
    StandardErrorPath = "/var/log/nixdarwin-upgrade-error.log";
    UserName = "root";
  };
  path = [ pkgs.nix pkgs.git pkgs.coreutils pkgs.findutils ];
}
