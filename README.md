# NixOS Development Environment

```sh
config='configuration.nix'
repository='mkamsani/CSIT321-FYP-Nix'
sudo cp /etc/nixos/$config /etc/$config.bak
sudo curl -o /etc/nixos/$config https://raw.githubusercontent.com/$repository/main/$config
sudo nixos-rebuild switch
```
