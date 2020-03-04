;; Change garbage collection threshold to 100MB
(setq gc-cons-threshold 100000000)

(defun minibuffer-setup-hook ()
  (setq gc-cons-threshold most-positive-fixnum))

;; increase garbage collection threshold while in minibuffer
(defun minibuffer-exit-hook ()
  (setq gc-cons-threshold 800000))

(add-hook 'minibuffer-setup-hook #'minibuffer-setup-hook)
(add-hook 'minibuffer-exit-hook #'minibuffer-exit-hook)

(setq-default indent-tabs-mode nil)

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
             '("gnu" . "http://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)

;; version 27 is calling package-initialize by default as of 12/17/2018
;; see for details: https://github.com/jkitchin/scimax/issues/194
(if (version<= emacs-version "27")
  (package-initialize))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))`

(eval-when-compile
  (require 'use-package))

;; (use-package benchmark-init
;;   :ensure t
;;   :config
;;   ;; To disable collection of benchmark data after init is done.
;;   (add-hook 'after-init-hook 'benchmark-init/deactivate))

;; set env when launched as gui app
(use-package exec-path-from-shell
  :ensure t
  :defer t
  :init
  (when (memq window-system '(mac ns))
    (message "execing env!")
    (setq exec-path-from-shell-arguments nil)
    (exec-path-from-shell-initialize)))

(setq default-directory "~/")

(use-package ido-completing-read+
  :ensure t
  :config
  (ido-mode 1)
  (setq ido-enable-flex-matching 1)
  (setq ido-use-filename-at-point nil)
  (setq ido-auto-merge-work-directories-length -1)
  (setq ido-use-virtual-buffers 1)
  (ido-ubiquitous-mode 1)
  (ido-everywhere 1))

(use-package smex
  :ensure t
  :bind (("M-x" . 'smex)
         ("M-X" . 'smex-major-mode-commands)
         ("C-c C-c M-x" . 'execute-extended-command)))

(use-package ripgrep
  :ensure t
  :defer t)

(use-package projectile
  :ensure t
  :bind (("C-c p" . 'projectile-command-map)
         ("C-p" . 'projectile-ripgrep))
  :init (projectile-mode))

(use-package recentf
  :ensure t
  :config
  (setq recentf-save-file (concat user-emacs-directory ".recentf"))
  (recentf-mode 1)
  (setq recentf-max-menu-items 40)
  :bind ("C-x C-r" . 'recentf-open-files))

(use-package clojure-mode-extra-font-locking
  :ensure t
  :defer t)

(use-package rainbow-delimiters
  :ensure t
  :defer t
  :hook ((clojure-mode emacs-lisp-mode lisp-mode) . rainbow-delimiters-mode))

(use-package paredit
  :ensure t
  :hook ((emacs-lisp-mode lisp-interaction-mode ielm-mode lisp-mode eval-expression-minibuffer-setup clojure-mode) . paredit-mode))

(use-package clojure-mode
  :ensure t
  :mode "\\.\\(edn\\|clj\\|cljs\\)\\'"
  :config
  (add-hook 'clojure-mode-hook 'subword-mode)
  (require 'clojure-mode-extra-font-locking)
  (add-hook 'clojure-mode-hook
            (lambda ()
              (setq inferior-lisp-program "lein repl")
              (font-lock-add-keywords
               nil
               '(("(\\(facts?\\)"
                  (1 font-lock-keyword-face))
                 ("(\\(background?\\)"
                  (1 font-lock-keyword-face))))
              (define-clojure-indent (fact 1))
              (define-clojure-indent (facts 1)))))

(use-package cider
  :ensure t
  :defer t
  :config
  (add-hook 'cider-mode-hook 'eldoc-mode)
  (setq cider-repl-pop-to-buffer-on-connect nil)
  (setq cider-stacktrace-suppressed-errors t)
  (setq cider-default-cljs-repl 'figwheel)
  (setq cider-auto-select-error-buffer t)
  (setq cider-repl-history-file "~/.emacs.d/cider-history")
  (setq cider-repl-wrap-history t)
  (setq cider-repl-use-pretty-print t))

(use-package company
  :ensure t
  :config
  (setq company-dabbrev-downcase 0)
  (setq company-idle-delay 0.2)
  :init
  (global-company-mode))

(use-package company-web
  :defer t
  :ensure t)

(use-package ruby-mode
  :ensure t
  :mode "\\.rb\\'"
  :mode "Rakefile\\'"
  :mode "Gemfile\\'"
  :mode "Berksfile\\'"
  :mode "Vagrantfile\\'"
  :interpreter "ruby")

;; auto complete html with C-j
(use-package emmet-mode
  :ensure t
  :defer t)

(defun web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (set (make-local-variable 'company-backends) '(company-css company-web-html company-yasnippet company-files)))

(use-package web-mode
  :ensure t
  :mode "\\.\\(ts\\|html?\\|css?\\|js\\|erb\\)\\'"
  :config
  (setq web-mode-enable-current-column-highlight t)
  (setq web-mode-enable-current-element-highlight t)
  :hook (emmet-mode company-web))

(use-package which-key
  :ensure t
  :diminish which-key-mode
  :config
  (which-key-setup-side-window-bottom)
  (setq which-key-sort-order 'which-key-key-order-alpha)
  (setq which-key-side-window-max-width 0.33)
  (setq which-key-idle-delay 0.05)
  :init
  (which-key-mode))

(use-package org
  :ensure t
  :mode "\\.org$\\'")

(use-package markdown-mode
  :ensure t
  :defer t)

(use-package sublime-themes
  :ensure t
  :defer t)

(use-package spacemacs-theme
  :ensure t
  :defer t)

(use-package doom-themes
  :ensure t
  :defer t)

(use-package oceanic-theme
  :ensure t
  :defer t)

(use-package ibuffer-vc
  :ensure t
  :config
  (add-hook 'ibuffer-hook
          (lambda ()
            (message "ibuffer-hook called!")
            (ibuffer-vc-set-filter-groups-by-vc-root)
            (unless (eq ibuffer-sorting-mode 'alphabetic)
              (ibuffer-do-sort-by-alphabetic))))
              (setq ibuffer-formats
                  '((mark (name 18 18 :left :elide)
                          " "
                          (mode 16 16 :left :elide)
                          " "
                          (vc-status 16 16 :left)
                          " "
                          filename-and-process))))

(use-package slime-company
  :ensure t
  :defer t)

(use-package slime
  :ensure t
  :defer t
  :init
  (setq inferior-lisp-program "/usr/local/bin/clisp")
  (setq slime-contribs '(slime-fancy slime-company)))

(use-package groovy-mode
  :ensure t
  :defer t)

(use-package elixir-mode
  :ensure t
  :mode "\\.\\(ex\\|exs\\)\\'")

;; personal customizations
(add-to-list 'load-path "~/.emacs.d/customizations")
(load "ui.el")
(load "ido.el")
(load "keybindings.el")
(load "files.el")

(defun perform-sql-connect (product connection)
  ;; remember to set the sql-product, otherwise, it will fail for the first time
  ;; you call the function
  (setq sql-product product)
  (sql-connect connection))

(setq sql-connections-file (expand-file-name "sql-connections.el" (concat user-emacs-directory "config")))
(load sql-connections-file 'noerror)

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror)

