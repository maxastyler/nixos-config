{
  inputs = {
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, emacs-overlay, nixos-hardware, ...
    }@inputs: {
      nixosConfigurations.speedy-monkey = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          ./configuration.nix
          nixos-hardware.nixosModules.lenovo-thinkpad-z13-gen2
        ];
      };
    };
}
