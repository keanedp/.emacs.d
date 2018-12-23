;; Launch emacs in fullscreen
(setq initial-frame-alist '((fullscreen . maximized)))
;;(setq initial-frame-alist '((top . 0) (left . 0) (width . 130) (height . 60)))

;; hide welcome screen
(setq inhibit-startup-screen t)

(fset 'yes-or-no-p 'y-or-n-p)

;; Turn off the menu bar at the top of each frame because it's distracting
;;(when (fboundp 'menu-bar-mode)
;;  (menu-bar-mode -1))

;; Turn off tool bar
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))

;; Show line numbers
(global-linum-mode)

(add-to-list 'default-frame-alist
             '(ns-appearance . dark))

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(add-to-list 'load-path "~/.emacs.d/themes")
(load-theme 'doom-city-lights t)

(set-frame-font "Inconsolata")

;; increase font size for better readability
(set-face-attribute 'default nil :height 135 :weight 'light)
;; These settings relate to how emacs interacts with your operating system
(setq ;; makes killing/yanking interact with the clipboard
 x-select-enable-clipboard t

 ;; I'm actually not sure what this does but it's recommended?
 x-select-enable-primary t

 ;; Save clipboard strings into kill ring before replacing them.
 ;; When one selects something in another program to paste it into Emacs,
 ;; but kills something in Emacs before actually pasting it,
 ;; this selection is gone unless this variable is non-nil
 save-interprogram-paste-before-kill t

 ;; Shows all options when running apropos. For more info,
 ;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Apropos.html
 apropos-do-all t

 ;; Mouse yank commands yank at point instead of at click.
 mouse-yank-at-point t)

;; Whether cursor blinks
(blink-cursor-mode t)

;; full path in title bar
(setq-default frame-title-format "%b (%f)")

;; don't pop up font menu
(global-set-key (kbd "s-t") '(lambda () (interactive)))

;; no bell
(setq ring-bell-function 'ignore)
