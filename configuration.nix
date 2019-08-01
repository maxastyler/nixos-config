# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let 
	passwords = import ./secrets/passwords.nix;
	hostname = import ./hostname.nix;
	home-manager = fetchGit {
		url = git://github.com/rycee/home-manager;
		ref = "release-19.03";
		rev = "4f13f06b016d59420cafe34915abdd6b795d3416";
	};
in
{
  imports =
    [ # Include the results of the hardware scan.
      ( ./. + "/${hostname}/hardware-configuration.nix" )
      ./packages.nix
      "${home-manager}/nixos"
    ];
  

  nixpkgs.config.allowUnfree = true;

  # home manager settings
  home-manager.users.max = {
	programs.git = {
		enable = true;
		userName = "Max Tyler";
		userEmail = "maxastyler@gmail.com";
	};

	xdg.configFile."sway/config".source = ./dotfiles/sway/.config/sway/config;
	xdg.configFile."sway/status.sh".source = ./dotfiles/sway/.config/sway/status.sh;
	home.file.".emacs.d/init.el".source = ./dotfiles/emacs/init.el;
	home.file.".emacs.d/config.org".source = ./dotfiles/emacs/config.org;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Update Intel microcode on boot
  hardware.cpu.intel.updateMicrocode = true;

  # enable bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.extraConfig = "
  [General]
  Enable=Source,Sink,Media,Socket
";

  networking.hostName = hostname; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
  	consoleFont = "Lat2-Terminus16";
  	consoleKeyMap = "uk";
  	defaultLocale = "en_GB.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Installing fonts
  fonts.fonts = with pkgs; [
	noto-fonts
	noto-fonts-emoji
	fira-code
	fira-code-symbols
	roboto
  ];

  # Set up tmux
  programs.tmux = {
	enable = true;
	clock24 = true;
	escapeTime = 0;
	keyMode = "vi";
	shortcut = "a";
	terminal = "screen-256color";
	customPaneNavigationAndResize = true;
	reverseSplit = true;
	extraTmuxConf = ''
		bind-key -T copy-mode-vi 'v' send -X begin-selection
		bind-key -T copy-mode-vi 'y' send -X copy-selection-and-cancel
    bind s split-window -c "#{pane_current_path}"
    bind v split-window -h -c "#{pane_current_path}"
	'';
  };


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # enable power configs
  services.upower.enable = true;

  # add in rules to connect to the hydra harp
 # environment.etc = {
 #   "udev/rules.d/HydraHarp400.rules" = {
 #     text = ''
 #       ATTR{idVendor}=="0e0d", ATTR{idProduct}=="0004", MODE="0666"
 #       ATTR{idVendor}=="0e0d", ATTR{idProduct}=="0009", MODE="0666"
 #     '';
 #   };
 # };
 services.udev.extraRules = if hostname == "pokey-monkey" then
 ''
       ATTR{idVendor}=="0e0d", ATTR{idProduct}=="0004", MODE="0666"
       ATTR{idVendor}=="0e0d", ATTR{idProduct}=="0009", MODE="0666"
 ''
 else
 	"";


  # Open ports in the firewall.
  # These ports should allow chromecast through...?
  # networking.firewall.allowedTCPPorts = [ 3000 5556 5558 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # (for google chrome)
  networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;

  hardware.pulseaudio = {
	enable = true;
    	extraModules = [ pkgs.pulseaudio-modules-bt ];
	package = pkgs.pulseaudioFull;
	support32Bit = true; # to run steam stuff
  };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";
 
  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;
 
  # Enable sway
  programs.sway.enable = true;

  # Enable light
  programs.light.enable = true;

  # Enable the emacs daemon
  services.emacs.enable = true;
  services.emacs.package = import ./emacs.nix { pkgs = pkgs; };
  
  # Make users immutable
  users.mutableUsers = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.max = {
    home = "/home/max";
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "video" "sound" "pulse" "networkmanager" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.bash;
    hashedPassword = passwords.max;
  };

  users.users.root.hashedPassword = passwords.root;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?

}
