# NixOS Development Environment

This setup is for the LiveCD GNOME installation.

Open the terminal with Console and paste the following:

```sh
url='https://raw.githubusercontent.com/mkamsani/CSIT321-FYP-Nix/main/configuration.nix'
sudo cp /etc/nixos/configuration.nix /etc/nixos/configuration.nix.bak
sudo curl -o /etc/nixos/configuration.nix $url
sudo nixos-rebuild switch
```

Reboot the system, open the terminal again:

```sh
sudo nix collect-garbage --delete-old
```
