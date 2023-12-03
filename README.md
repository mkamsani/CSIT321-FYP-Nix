# NixOS Development Environment

This setup is for the LiveCD GNOME installation.

Open the terminal with Console and paste the following:

```sh
config='configuration.nix'
repository='mkamsani/CSIT321-FYP-Nix'
sudo cp /etc/nixos/$config /etc/$config.bak
sudo curl -o /etc/nixos/$config https://raw.githubusercontent.com/$repository/main/$config
sudo nixos-rebuild switch
```

Reboot the system, open the terminal again:

```sh
sudo nix collect-garbage --delete-old
```
