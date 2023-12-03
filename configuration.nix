# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];
  
  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Singapore";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_SG.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_SG.UTF-8";
    LC_IDENTIFICATION = "en_SG.UTF-8";
    LC_MEASUREMENT = "en_SG.UTF-8";
    LC_MONETARY = "en_SG.UTF-8";
    LC_NAME = "en_SG.UTF-8";
    LC_NUMERIC = "en_SG.UTF-8";
    LC_PAPER = "en_SG.UTF-8";
    LC_TELEPHONE = "en_SG.UTF-8";
    LC_TIME = "en_SG.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = (with pkgs; [
    gnome-console # terminal
    gnome-photos
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    atomix # puzzle game
    cheese # webcam tool
    epiphany # web browser
    evince # document viewer
    geary # email reader
    gedit # text editor
    gnome-calculator
    gnome-characters
    gnome-clocks
    gnome-contacts
    gnome-maps
    gnome-music
    gnome-weather
    hitori # sudoku game
    iagno # go game
    simple-scan
    tali # poker game
    totem # video player
  ]);

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.user = { config, pkgs, ... }: {
    home.stateVersion = "23.11"; # The state version is required and should stay at the version you originally installed.
    home.packages = [ pkgs.atool pkgs.httpie ];
    home.shellAliases = {
      ls="ls -AF --color=auto";
      recent="ls -ltch";
      grep="grep --color=auto";
      cp="cp -iv";
      mv="mv -iv";
      rm="rm -iv";
      rmdir="rmdir -v";
      ln="ln -v";
      chmod="chmod -c";
      chown="chown -c";
      update="sudo nixos-rebuild switch";
    };
    
    programs.bash.enable = true;
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      enableVteIntegration = true;
      historySubstringSearch.enable = true;
      # enableAutosuggestions = true; # Based on history.
      # syntaxHighlighting.enable = true; # Can highlight syntax errors.
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
        theme = "dst";
      };
      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          src = /home/user;
          file = ".p10k.zsh";
        }
      ];
    };

    programs.git.enable = true;
    programs.git.extraConfig = {
      core.editor = "hx";
      log.decorate = "full";
      pull.rebase = true;
      rebase.autostash = true;
      stash.showPatch = true;
      "color \"status\"" = {
        added = "178";
        changed = "178";
        untracked = "39";
      };
    };

    # -------------------------------------------------------------------------

    programs.gnome-terminal = {
      enable = true;
      showMenubar = false;
      profile = {
        "00000000-0000-0000-0000-000000000000" = {
          default = true;
          visibleName = "Home Manager";
          cursorShape = "block";
          font = "MesloLGS Nerd Font 11"; # https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k
          showScrollbar = false;
          transparencyPercent = 20;
          colors = {
            backgroundColor = "#000000";
            foregroundColor = "#ffffff";
            palette = [
              "#000000"
              "#aa0000"
              "#00aa00"
              "#aa5500"
              "#0000aa"
              "#aa00aa"
              "#00aaaa"
              "#aaaaaa"
              "#555555"
              "#ff5555"
              "#55ff55"
              "#ffff55"
              "#5555ff"
              "#ff55ff"
              "#55ffff"
              "#ffffff"
            ];
          };
        };
      };
    };
    # -------------------------------------------------------------------------

    programs.helix = {
      enable = true;
      defaultEditor = true;
      settings = {
        theme = "dark_plus";
        keys.normal = {
          "{" = "goto_prev_paragraph";
          "}" = "goto_next_paragraph";
          "X" = "extend_line_above";
          "esc" = ["collapse_selection" "keep_primary_selection"];
          space.space = "file_picker";
          space.u = {
            f = ":format"; # format using LSP formatter
            w = ":set whitespace.render all";
            W = ":set whitespace.render none";
          };
        };
        keys.select = {
          "%" = "match_brackets";
        };
        editor = {
          color-modes = true;
          cursorline = true;
          mouse = false;
          idle-timeout = 1;
          line-number = "relative";
          scrolloff = 5;
          rulers = [80];
          soft-wrap.enable = true;
          indent-guides = {
            render = true;
          };
          lsp = {
            display-messages = true;
            display-inlay-hints = true;
          };
          gutters = ["diagnostics" "line-numbers" "spacer" "diff"];
          statusline = {
            # mode-separator = "";
            # separator = "";
            left = ["mode" "selections" "spinner" "file-name" "total-line-numbers"];
            center = [];
            right = ["diagnostics" "file-encoding" "file-line-ending" "file-type" "position-percentage" "position"];
            mode = {
              normal = "NORMAL";
              insert = "INSERT";
              select = "SELECT";
            };
          };
          whitespace.characters = {
            space = "·";
            nbsp = "⍽";
            tab = "→";
            newline = "⤶";
          };
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "block";
          };
        };
      };
      languages = {
        language = [
          {
            name = "bash";
            auto-format = true;
            formatter = {
              command = "${pkgs.shfmt}/bin/shfmt";
              args = ["-i" "2" "-"];
            };
          }
          {
            name = "html";
            file-types = ["html"];
          }
        ];
        language-server = {
          bash-language-server = {
            command = "${pkgs.nodePackages.bash-language-server}/bin/bash-language-server";
            args = ["start"];
          };
          vscode-css-language-server = {
            command = "${pkgs.nodePackages.vscode-css-languageserver-bin}/bin/css-languageserver";
            args = ["--stdio"];
          };
        };
      };
    };
    # -------------------------------------------------------------------------
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.user = {
    isNormalUser = true;
    description = "FYP-23-S4-10";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      # Web Browsers
      chromium
      firefox
      # Markdown/PDF/Web Tools
      goldendict-ng
      masterpdfeditor4
      mermaid-cli
      metadata-cleaner
      pandoc
      # Video Tools
      obs-studio
      # CLI Clipboard Tools
      wl-clipboard
      # Rice
      gnome.gnome-tweaks
      nerdfonts
      # IDE
      (vscode-with-extensions.override {
        vscodeExtensions = with vscode-extensions; [
          editorconfig.editorconfig
          donjayamanne.githistory
          github.copilot
          github.copilot-chat
          github.vscode-pull-request-github
          jnoortheen.nix-ide
          redhat.vscode-yaml
          bierner.markdown-mermaid
          esbenp.prettier-vscode
          dbaeumer.vscode-eslint
          ms-python.python
          ms-python.vscode-pylance
          ms-vscode.cpptools
          ms-vscode.makefile-tools
          vscode-icons-team.vscode-icons
          astro-build.astro-vscode
          jebbs.plantuml
        ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "hyperledger-fabric-debugger";
            publisher = "spydra";
            version = "0.1.3";
            sha256 = "8da29f5cbdbe0463d7fa06f116a7508f7fbf8d113c446b27a2a60373af607582";
          }
        ];
      })
    ];
  };

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "user";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (_: true);
  environment.sessionVariables.NIXPKGS_ALLOW_UNFREE= "1";
  # VM services for clipboard sharing.
  services.spice-vdagentd.enable = true;
  services.qemuGuest.enable = true;
  virtualisation.virtualbox.guest.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  # Docker
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
  users.extraGroups.docker.members = [ "user" ];

  # Enable shared folder.
  # virtualisation.virtualbox.host.enable = true;
  # nixpkgs.config.virtualbox.host.enableExtensionPack = true;
  # fileSystems."/virtualboxshare" = {
  #   fsType = "vboxsf";
  #   device = "vboxsf";
  #   options = [ "rw" "nofail" ];
  # };
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Core
    wget
    hyperledger-fabric
    # Virtual Machine Support
    spice-vdagent
    linuxKernel.packages.linux_zen.virtualboxGuestAdditions
    # Languages
    go
    jdk21
    nodejs_20
    python3
    rustc
    # C/C++
    cosmocc
    gnumake
    libgcc
    # Deployment
    docker
    docker-compose
    # CLI Tools
    fzf
    jq
    ugrep
    # Windows Binaries
    bottles
    # LSP
    nodePackages.bash-language-server
    nodePackages.vscode-css-languageserver-bin
    nodePackages.vscode-langservers-extracted
    nodePackages.prettier
    black
    shellcheck
    shfmt
  ];

  # Enable experimental features.
  nix.settings.experimental-features = "nix-command flakes";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
