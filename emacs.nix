/*
To build the project, type the following from the current directory:

$ nix-build emacs.nix

To run the newly compiled executable:

$ ./result/bin/emacs
*/
{ pkgs ? import <nixpkgs> {} }:

let
  myEmacs = pkgs.emacs;
  emacsWithPackages = (pkgs.emacsPackagesNgGen myEmacs).emacsWithPackages;
in
  emacsWithPackages (epkgs:
  (with epkgs.elpaPackages; [
    undo-tree  
    auctex         # ; LaTeX mode
    org
  ]) ++
  (with epkgs.melpaPackages; [
    evil
    evil-magit
    evil-collection
    evil-snipe
    which-key
    async
    ivy
    swiper
    eyebrowse
    counsel
    counsel-projectile
    popup
    flycheck
    org-bullets
    company
    company-anaconda
    company-reftex
    company-auctex
    rust-mode
    racer
    cargo
    anaconda-mode
    nix-mode
    py-yapf
    spaceline
  ]))
