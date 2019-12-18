/*
To build the project, type the following from the current directory:

$ nix-build emacs.nix

To run the newly compiled executable:

$ ./result/bin/emacs
*/
{ pkgs ? import <nixpkgs> {} }:

let
  myEmacs = pkgs.emacs;
  emacsWithPackages = (pkgs.emacsPackagesGen myEmacs).emacsWithPackages;
in
  emacsWithPackages (epkgs:
  (with epkgs.elpaPackages; [
    undo-tree  
    auctex         # ; LaTeX mode
    org
  ]) ++
  (with epkgs.melpaPackages; [
    anaconda-mode
    async
    cargo
    cider
    clojure-mode
    company
    company-anaconda
    company-auctex
    company-lsp
    company-reftex
    counsel
    counsel-projectile
    doom-modeline
    dracula-theme
    evil
    evil-collection
    evil-magit
    evil-snipe
    eyebrowse
    flycheck
    helm-swoop
    ivy
    ivy-bibtex
    lispy
    lsp-mode
    lsp-ui
    nix-mode
    org-bullets
    org-ref
    popup
    py-yapf
    racer
    rainbow-delimiters
    ripgrep
    rust-mode
    rustic
    spaceline
    swiper
    which-key
    winum
    yasnippet
    yasnippet-snippets
  ]))
