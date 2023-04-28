;; -*- lexical-binding: t; -*-
(setq
 ring-bell-function #'ignore ; turn off the bell
 backup-directory-alist `(("." . ,(expand-file-name "backups" user-emacs-directory))) ; set backup directory to inside the emacs directory
 backup-by-copying t
 delete-old-versions t
 dired-listing-switches "-alh" ;; give human readable sizes in dired listings
 version-control t ; use numbered backups
 completion-in-region-function (lambda (&rest args)
				 (apply (if vertico-mode
					    #'consult-completion-in-region
					  #'completion--in-region)
					args))
 enable-recursive-minibuffers t ; use to run commands inside minibuffers
 tab-always-indent 'complete ; smarter tab completion
 gc-cons-threshold 100000000 ;; larger gc collections
 read-process-output-max (* 1024 1024) ;; 1mb
 indent-tabs-mode nil ;; don't use tabs to indent
 select-enable-clipboard t ;; use the system's clipboard
 doc-view-continuous t ;; scroll over pages in doc mode
 tab-width 4 ;; tab width to 4
 compilation-scroll-output 1 ;; scroll compilation window down to the bottom
 native-comp-deferred-compilation-deny-list '())

(electric-pair-mode)

(blink-cursor-mode 0)

(fset 'yes-or-no-p #'y-or-n-p) ;; make yes or no shorter

;; bootstrap straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

					; add use-package
(straight-use-package 'use-package)

;; use straight, and set use-package to use straight by default
(use-package straight
  :custom (straight-use-package-by-default t))

;; a package to use for completion
(use-package vertico
  :custom (vertico-count 20)
  :config
  (vertico-mode)
  :bind (:map vertico-map
	      ("?" . #'minibuffer-completion-help)
	      ("M-RET" . #'minibuffer-force-complete-and-exit)
	      ("M-TAB" . #'minibuffer-complete)))

;; used by vertico to save  restarts
(use-package savehist
  :init
  (savehist-mode))

;; different completion style
(use-package orderless
  :init
  (setq completion-styles '(orderless basic)
	completion-category-defaults nil
	completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :config
  (marginalia-mode))

(use-package embark
  :bind (("M-." . embark-dwim)
	 ("C-." . embark-act)))

(use-package consult
  :bind (("C-x b" . consult-buffer)))

(use-package embark-consult)

(use-package wgrep)

(use-package tex
  :straight auctex ;; install the package if it's not installed already
  :mode ("\\.tex\\'" . TeX-latex-mode)
  :config
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq TeX-PDF-mode t)
  (setq-default TeX-master nil)
  (setq TeX-source-correlate-start-server 'synctex)
  (setq TeX-view-program-selection '(((output-dvi has-no-display-manager)
                                      "dvi2tty")
                                     ((output-dvi style-pstricks)
                                      "dvips and gv")
                                     (output-dvi "xdvi")
                                     (output-pdf "PDF Tools")
                                     (output-html "xdg-open")))
  :init
  (add-hook 'LaTeX-mode-hook #'my-LaTeX-mode-hooks)
  (add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer)
  (add-to-list 'safe-local-variable-values
               '(TeX-command-extra-options . "-shell-escape"))
  (defun my-LaTeX-mode-hooks ()
    (TeX-source-correlate-mode t)
    (LaTeX-math-mode t)
    (add-hook 'after-save-hook (lambda () (TeX-command-run-all nil)) nil t) ;; save after compilation
    ))

(use-package which-key
  :config
  (which-key-mode t))

(use-package magit)

(use-package lsp-pyright
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp))))  ; or lsp-deferred

(use-package lsp-mode
  :custom (lsp-keymap-prefix "C-;")
  :hook ((typescript-mode . lsp-deferred)
	 (lsp-mode . lsp-enable-which-key-integration)
	 (elixir-mode . lsp))
  :commands (lsp lsp-deferred)
  :init
  (add-to-list 'exec-path "/home/max/.elixir_ls"))

(use-package mix
  :config
  (add-hook 'elixir-mode-hook 'mix-minor-mode))

(use-package typescript-mode
  :mode "\\.tsx\\'"
  :defer t)

(use-package undo-tree
  :config
  (global-undo-tree-mode) ;; start undo-tree
  (setq undo-tree-visualizer-diff t
					; make undo tree backups inside the .emacs folder
        undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo-tree-history/"))))

(use-package python-pytest
  :after python
  :bind (:map python-mode-map
              ("<f6>" . #'python-pytest-popup)))

(use-package dap-mode
  :hook ((dap-stopped-hook . (lambda (arg) (call-interactively #'dap-hydra))))
  :config
  (setq dap-python-debugger 'debugpy))


(use-package python
  :config
  (require 'dap-python))

(use-package blacken
  :hook (python-mode . blacken-mode)
  :init
  (setq-default blacken-fast-unsafe t)
  (setq-default blacken-line-length 80))

(use-package pdf-tools
  :config
  (pdf-tools-install))

(use-package protobuf-mode)

;; (use-package direnv
;;   :config
;;   (direnv-mode t))

(use-package paredit
  :hook
  (scheme-mode . #'enable-paredit-mode))

(use-package geiser-guile)

(use-package envrc
  :config
  (envrc-global-mode))

(use-package all-the-icons
  :if (display-graphic-p))

(use-package vterm
  :bind (("<f5>" . vterm)))

(use-package racket-mode
  :bind (:map racket-mode-map
              ("<f6>" . #'racket-run)))

(use-package rustic
  :hook
  (rust-mode . #'rustic-mode))

(use-package jupyter)

(use-package elixir-mode)

(use-package nix-mode)

(use-package corfu
  ;; Optional customizations
  :custom
  ;; (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  (corfu-auto t)                 ;; Enable auto completion
  ;; (corfu-separator ?\s)          ;; Orderless field separator
  ;; (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
  (corfu-quit-no-match 'separator)      ;; Never quit, even if there is no match
  ;; (corfu-preview-current nil)    ;; Disable current candidate preview
  ;; (corfu-preselect 'prompt)      ;; Preselect the prompt
  ;; (corfu-on-exact-match nil)     ;; Configure handling of exact matches
  ;; (corfu-scroll-margin 5)        ;; Use scroll margin

  ;; Enable Corfu only for certain modes.
  ;; :hook ((prog-mode . corfu-mode)
  ;;        (shell-mode . corfu-mode)
  ;;        (eshell-mode . corfu-mode))

  ;; Recommended: Enable Corfu globally.
  ;; This is recommended since Dabbrev can be used globally (M-/).
  ;; See also `corfu-excluded-modes'.
  :init
  (global-corfu-mode))
