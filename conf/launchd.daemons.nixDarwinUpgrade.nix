pkgs: with pkgs;
{
  script = ''
    printf --  "----------\n%s\n----------\n\n" "$(date)"
    export HOME=/Users/hays
    git config --global --add safe.directory /etc/nix-darwin
    printf "NIX-CHANNEL\n" >&2
    /usr/bin/sudo -u hays /run/current-system/sw/bin/nix-channel --update
    printf "NIX FLAKE UPDATE\n" >&2
    /usr/bin/sudo -u hays /run/current-system/sw/bin/nix flake update --commit-lock-file 
    printf "DARWIN-REBUILD\n" >&2
    /run/current-system/sw/bin/darwin-rebuild switch --flake .
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
