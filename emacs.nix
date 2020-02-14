/* To build the project, type the following from the current directory:

   $ nix-build emacs.nix

   To run the newly compiled executable:

   $ ./result/bin/emacs
*/
{ pkgs ? import <nixpkgs> { } }:

pkgs.emacsGit
# let
#   myEmacs = pkgs.emacsGit;
#   emacsWithPackages = (pkgs.emacsPackagesGen myEmacs).emacsWithPackages;
# in
#   emacsWithPackages (epkgs:
#   (with epkgs.elpaPackages; [
#     undo-tree  
#     auctex         # ; LaTeX mode
#     org
#   ]) ++
#   (with epkgs.melpaPackages; [
#     async
#     cargo
#     cider
#     clojure-mode
#     company
#     company-anaconda
#     company-auctex
#     company-reftex
#     counsel
#     counsel-projectile
#     doom-modeline
#     dracula-theme
#     evil
#     evil-collection
#     evil-magit
#     evil-snipe
#     elpy
#     eyebrowse
#     flycheck
#     helm-swoop
#     ivy
#     ivy-bibtex
#     lispy
#     nix-mode
#     org-bullets
#     org-ref
#     popup
#     py-yapf
#     racer
#     rainbow-delimiters
#     ripgrep
#     rust-mode
#     rustic
#     spaceline
#     swiper
#     which-key
#     winum
#     yasnippet
#     yasnippet-snippets
#   ]))
