;; Add custom configs
(add-to-list 'load-path "~/.emacs.d/custom/")

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
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode)

;; Remove trailing whitespace
(add-hook 'write-file-hooks 'delete-trailing-whitespace)

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

(use-package gitlab-ci-mode
  :ensure t)

(use-package magit
  :ensure t)

(use-package vterm
  :ensure t)

(use-package dir-treeview
  :ensure t)

;; Window manager in emacs
(use-package exwm
  :ensure t
  :config (require 'exwm-my-config))

;; Python
(use-package elpy
  :ensure t
  :init (elpy-enable))

;; Powershell
(use-package powershell
  :ensure t)


;; TypeScript
(use-package typescript-mode
  :ensure t)

(use-package tide
  :ensure t)
  ;; :after (typescript-mode company flycheck)
  ;; :hook ((typescript-mode . tide-setup)
  ;;        (typescript-mode . tide-hl-identifier-mode)
  ;;        (before-save . tide-format-before-save)))

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

;; formats the buffer before saving
(add-hook 'before-save-hook 'tide-format-before-save)

;; if you use typescript-mode
(add-hook 'typescript-mode-hook #'setup-tide-mode)
