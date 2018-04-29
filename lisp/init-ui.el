;; appearance setting
(add-to-list 'default-frame-alist '(fullscreen . maximized))
;;(add-to-list 'default-frame-alist '(height . 40))
;;(add-to-list 'default-frame-alist '(width . 85))

;; font
(set-face-attribute 'default nil
		    :font "DejaVu Sans Mono")

(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-linum-mode 1)
(set-face-attribute 'default nil :height 170)
(setq inhibit-startup-screen t)
(setq-default cursor-type 'bar)
(global-hl-line-mode t)

(require 'all-the-icons)

(add-hook 'after-init-hook 'global-color-identifiers-mode)

(provide 'init-ui)
