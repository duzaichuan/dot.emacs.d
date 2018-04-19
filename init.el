;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want (setq  initial-frame-alist (quote ((fullscreen . maximized))))it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

(package-initialize)
(add-to-list 'load-path "~/.emacs.d/lisp/")

(require 'init-ui)
(require 'init-packages)
(require 'init-better-defaults)
(require 'init-keybindings)
(require 'init-org)
(require 'init-Tex)
(require 'smartparens-Tex-org)
(setq custom-file (expand-file-name "lisp/custom.el" user-emacs-directory))
(load-file custom-file)

;; dynare .mod file
(require 'dynare)
;; load ob-julia
(load "ob-julia")
