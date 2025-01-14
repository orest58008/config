;; -*- lexical-binding: t; -*-

                                        ; VISUAL SETTINGS
;; Disable useless bars and startup screen
(scroll-bar-mode -1)
(tool-bar-mode -1)
(setq inhibit-startup-screen t)

;; Display line and column numbers
(column-number-mode)
(use-package emacs
  :hook ((conf-mode
          org-mode
          prog-mode
          text-mode) . display-line-numbers-mode))

;; Set monospace font
(set-frame-font "monospace 12" nil t)

                                        ; EDITING SETTINGS
;; Automatch brackets
(add-hook 'prog-mode-hook 'electric-pair-mode)

;; Indentation
(setq-default indent-tabs-mode nil)
(setq-default tab-width 3)

;; Remove *scratch* buffer
(when (get-buffer "*scratch*") (kill-buffer "*scratch*"))

;; Save between sessions
(desktop-save-mode)

;; Set up text width
(setopt fill-column 99)
(use-package emacs
  :hook ((conf-mode
          org-mode
          prog-mode
          text-mode) . display-fill-column-indicator-mode))

                                        ; PACKAGE SETUP
;; Set up straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Set up use-package
(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

                                        ; PACKAGES
;; centaur tabs
(use-package centaur-tabs
  :after nerd-icons
  :config
  (centaur-tabs-mode)
  (centaur-tabs-enable-buffer-alphabetical-reordering)
  :bind
  ("C-<tab>"   . centaur-tabs-forward)
  ("C-S-<tab>" . centaur-tabs-backward)
  :custom ; tab cycling and reordering
  (centaur-tabs-cycle-scope 'tabs)
  (centaur-tabs-adjust-buffer-order t)
  :custom ; display icons and modified marker
  (centaur-tabs-set-icons t)
  (centaur-tabs-icon-type 'nerd-icons)
  (centaur-tabs-set-modified-marker t)
  (centaur-tabs-modified-marker "~")
  :hook ; disable tabs in dashboard
  ((dashboard-mode
    term-mode) . centaur-tabs-local-mode))

;; corfu
(use-package corfu
  :init (setq-default corfu-auto       t
                      corfu-auto-delay 0.25
                      corfu-popupinfo-delay 0)
  :hook (prog-mode conf-mode)
  :hook
  (corfu-mode . corfu-echo-mode)
  (corfu-mode . corfu-history-mode)
  (corfu-mode . corfu-popupinfo-mode))

;; dashboard
(use-package dashboard
  :after nerd-icons
  :config (dashboard-setup-startup-hook)
  :custom ; banner config
  (dashboard-banner-logo-title nil)
  (dashboard-startup-banner (concat user-emacs-directory "GNUEmacs.png"))
  :custom ; center content vertically and horisontally
  (dashboard-center-content t)
  (dashboard-vertically-center-content t)
  :custom ; display icons
  (dashboard-icon-type 'nerd-icons)
  (dashboard-set-file-icons t)
  (dashboard-set-heading-icons t)
  :custom ; display items
  (dashboard-items '((recents  . 10)
                     (projects . 10)))
  (dashboard-projects-backend 'projectile))

;; editorconfig
(use-package editorconfig
  :config (editorconfig-mode 1))

;; elcord
(use-package elcord
  :config (elcord-mode))

;; evil
(use-package evil
  :bind (:map evil-insert-state-map
              ("C-S-v"   . clipboard-yank))
  :custom (evil-undo-system 'undo-redo))
(evil-mode t)

;; flexoki themes
(use-package flexoki-themes
  :config (load-theme 'flexoki-themes-dark t)
  :custom
  (flexoki-themes-use-bold-builtins t)
  (flexoki-themes-use-bold-keywords t))

;; flycheck
(use-package flycheck
  :hook prog-mode)

;; git gutter
(use-package git-gutter
  :hook prog-mode)

;; hide mode line
(use-package hide-mode-line
  :hook (dashboard-mode
         neotree-mode
         term-mode))

;; ligature
(use-package ligature
  :config (ligature-set-ligatures 'prog-mode '("!=" "!==" "!===" "(*" "*)" "*+" "*-" "*/" "*=" "+*"
                                               "++" "+++" "-*" "-*-" "--" "---" "--->" "-->" "-<"
                                               "-<-" "-<<" "->" "->-" "->>" "-|" ".>" "/*" "/="
                                               "/>" "/\\" "::" ":::" ":=" ":>" "<!--" "<!---" "<*"
                                               "<*>" "<-" "<--" "<---" "<---->" "<--->" "<-->"
                                               "<->" "<." "<.>" "</" "</>" "<:" "<<-" "<<=" "<="
                                               "<==" "<===" "<====>" "<===>" "<==>" "<=>" "<>" "<|"
                                               "<|>" "<~~" "=!=" "=*" "=/=" "=:" "=<" "=<<" "=<="
                                               "==" "===" "===>" "==>" "=>" "=>=" "=>>" ">-" ">="
                                               ">>-" ">>=" "[|" "\\/" "__" "___" "{|" "|-" "|>"
                                               "|]" "|}" "~=" "~~>")) ; Iosevka
  :hook (prog-mode conf-mode))

;; neotree
(use-package neotree
  :after nerd-icons
  :bind (:map evil-normal-state-map
              ("C-t" . neotree-toggle)
              ("RET" . neotree-enter)
              ("SPC" . neotree-quick-look))
  :custom ; projectile support
  (projectile-switch-project-action 'neotree-projectile-action)
  :custom
  (neo-theme 'nerd-icons)
  (neo-window-width 30))

;; nerd icons
(use-package nerd-icons)

;; projectile
(use-package projectile
  :init (projectile-mode t)
  :hook (project-find-functions . project-projectile))

                                        ; LANGUAGES
;; LSP
(use-package lsp-mode
  :custom (lsp-completion-provider :none)                                              ; 
  :init (defun my/lsp-mode-setup-completion ()                                         ;
          (setf (alist-get 'styles (alist-get 'lsp-capf completion-category-defaults)) ; corfu
                '(flex)))                                                              ;
  :hook (lsp-completion-mode . my/lsp-mode-setup-completion)                           ;
  :hook (haskell-mode    ; haskell-language-server
         java-mode       ; jdtls
         python-mode     ; python-lsp-server
         typescript-mode ; deno lsp
         ))

;; Emacs Lisp
(defun disable-prog-modes ()
  "Disable certain modes usually hooked to `prog-mode`."
  (flycheck-mode -1))
(add-hook 'emacs-lisp-mode-hook #'disable-prog-modes)

;; Haskell
(use-package haskell-mode)
(use-package lsp-haskell)

;; Nix
(use-package nix-mode
  :mode "\\.nix\\'")

;; Org
(use-package org-modern
  :hook org-mode)

;; Python
(use-package lsp-pyright
  :custom (lsp-pyright-langserver-command "pyright") ;; or basedpyright
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp))))  ; or lsp-deferred

                                        ; CUSTOM FUNCTIONS
;; VSCode-like pop-up terminal
(defun my/popup-term-below (&optional HEIGHT)
  (interactive)
  (split-window-below)
  (other-window 1)
  (shrink-window (- (window-height) (or HEIGHT 10)))
  (term (getenv "SHELL"))
  (set-process-query-on-exit-flag
   (get-buffer-process (current-buffer)) nil)
  (evil-insert-state))
(evil-define-key '(insert normal) 'global
  (kbd "C-`") 'my/popup-term-below)
(evil-define-key 'insert 'term-mode-map
  (kbd "C-`") 'delete-window)
