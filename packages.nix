# packages to be installed

{ config, pkgs, lib, ... }:

let 
	# stable channel fetched 2019/08/21
	stable = fetchGit {
		name = "nixos-stable-19.03-2019-08-21";
		url = git://github.com/NixOS/nixpkgs-channels;
		ref = "nixos-19.03";
    rev = "94b577411550a31d15dccbc22801325ec5492985";
	};
  # use unstable for certain versions of packages
	# unstable channel fetched 2019/08/21
	unstable = fetchGit {
		name = "nixos-unstable-2019-08-21";
		url = git://github.com/NixOS/nixpkgs-channels;
		ref = "nixos-unstable";
    rev = "1412af4b2cfae71d447164097d960d426e9752c0";
	};
  # overlay fetched 2019/08/10
  moz_overlay = import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/ac8e9d7bbda8fb5e45cae20c5b7e44c52da3ac0c.tar.gz);

  # create an overlay for the qutip python library, because nixpkgs doesn't have an updated version
  qutip_overlay = self: super: {
        python3 = super.python3.override {
            packageOverrides = python-self: python-super: {
            qutip = python-super.qutip.overrideAttrs (oldAttrs: {
                version = "4.4.1";
                src = super.fetchurl {
                    url = "http://qutip.org/downloads/4.4.1/qutip-4.4.1.tar.gz";
                    sha256 = "0224c4x4jzyr2jml66jshm30m1r36bnsf4z04a17wqb9gb3afn9x";
                };
                patchPhase = ''
                export HOME=$NIX_BUILD_TOP
                '';
            });
            };
        };
    };

  blender_overlay = self: super: {
    blender = pkgs.callPackage ./blender/default.nix { };
  };

in {
	nixpkgs = {
		config.allowUnfree = true;

		# override the original package set with the unstable set
		config.packageOverrides = oldPkgs: stable // {
    };

    # add in overlays
    overlays = [ moz_overlay qutip_overlay blender_overlay ];
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
		(python3.withPackages(ps: with ps; [ numpy matplotlib pynvim pygobject3 ipython pip tkinter scipy palettable pygments pyaudio mypy jedi flake8 yapf rope pyqt5 numba jupyter ]))
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
		lxappearance
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
    xournalpp # note taking app with pen support
    gnome3.adwaita-icon-theme
	];
}
