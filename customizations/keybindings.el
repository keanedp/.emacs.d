(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-x K") 'kill-buffer-and-window)

(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

;; Window switching. (C-x o goes to the next window)
(global-set-key (kbd "C-x O") (lambda ()
                                (interactive)
                                (other-window -1))) ;; back one
