# My nix-darwin configuration

## Nix Instllation

Nix was installed using the recommended script by https://nixos.org/ .

```shell
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)
```

## Nix-Darwin Installation

https://github.com/nix-darwin/nix-darwin

Per the instructions in the README.md file:

```bash
mv /etc/nix/nix.conf{,.before-nix-darwin}
sudo mkdir -p /etc/nix-darwin
sudo chown $(id -nu):$(id -ng) /etc/nix-darwin
(
  cd /etc/nix-darwin
  nix flake init -t nix-darwin/nix-darwin-25.05
  sed -i '' "s/simple/$(scutil --get LocalHostName)/" flake.nix
  sudo nix run nix-darwin/nix-darwin-25.05#darwin-rebuild --extra-experimental-features "nix-command flakes" -- switch
)
```

## Configs

### conf

I've tried to make it so anything I am configuring goes in ```conf/``` as minimally
as practicable.

| file | purpose |
| ---- | ------- |
| environment.systemPackages.nix | nix system packages |
| fonts.packages.nix | nix fonts |
| homebrew.casks.nix | homebrew casks |
| homebrew.masApps.nix | Apple store |
| launchd.daemons.nixDarwinUpgrade.nix | autoupgrade daemon |
| programs.nix | activate/configure various nix features |
| security.nix | apple security settings |
| system.nix | apple system settings |

### utils

| file | purpose |
| ---- | ------- |
| nix-config-edit | script to manage editing and configuration control of config |
| nix-upgrade | system update script |

