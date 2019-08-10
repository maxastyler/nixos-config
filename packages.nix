# packages to be installed

{ config, pkgs, lib, ... }:

let 
	# stable channel fetched 2019/08/10
	stable = fetchGit {
		name = "nixos-stable-19.03-2019-08-10";
		url = git://github.com/NixOS/nixpkgs-channels;
		ref = "nixos-19.03";
    rev = "56d94c8c69f8cac518027d191e2f8de678b56088";
	};
  # overlay fetched 2019/08/10
  moz_overlay = import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/ac8e9d7bbda8fb5e45cae20c5b7e44c52da3ac0c.tar.gz);
in {
	nixpkgs = {
		config.allowUnfree = true;

		# override the original package set with the stable set
		config.packageOverrides = oldPkgs: stable;

    # add in overlays
    overlays = [ moz_overlay ];
	};

	environment.systemPackages = let
                             myRust = ((pkgs.rustChannelOf { date = "2019-08-10"; channel = "nightly"; }).rust.override {
    extensions = [
               "rust-src"
               "rustfmt-preview"
];
}); in
  with pkgs; [
		#-- system stuff --#
		wget 
		rclone # working with cloud storage
		networkmanager 
		git 
		stow 
		pavucontrol 
		light # controls the backlight
		ripgrep 
		pdfgrep # search through pdf documents
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
	 	poppler
		libpng
		fzf
		#-- programming --#
		vim 
		neovim
		(python3.withPackages(ps: with ps; [ numpy matplotlib pynvim pygobject3 ipython pip tkinter scipy palettable pygments pyaudio mypy jedi flake8 yapf pyqt5 pyqtgraph rope numba ]))
		pydb # python debugger
		binutils
		gcc
		gnumake
		openssl
		texlive.combined.scheme-full
		qt5.full
		#-- desktop --#
    		myRust
		alacritty
		sway 
		mako # notifications for wayland
		grim # taka screenshots in wayland
		slurp # select a region in wayland
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
		gzdoom # doom port
		sxiv # image viewer
		qtcreator
	];
}
