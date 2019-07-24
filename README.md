# My nixos config
## Installation
  * Clone the repo into a folder somewhere
  * Symlink the /configuration.nix file to /etc/nixos/configuration.nix
  * make a /hostname.nix file in this repo folder which just contains a string of the hostname of the machine. For example:
  ```
  "pokey-monkey"
  ```

## Notes
The nixpkgs stable channel is pinned to a specific version, so all my comps have exactly the same stuff.

Uses [home-manager](https://github.com/rycee/home-manager) to manage user dotfiles.

A custom emacs package is made, pre-installed with certain packages (so their versions are pinned). pdf-tools uses epdfinfo, which requires compilation when it's run the first time in emacs. I should look for a way to change this.
