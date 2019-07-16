# packages to be installed

{ config, pkgs, ... }:

let 
	# stable channel fetched 2019/07/16
	stable = fetchGit {
		name = "nixos-stable-19.03-2019-07-16";
		url = git://github.com/NixOS/nixpkgs-channels;
		ref = "nixos-19.03";
		rev = "58b68770692018bbf2bf64ffa10e11610bb749d0";
	};
in {
	nixpkgs = {
		config.allowUnfree = true;

		# override the original package set with the stable set
		config.packageOverrides = oldPkgs: stable;
	};

	environment.systemPackages = with pkgs; [
		#-- system stuff --#
		wget 
		rclone # working with cloud storage
		networkmanager 
		git 
		stow 
		pavucontrol 
		light # controls the backlight
		ripgrep 
		fd
		zip
		unzip
		unrar
		ranger
		tree
		exa # an ls replacement
		nix-index
		htop
		imagemagick
		usbutils
		git-crypt
		gnupg
		#-- programming --#
		vim 
		emacs
		neovim
		(python3.withPackages(ps: with ps; [ numpy matplotlib pynvim pygobject3 ipython pip tkinter scipy palettable pygments pyaudio mypy flake8 yapf pyqt5 pyqtgraph rope ]))
		binutils
		gcc
		gnumake
		openssl
		texlive.combined.scheme-full
		qt5.full
		#-- desktop --#
		sway 
		firefox 
		google-chrome
		gimp 
		blender 
		lxappearance-gtk3
		adapta-gtk-theme
		numix-icon-theme
		godot
		zathura
		dropbox-cli
		mpv
		transmission-gtk
		playerctl # to see what music is playing
		google-play-music-desktop-player
		rclone-browser # qt front-end for rclone
		steam
		steam-run-native
		gzdoom # doom port
		qtcreator
	];
}
