;;; workspace --- A basic init file

;;; Commentary:

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

(defvar workspace-init-directory (file-name-directory load-file-name)
  "Emacs init file directory.")

(defvar workspace-session-directory (expand-file-name "emacs.d" workspace-init-directory)
  "Emacs session directory.")

(defvar workspace-plugin-directory (expand-file-name "plugins" workspace-init-directory)
  "Emacs session directory.")

(setq package-user-dir workspace-plugin-directory)

(let ((default-directory  workspace-plugin-directory))
  (normal-top-level-add-subdirs-to-load-path))

;; Set initial frame to fullscreen when Emacs starts.
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; Don't show the splash screen
(setq inhibit-startup-message t)

;; Display line numbers in every buffer
(global-display-line-numbers-mode 1)
;; Display column numbers in bottom bar
(column-number-mode t)
;; Highlight matching parenthesis
(show-paren-mode t)

(load-theme 'tango-dark t)

(server-start)

(require 'package)
(setq package-archives
      '(("GNU ELPA"     . "https://elpa.gnu.org/packages/")
        ("MELPA Stable" . "https://stable.melpa.org/packages/")
        ("MELPA"        . "https://melpa.org/packages/"))
      package-archive-priorities
      '(("MELPA Stable" . 10)
        ("GNU ELPA"     . 5)
        ("MELPA"        . 0)))

(use-package flycheck-mypy
  :ensure t)

(use-package flycheck-clangcheck
  :ensure t)

(use-package flycheck-pycheckers
  :ensure t)

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(use-package yaml-mode
  :ensure t)

(use-package markdown-mode
  :ensure t)

(use-package groovy-mode
  :ensure t)

(use-package go-mode
  :ensure t)

(use-package rust-mode
  :ensure t)

(use-package clang-format
  :ensure t)

;; Global
(setq-default indent-tabs-mode nil
              tab-width 4)

(use-package ido
  :ensure t
  :init (ido-mode t))

(use-package undo-tree
  :ensure t
  :init (global-undo-tree-mode))

;; Prevent undo tree files from polluting your git repo
(setq undo-tree-history-directory-alist '(("." . (expand-file-name "undo" workspace-session-directory))))

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(use-package visual-regexp-steroids
  :defer 4
  :bind (("C-c r" . vr/replace)
         ("C-c q" . vr/query-replace)
         ("M-%"   . vr/query-replace)
         ("C-c m" . vr/mc-mark))
  ;;         ("C-r"   . vr/isearch-backward) ;; C-M-r
  ;;         ("C-s"   . vr/isearch-forward)) ;; C-M-s
  :config
  (use-package visual-regexp
    :ensure t
    :config
    (setq vr/match-separator-use-custom-face t)))

(use-package bazel
  :ensure t
  :mode (("\\.bzl\\'" . bazel-starlark-mode)
         ("\\.bazel\\'" . bazel-build-mode)
         ("BUILD\\'" . bazel-build-mode)
         ("WORKSPACE\\'" . bazel-workspace-mode)
         ("bazelrc\\'" . bazelrc-mode)))

(use-package auto-package-update
  :ensure t
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-at-time "03:00"))

(use-package fzf
  :ensure t
  :bind (("C-x t" . fzf)))

(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)


;; helm
(use-package helm
  :ensure t
  :config
  (setq helm-split-window-inside-p t)
  (setq helm-use-frame-when-more-than-two-windows nil)
  (helm-autoresize-mode 1))

(use-package helm-mode
    :config (helm-mode 1))

(use-package helm-command
    :bind (("M-x" . helm-M-x)))

(use-package helm-files
    :bind (("C-x C-f" . helm-find-files)))

(use-package helm-buffers
    :bind (("C-x C-b" . helm-buffers-list)
           ("M-s m" . helm-mini))
    :config (setq helm-buffer-max-length nil))

(use-package helm-occur
    :bind (("M-s o" . helm-occur)))

(use-package helm-imenu
    :bind (("M-s i" . helm-imenu))
    :config (setq imenu-max-item-length 120))

(use-package helm-bookmarks
    :bind (("M-s b" . helm-bookmarks)))

;; helm ends here


;; LSP
(use-package lsp-mode
  :ensure t
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (python-mode . lsp)
         (c-mode . lsp)
         (c++-mode . lsp)
         (rust-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

;; optionally
(use-package lsp-ui :commands lsp-ui-mode)
;; if you are helm user
(use-package helm-lsp :commands helm-lsp-workspace-symbol)

;; optionally if you want to use debugger
;; (use-package dap-mode)
;; (use-package dap-LANGUAGE) to load the dap adapter for your language

;; optional if you want which-key integration
(use-package which-key
    :config
    (which-key-mode))

;; LSP ends here

;;; init.el ends here
