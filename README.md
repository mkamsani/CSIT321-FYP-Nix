# NixOS Development Environment

This setup is for the LiveCD GNOME installation.

Open the terminal with Console and enter the following:

```sh
url='https://raw.githubusercontent.com/mkamsani/CSIT321-FYP-Nix/main/configuration.nix'
cd /etc/nixos
sudo cp configuration.nix configuration.nix.bak
sudo curl $url
```

You should see the output of a configuration file. \
Download the file into /etc/nixos directory. \
In the same terminal:

```sh
sudo rm -f configuration.nix
sudo curl -o configuration.nix $url
sudo nixos-rebuild switch
```

NixOS will fetch the required packages, \
and build the system based on the configuration file.

Reboot the system, open the terminal again:

```sh
sudo nix-collect-garbage --delete-old
```

This removes unused packages from the system.
