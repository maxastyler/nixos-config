{ config, home-manager, pkgs, android-nixpkgs, ... }:
let
  xserverCfg = config.services.xserver;

  defaultPinentryFlavor = if xserverCfg.desktopManager.lxqt.enable
  || xserverCfg.desktopManager.plasma5.enable then
    "qt"
  else if xserverCfg.desktopManager.xfce.enable then
    "gtk2"
  else if xserverCfg.enable || config.programs.sway.enable then
    "gnome3"
  else
    "curses";
  emacs-package = with pkgs;
    (emacsPackagesFor emacsPgtk).emacsWithPackages
    (epkgs: [ epkgs.vterm epkgs.pdf-tools ]);
in {
  imports = [ home-manager.nixosModules.home-manager ];
  home-manager.users.max = {
    home.stateVersion = "22.11";
    home.packages = with pkgs; [
      pass
      (firefox-wayland.override {
        extraNativeMessagingHosts = [ passff-host ];
      })
      # add wine stuff
      android-studio
      ark
      cinnamon.warpinator
      cmake
      gcc
      guile_3_0
      jetbrains.idea-ultimate
      ktorrent
      libvterm
      elixir
      emacs-package
      cachix
      mpv
      nixfmt
      poetry
      pyright
      gnumake
      racket
      ripgrep
      steam-run
      texmacs
      inotify-tools
      wineWowPackages.stable
      winetricks
      texlive.combined.scheme-full
      (android-nixpkgs.sdk.x86_64-linux (sdkPkgs:
        with sdkPkgs; [
          cmdline-tools-latest
          build-tools-32-0-0
          platform-tools
          platforms-android-31
          emulator
        ]))
    ];

    programs = {
      git = {
        enable = true;
        userName = "maxastyler";
        userEmail = "maxastyler@gmail.com";
        signing = {
          signByDefault = true;
          key = "BADA 4787 C833 8A35 DD0B  C203 A5E7 D29D 942F 990E";
        };
      };
      bash = {
        enable = true;
        historyControl = [ "erasedups" ];
        bashrcExtra = builtins.readFile ./vterm_bash;
      };
      direnv = {
        enable = true;
        enableBashIntegration = true;
        nix-direnv.enable = true;
        stdlib = builtins.readFile ./direnvrc;
      };
      gpg = { enable = true; };
    };
    services = {
      emacs = {
        enable = true;
        package = emacs-package;
        defaultEditor = true;
        client.enable = true;
      };
      gpg-agent = {
        enable = true;
        enableSshSupport = true;
        pinentryFlavor = defaultPinentryFlavor;
        sshKeys = [ "3FB4D32DB79704F31D7356358F826B4D2EEF8DD3" ];
      };
    };
  };
}
