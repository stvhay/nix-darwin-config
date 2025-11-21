pkgs: with pkgs;
{
  script = ''
    printf --  "----------\n%s\n----------\n\n" "$(date)"
    chown -R root:wheel /etc/nix-darwin
    nix-channel --update
    nix flake update --commit-lock-file 
    darwin-rebuild switch --flake .
    chown -R hays:admin /etc/nix-darwin
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
