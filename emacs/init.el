;; -*- lexical-binding: t; -*-

                                        ; VISUAL SETTINGS
;; Disable annoying bars
(scroll-bar-mode -1)
(tool-bar-mode -1)

;; Disable startup screen
(setq inhibit-startup-screen t)

;; Display line and column numbers
(column-number-mode)
(add-hook 'org-mode-hook  'display-line-numbers-mode)
(add-hook 'conf-mode-hook 'display-line-numbers-mode)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'text-mode-hook 'display-line-numbers-mode)

;; Set monospace font
(set-frame-font "monospace 12" nil t)

                                        ; EDITING SETTINGS
;; Automatch brackets
(add-hook 'prog-mode-hook 'electric-pair-mode)

;; Disable tabs
(setq-default indent-tabs-mode nil)
(setq-default tab-width 3)

;; Set up spellchecking
(add-hook 'org-mode-hook 'flyspell-mode)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)

;; Set up text width
(setopt fill-column 99)
(add-hook 'org-mode-hook  'display-fill-column-indicator-mode)
(add-hook 'conf-mode-hook 'display-fill-column-indicator-mode)
(add-hook 'prog-mode-hook 'display-fill-column-indicator-mode)
(add-hook 'text-mode-hook 'display-fill-column-indicator-mode)

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
;; corfu
(use-package corfu
  :init
  (setq-default corfu-auto       t
                corfu-auto-delay 0.5
                corfu-popupinfo-delay 0)
  :hook (prog-mode conf-mode)
  :hook (corfu-mode . corfu-popupinfo-mode))

;; dashboard
(use-package dashboard
  :after (projectile)
  :config (dashboard-setup-startup-hook)
  :custom
  (dashboard-banner-logo-title nil)
  (dashboard-center-content t)
  (dashboard-icon-type 'nerd-icons)
  (dashboard-items '((recents  . 15)
                     (projects . 5)
                     (agenda   . 5)))
  (dashboard-projects-backend 'projectile)
  (dashboard-set-heading-icons t)
  (dashboard-set-file-icons t)
  (dashboard-startup-banner (concat user-emacs-directory "GNUEmacs.png")))

;; elcord
(use-package elcord
  :config (elcord-mode))

;; evil
(use-package evil
  :bind (:map evil-normal-state-map
              ("C-<tab>" . other-window)
              ("C-b"     . eval-buffer))
  :bind (:map evil-insert-state-map
              ("C-<tab>" . other-window)
              ("C-S-v"   . clipboard-yank))
  :custom (evil-undo-system 'undo-redo))
(evil-mode t)

;; flexoki-themes
(use-package flexoki-themes
  :config (load-theme 'flexoki-themes-dark t)
  :custom
  (flexoki-themes-use-bold-builtins t)
  (flexoki-themes-use-bold-keywords t))

;; flycheck
(use-package flycheck
  :commands flycheck
  :hook prog-mode)

;; git-gutter
(use-package git-gutter
  :commands git-gutter-mode
  :hook prog-mode)

;; ligature
(use-package ligature
  :commands ligature-mode
  :config (ligature-set-ligatures 'prog-mode '("!=" "!==" "!===" "(*" "*)" "*+" "*/" "*=" "+*" "++"
                                               "+++" "--->" "-->" "-<" "-<-" "-<<" "->" "->-" "->>"
                                               "-|" ".>" "/*" "/=" "/>" "/\\" "::" ":::" ":=" ":>"
                                               "<!--" "<!---" "<*" "<*>" "<-" "<--" "<---" "<---->"
                                               "<--->" "<-->" "<->" "<." "<.>" "</" "</>" "<:"
                                               "<<-" "<<=" "<=" "<==" "<===" "<====>" "<===>"
                                               "<==>" "<=>" "<>" "<|" "<|>" "<~~" "=!=" "=*" "=/="
                                               "=:" "=<" "=<<" "=<=" "==" "===" "===>" "==>" "=>"
                                               "=>=" "=>>" ">-" ">=" ">>-" ">>=" "[|" "\\/" "__"
                                               "{|" "|-" "|>" "|]" "|}" "~=" "~~>" )) ; Iosevka
  :hook (prog-mode conf-mode))

;; neotree
(use-package neotree
  :after (nerd-icons)
  :bind (:map evil-normal-state-map
              ("C-t" . neotree-toggle)
              ("RET" . neotree-enter)
              ("SPC" . neotree-quick-look))
  :custom
  (neo-theme 'nerd-icons)
  (neo-window-width 26))
(use-package nerd-icons)

;; projectile
(use-package projectile
  :custom (projectile-indexing-method 'alien)
  :init (projectile-mode +1))

                                        ; LANGUAGES
;; LSP
(use-package lsp-mode
  :after (projectile)
  :commands lsp
  :custom (lsp-completion-provider :none)                                              ; 
  :init (defun my/lsp-mode-setup-completion ()                                         ;
          (setf (alist-get 'styles (alist-get 'lsp-capf completion-category-defaults)) ; corfu
                '(flex)))                                                              ;
  :hook (lsp-completion-mode . my/lsp-mode-setup-completion)                           ;
  :hook (java-ts-mode       ; jdtls
         python-ts-mode     ; python-lsp-server
         typescript-ts-mode ; deno lsp
         ))

;; Tree-sitter
;;; define tree-sitter languages
(setq major-mode-remap-alist '((java-mode       . java-ts-mode)
                               (python-mode     . python-ts-mode)
                               (typescript-mode . typescript-ts-mode)))

;; Emacs Lisp
;;; disable certain modes
(defun disable-prog-modes ()
  (flycheck-mode -1))
(add-hook 'emacs-lisp-mode-hook #'disable-prog-modes)

;; Org
;;; pretty org
(use-package org-modern
  :hook org-mode)
