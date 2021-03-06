;; deleted  active region with backspace or inserting text
(delete-selection-mode t)

(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-x K") 'kill-buffer-and-window)

(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

;; Window switching. (C-x o goes to the next window)
(global-set-key (kbd "C-x O") (lambda ()
                                (interactive)
                                (other-window -1))) ;; back one

(global-set-key (kbd "<backspace>")
                '(lambda () (interactive) (backward-delete-char-untabify 1 nil)))
