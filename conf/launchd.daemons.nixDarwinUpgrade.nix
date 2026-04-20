pkgs: with pkgs;
{
  script = ''
    set -euo pipefail

    printf -- "----------\n%s\n----------\n\n" "$(date)"

    # All git/nix operations run as hays (repo owner)
    run_as_hays() { /usr/bin/sudo -i -u hays -- "$@"; }

    echo "nix channel update..."
    run_as_hays /run/current-system/sw/bin/nix-channel --update 2>&1

    # Update flake inputs and commit lock file
    echo "nix flake update..."
    run_as_hays bash -c 'cd /etc/nix-darwin && /run/current-system/sw/bin/nix flake update --commit-lock-file' 2>&1

    # Build and switch — needs root
    echo "nix rebuild and switch... (pwd=$(pwd) "id=$(id))"
    if /run/current-system/sw/bin/darwin-rebuild switch --flake /etc/nix-darwin 2>&1; then
      printf "\nSUCCESS: darwin-rebuild switch completed\n"
    else
      printf "\nFAILURE: darwin-rebuild switch exited %d\n" "$?"
      exit 1
    fi
    
    # Homebrew
    echo "homebrew update"
    run_as_hays bash --login -c "brew update && brew upgrade" 2>&1
  '';
  serviceConfig = {
    StartCalendarInterval = [{ Hour = 3; Minute = 0; }];
    RunAtLoad = false;
    WorkingDirectory = "/etc/nix-darwin";
    StandardOutPath = "/var/log/nixdarwin-upgrade.log";
    StandardErrorPath = "/var/log/nixdarwin-upgrade-error.log";
    UserName = "root";
  };
  path = [ pkgs.nix pkgs.git pkgs.coreutils pkgs.findutils ];
}
