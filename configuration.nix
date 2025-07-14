# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, emacs-overlay, pkgs-unstable, ... }: {
  imports = [ # Include the results of the hardware scan.
    ./hosts/speedy-monkey/hardware-configuration.nix
    ./android-godot.nix
  ];

  nixpkgs.overlays = [
    (import ./gnome-keyring-ssh-agent-disable-overlay.nix)
    emacs-overlay.overlays.default
  ];

  # services.postgresql = {
  #   enable = true;
  #   ensureDatabases = [ "splitters" ];
  #   enableTCPIP = true;
  #   port = 5432;
  #   authentication = pkgs.lib.mkOverride 10 ''
  #   #...
  #   #type database DBuser origin-address auth-method
  #   # ipv4
  #   host  all      all     127.0.0.1/32   trust
  #   # ipv6
  #   host all       all     ::1/128        trust
  # '';
  # };

  # containers = { splitter = import ./containers/splitter.nix; };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # So restarting doesn't hang
  # boot.kernelParams = [ "reboot=bios" ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "gb";
    xkb.variant = "";
  };

  # Configure console keymap
  console.keyMap = "uk";

  # Enable CUPS to print documents.
  # use hplipWithPlugin for hp printer
  services.printing = {
    enable = true;
    drivers = [ pkgs.hplipWithPlugin ];
  };

  # Enable sound with pipewire.
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

  # android development
  programs.adb.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.max = {
    isNormalUser = true;
    description = "Max Tyler";
    extraGroups = [ "networkmanager" "wheel" "dialout" "plugdev" "adbusers" ];
    packages = with pkgs; [
      (firefox.override { nativeMessagingHosts = [ passff-host ]; })
      android-studio
      pass
      nixfmt-classic
      nil
      # pkgs-unstable.godot_4
      gimp
      blender
      steam-run
      poetry
      pyright
      #  thunderbird
    ];
  };

  # add steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall =
      true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall =
      true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall =
      true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  # add a udev rule for plugdev

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", \
        ATTRS{idVendor}=="2e8a", \
        ATTRS{idProduct}=="0003", \
        TAG+="uaccess" \
        MODE="660", \
        GROUP="dialout"
    SUBSYSTEM=="usb", \
        ATTRS{idVendor}=="2e8a", \
        ATTRS{idProduct}=="0009", \
        TAG+="uaccess" \
        MODE="660", \
        GROUP="dialout"
    SUBSYSTEM=="usb", \
        ATTRS{idVendor}=="2e8a", \
        ATTRS{idProduct}=="000a", \
        TAG+="uaccess" \
        MODE="660", \
        GROUP="dialout"
    SUBSYSTEM=="usb", \
        ATTRS{idVendor}=="2e8a", \
        ATTRS{idProduct}=="000f", \
        TAG+="uaccess" \
        MODE="660", \
        GROUP="dialout"
  '';

  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "probe_rs_rules";
      text = (builtins.readFile ./probe_rs_udev_rules);
      destination = "/etc/udev/rules.d/69-probe-rs.rules";
    })
  ];

  # Use nix-ld to run binaries
  # see here: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/programs/nix-ld.nix

  programs.direnv.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [ gnome-tweaks git wget vim ];

  services.emacs = {
    package = ((pkgs.emacsPackagesFor pkgs.emacs-unstable).emacsWithPackages
      (epkgs: [ epkgs.vterm epkgs.treesit-grammars.with-all-grammars ]));
    enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

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
