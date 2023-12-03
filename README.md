# NixOS Development Environment

This setup is for the LiveCD GNOME installation.

Open the terminal with Console and enter the following:

```sh
url='https://raw.githubusercontent.com/mkamsani/CSIT321-FYP-Nix/main/configuration.nix'
cd /etc/nixos
sudo cp configuration.nix configuration.nix.bak
sudo curl $url
```

You should see the output of a configuration file.
<br>

Next, we download the file into /etc/nixos directory.
In the same terminal:

```sh
sudo rm -f configuration.nix
sudo curl -o configuration.nix $url
sudo nixos-rebuild switch
```

NixOS will fetch the required packages,
and build the system based on the configuration file.

You might see the following output during the build:

> `trace: warning: optionsDocBook is deprecated since 23.11 and will be removed in 24.05`

This is not caused by the configuration, the warning will disappear in a future update:

https://discourse.nixos.org/t/warning-optionsdocbook-is-deprecated-since-23-11-and-will-be-removed-in-24-05/31353/2

<br>

Reboot the system, open the terminal again:

```sh
sudo nix-collect-garbage --delete-old
```

This removes unused packages from the system.
<br>

To add/remove packages or modify your configuration,
edit the `/etc/nixos/configuration.nix` file.
