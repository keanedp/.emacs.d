;; anything related to files or the file system

(setq create-lockfiles nil)

;; revert buffers when file changes on the filesystem
(global-auto-revert-mode t)

(setq projectile-enable-caching t)

;; store all backup and autosave files in the tmp dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

