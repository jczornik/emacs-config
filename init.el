;;; -*- lexical-binding: t; -*-
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; use-package to simplify the config file
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure 't)

(setq custom-file "~/.emacs.d/init.custom")

(setq user-full-name "Janusz Czornik")
(setq user-mail-address "jczornik@graylight-imaging.com")

;; keyboard-centric user interface
(setq inhibit-startup-message t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(defalias 'yes-or-no-p 'y-or-n-p)

(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode)

;; Theme
(add-to-list 'warning-suppress-log-types
             '(files missing-lexbind-cookie))
(use-package gruber-darker-theme
  :ensure t
  :config
  (load-theme 'gruber-darker t))

;; Font
(set-face-attribute 'default nil :font "Ubuntu Mono 18")
(if (daemonp)
  (add-hook 'after-make-frame-functions
            (lambda (frame)
              (set-face-attribute 'default nil :font "Ubuntu Mono 18"))))

;; Default indentation
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
;; (setq indent-line-function 'insert-tab)
(setq c-default-style "linux")
(setq c-basic-offset 4)
(c-set-offset 'comment-intro 0)

(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))

(make-directory "~/.emacs_saves/" t)
(setq backup-directory-alist '(("." . "~/.emacs_saves/")))

(use-package treesit-auto
  :ensure t
  :custom
  ;; Ask before downloading and compiling a missing grammar.
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode 1))

(use-package combobulate
  :ensure nil
  :vc (:url "https://github.com/mickeynp/combobulate"
       :rev :newest)
  :custom
  (combobulate-key-prefix "C-c o")
  :hook (prog-mode . combobulate-mode))

;; Multiple cursors
(use-package multiple-cursors
  :ensure t
  :bind
  (("C-s-c C-s-c" . mc/edit-lines)
   ("C->" . mc/mark-next-like-this)
   ("C-<" . mc/mark-previous-like-this)
   ("C-c C-<" . mc/mark-all-like-this)))

(use-package direnv
  :ensure t
  :config
  (direnv-mode))

(use-package magit
  :ensure t)

(use-package yasnippet
  :ensure t
  :config
  (setq yas-snippet-dirs '("~/.emacs.d/snippets"))
  (yas-global-mode 1))

(use-package go-ts-mode
  :ensure nil  ;; Built into Emacs
  :hook
  (go-ts-mode . (lambda ()
                 (setq-local indent-tabs-mode t)
                 (setq-local tab-width 4)
                 (setq-local go-ts-mode-indent-offset 4))))
