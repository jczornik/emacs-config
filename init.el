;; Define the init file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; Define and initialise package repositories
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; use-package to simplify the config file
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure 't)


;; Keyboard-centric user interface
(setq inhibit-startup-message t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(defalias 'yes-or-no-p 'y-or-n-p)

;; Don't show the splash screen
(setq inhibit-startup-message t)

;; Always disable line numbers
(global-display-line-numbers-mode 1)
(setq display-line-numbers 'relative)

;; Graphical settings
(use-package gruber-darker-theme
  :ensure t)
(load-theme 'gruber-darker t)
(global-hl-line-mode 1)
(set-face-attribute 'default nil :font "Ubuntu Mono-18")


;; Backup directory
(setq backup-directory-alist '(("." . "~/.emacs_saves")))

;; Enable ido
(use-package ido)
(ido-mode t)

;; Enable smax
(use-package smex
  :ensure t)
(global-set-key (kbd "M-x") 'smex)
