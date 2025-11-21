pkgs: with pkgs;
{
  script = ''
    printf --  "----------\n%s\n----------\n\n" "$(date)"
    chown -R root:wheel /etc/nix-darwin
    /usr/bin/sudo -u hays /run/current-system/sw/bin/nix-channel --update 2>&1
    /usr/bin/sudo -u hays /run/current-system/sw/bin/nix flake update --commit-lock-file 2>&1
    /run/current-system/sw/bin/darwin-rebuild switch --flake . 2>&1
    chown -R hays:admin /etc/nix-darwin
    /usr/bin/sudo -i -u hays bash --login -c "brew upgrade" 2>&1
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
