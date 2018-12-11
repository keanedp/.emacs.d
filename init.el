;; change garbage collection threshold to 100MB
(setq gc-cons-threshold 100000000)

;; increase garbage collection threshold while in minibuffer
(defun my-minibuffer-setup-hook ()
  (setq gc-cons-threshold most-positive-fixnum))

(defun my-minibuffer-exit-hook ()
  (setq gc-cons-threshold 800000))

(add-hook 'minibuffer-setup-hook #'my-minibuffer-setup-hook)
(add-hook 'minibuffer-exit-hook #'my-minibuffer-exit-hook)

(setq-default indent-tabs-mode nil)

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
             '("gnu" . "http://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))`

(eval-when-compile
  (require 'use-package))

;; this adds 1s to start time
(use-package exec-path-from-shell
  :ensure t
  :defer t
  :init
  (when (memq window-system '(mac ns))
    ;;(exec-path-from-shell-initialize)
    (exec-path-from-shell-copy-env "PATH")))

;; (use-package evil
;;   :ensure t
;;   :init
;;   (evil-mode 1))

(use-package ido-completing-read+
  :ensure t
  :config
  (ido-mode t)
  (setq ido-enable-flex-matching t)
  (setq ido-use-filename-at-point nil)
  (setq ido-auto-merge-work-directories-length -1)
  (setq ido-use-virtual-buffers t)
  (ido-ubiquitous-mode t)
  (ido-everywhere t))

(use-package smex
  :ensure t
  :config
  (global-set-key (kbd "M-x") 'smex)
  (global-set-key (kbd "M-X") 'smex-major-mode-commands)
  ;; This is your old M-x.
  (global-set-key (kbd "C-c C-c M-x") 'execute-extended-command))

(use-package ripgrep
  :ensure t
  :defer t)

(use-package projectile
  :ensure t
  :config
  (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (define-key projectile-mode-map (kbd "C-p") 'projectile-ripgrep)
  :init
  (projectile-mode))

(use-package recentf
  :config
  (setq recentf-save-file (concat user-emacs-directory ".recentf"))
  (require 'recentf)
  (recentf-mode 1)
  (setq recentf-max-menu-items 40)
  (global-set-key "\C-x\ \C-r" 'recentf-open-files))

(use-package clojure-mode-extra-font-locking
  :ensure t
  :defer t)

(use-package clojure-mode
  :ensure t
  :defer t
  :config
  ;(add-hook 'clojure-mode-hook 'enable-paredit-mode)
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
            (define-clojure-indent (facts 1))
            (rainbow-delimiters-mode))))

(use-package cider
  :ensure t
  :defer t
  :config
  (add-hook 'cider-mode-hook 'eldoc-mode)
  (setq cider-repl-pop-to-buffer-on-connect nil)
  ;;(setq cider-show-error-buffer nil)
  (setq cider-stacktrace-suppressed-errors t)
  ;;(setq cider-show-error-buffer 'only-in-repl)
  (setq cider-auto-select-error-buffer t)
  (setq cider-repl-history-file "~/.emacs.d/cider-history")
  (setq cider-repl-wrap-history t)
  (setq cider-repl-use-pretty-print t)
  ;;(add-hook 'cider-repl-mode-hook 'smartparens-strict-mode)
  (add-to-list 'auto-mode-alist '("\\.edn$" . clojure-mode))
  (add-to-list 'auto-mode-alist '("\\.boot$" . clojure-mode))
  (add-to-list 'auto-mode-alist '("\\.cljs$" . clojurescript-mode))
  (add-to-list 'auto-mode-alist '("\\.clj$" . clojure-mode))
  (add-to-list 'auto-mode-alist '("lein-env" . enh-ruby-mode)))

(use-package company
  :ensure t
  :init
  (global-company-mode))

(use-package company-web
  :defer t
  :ensure t)

;; auto complete html with C-j
(use-package emmet-mode
  :ensure t
  :defer t)

(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (set (make-local-variable 'company-backends) '(company-css company-web-html company-yasnippet company-files)))

(use-package web-mode
  :ensure t
  :defer t
  :config
  (add-to-list 'auto-mode-alist '("\\.ts\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.css?\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.js\\'" . web-mode))
  (setq web-mode-enable-current-column-highlight t)
  (setq web-mode-enable-current-element-highlight t)
  (add-hook 'web-mode-hook  'my-web-mode-hook)
  (add-hook 'web-mode-hook  'emmet-mode) )

(use-package smartparens
  :ensure t
  :config (progn
            (require 'smartparens-config)
            (smartparens-global-mode t)
            ;; highlight matching pairs
            (show-smartparens-global-mode t)
            (add-hook 'clojure-mode-hook 'smartparens-strict-mode)
            (add-hook 'emacs-lisp-mode-hook 'smartparens-strict-mode))
            (define-key smartparens-mode-map (kbd "C-M-f") 'sp-forward-sexp)
            (define-key smartparens-mode-map (kbd "C-M-b") 'sp-backward-sexp)

            (define-key smartparens-mode-map (kbd "C-M-d") 'sp-down-sexp)
            (define-key smartparens-mode-map (kbd "C-M-a") 'sp-backward-down-sexp)
            (define-key smartparens-mode-map (kbd "C-S-d") 'sp-beginning-of-sexp)
            (define-key smartparens-mode-map (kbd "C-S-a") 'sp-end-of-sexp)

            (define-key smartparens-mode-map (kbd "C-M-e") 'sp-up-sexp)
            (define-key smartparens-mode-map (kbd "C-M-u") 'sp-backward-up-sexp)
            (define-key smartparens-mode-map (kbd "C-M-t") 'sp-transpose-sexp)

            (define-key smartparens-mode-map (kbd "C-M-n") 'sp-forward-hybrid-sexp)
            (define-key smartparens-mode-map (kbd "C-M-p") 'sp-backward-hybrid-sexp)

            (define-key smartparens-mode-map (kbd "C-M-k") 'sp-kill-sexp)
            (define-key smartparens-mode-map (kbd "C-M-w") 'sp-copy-sexp)

            (define-key smartparens-mode-map (kbd "M-(") 'sp-wrap-round)
            (define-key smartparens-mode-map (kbd "M-[") 'sp-wrap-square)
            (define-key smartparens-mode-map (kbd "M-{") 'sp-wrap-curly)
            (define-key smartparens-mode-map (kbd "M-<delete>") 'sp-unwrap-sexp)
            (define-key smartparens-mode-map (kbd "M-<backspace>") 'sp-backward-unwrap-sexp)

            (define-key smartparens-mode-map (kbd "C-<right>") 'sp-forward-slurp-sexp)
            (define-key smartparens-mode-map (kbd "C-<left>") 'sp-forward-barf-sexp)
            (define-key smartparens-mode-map (kbd "C-M-<left>") 'sp-backward-slurp-sexp)
            (define-key smartparens-mode-map (kbd "C-M-<right>") 'sp-backward-barf-sexp)

            (define-key smartparens-mode-map (kbd "M-D") 'sp-splice-sexp)
            (define-key smartparens-mode-map (kbd "C-M-<delete>") 'sp-splice-sexp-killing-forward)
            (define-key smartparens-mode-map (kbd "C-M-<backspace>") 'sp-splice-sexp-killing-backward)
            (define-key smartparens-mode-map (kbd "C-S-<backspace>") 'sp-splice-sexp-killing-around)

            (define-key smartparens-mode-map (kbd "C-]") 'sp-select-next-thing-exchange)
            (define-key smartparens-mode-map (kbd "C-<left_bracket>") 'sp-select-previous-thing)
            (define-key smartparens-mode-map (kbd "C-M-]") 'sp-select-next-thing)

            (define-key smartparens-mode-map (kbd "M-F") 'sp-forward-symbol)
            (define-key smartparens-mode-map (kbd "M-B") 'sp-backward-symbol)

            (define-key smartparens-mode-map (kbd "C-\"") 'sp-change-inner)
            (define-key smartparens-mode-map (kbd "M-i") 'sp-change-enclosing))

;; (use-package rainbow-delimiters
;;   :ensure t
;;   :defer t)

;; (use-package parinfer
;;   :ensure t
;;   :defer t
;;   :bind
;;   (:map parinfer-mode-map
;;         ("<tab>" . parinfer-smart-tab:dwim-right)
;;         ("S-<tab>" . parinfer-smart-tab:dwim-left)
;;         ("C-i" . parinfer--reindent-sexp)
;;         ("C-M-i" . parinfer-auto-fix)
;;         ("C-," . parinfer-toggle-mode)
;;         :map parinfer-region-mode-map
;;         ("C-i" . indent-for-tab-command)
;;         ("<tab>" . parinfer-smart-tab:dwim-right)
;;         ("S-<tab>" . parinfer-smart-tab:dwim-left))
;;   :config
;;   (setq parinfer-auto-switch-indent-mode nil)
;;   :init
;;   (progn
;;     (setq parinfer-extensions
;;       '(defaults       ; should be included.
;;          pretty-parens  ; different paren styles for different modes.
;;          ;;evil           ; If you use Evil.
;;          ;;lispy          ; If you use Lispy. With this extension, you should install Lispy and do not enable lispy-mode directly.
;;          ;;paredit        ; Introduce some paredit commands.
;;          smart-tab      ; C-b & C-f jump positions and smart shift with tab & S-tab.
;;          smart-yank))   ; Yank behavior depend on mode.
;;     (add-hook 'clojure-mode-hook #'parinfer-mode)
;;     (add-hook 'emacs-lisp-mode-hook #'parinfer-mode)
;;     (add-hook 'common-lisp-mode-hook #'parinfer-mode)
;;     (add-hook 'scheme-mode-hook #'parinfer-mode)
;;     ;;(add-hook 'cider-repl-mode-hook #'parinfer-mode)
;;     (add-hook 'lisp-mode-hook #'parinfer-mode)))

(use-package which-key
  :ensure t
  :diminish which-key-mode
  :config
  ;;(which-key-setup-side-window-right-bottom)
  (which-key-setup-side-window-bottom)
  (setq which-key-sort-order 'which-key-key-order-alpha)
  (setq which-key-side-window-max-width 0.33)
  (setq which-key-idle-delay 0.05)
  :init
  (which-key-mode))

(use-package org
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.org$" . org-mode)))

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

;; personal customizations
(add-to-list 'load-path "~/.emacs.d/customizations")
(load "ui.el")
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

;; (setq cider-cljs-lein-repl
;;   "(do (require 'figwheel-sidecar.repl-api)
;;        (figwheel-sidecar.repl-api/start-figwheel!)
;;        (figwheel-sidecar.repl-api/cljs-repl))")
