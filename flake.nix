{
  inputs = {
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs.url = "github:NixOS/nixpkgs";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs-stable.follows = "nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = {nixpkgs, nixpkgs-unstable, home-manager, emacs-overlay
    , nixos-hardware, ... }: {
      nixosConfigurations.speedy-monkey = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          pkgs-unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
          inherit emacs-overlay;
        };
        modules = [
          ./configuration.nix
          nixos-hardware.nixosModules.lenovo-thinkpad-z13-gen2
        ];
      };
    };
}
