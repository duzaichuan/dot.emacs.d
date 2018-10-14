(use-package persistent-scratch
  
  :defer 0.2
  :config
  (persistent-scratch-setup-default))

(use-package tex
  
  :straight auctex
  :mode ("\\.tex\\'" . LaTeX--mode)
  :custom
  (TeX-auto-save t)
  (TeX-parse-self t)
  (font-latex-fontify-script nil)
  (preview-image-type 'imagemagick)
  (reftex-plug-into-AUCTeX t)
  (TeX-PDF-mode nil)
  (reftex-plug-into-AUCTeX t)
  (LaTeX-electric-left-right-brace t)
  (TeX-master nil)
  :config
  (progn
    (fset 'tex-font-lock-suscript 'ignore)
    (require 'smartparens-latex)
    (add-hook 'LaTeX-mode-hook 'flyspell-mode)
    (add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
    (add-hook 'LaTeX-mode-hook 'turn-on-reftex)
    (add-hook 'LaTeX-mode-hook 'turn-on-cdlatex)
    (add-hook 'LaTeX-mode-hook '(lambda () (setq compile-command "latexmk -pdf")))
    (add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer) ))
;; (straight-use-package 'auctex)

(use-package magic-latex-buffer
  
  :hook LaTeX-mode)

(use-package cdlatex
  
  :commands (turn-on-cdlatex cdlatex-mode))

(use-package org

  :straight nil
  :mode ("\\.org\\'" . org-mode)
  :hook ((org-mode . turn-on-org-cdlatex))
  :bind (("C-c l" . org-store-link)
         ("C-c a" . org-agenda)
         ("C-c c" . org-capture)
         ("C-c b" . org-iswitchb)
         ("C-c C-w" . org-refile)
         ("C-c j" . org-clock-goto)
         ("C-c C-x C-o" . org-clock-out))
  :init
  (setq org-directory "~/Dropbox/Org"
	org-default-notes-file (concat org-directory "/notes.org")
	org-agenda-files (list "~/Dropbox/Org")
	org-refile-targets '((org-agenda-files :maxlevel . 3))
	org-capture-templates (quote (("t" "TODO" entry (file+olp+datetree "~/Dropbox/Org/captures.org")
				       "* TODO %?")
				      ("m" "Mail-to-do" entry (file+headline "~/Dropbox/Org/captures.org" "Tasks")
				       "* TODO [#A] %?\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+0d\"))\n%a\n")
				      ("a" "Appointment" entry (file+olp+datetree "~/Dropbox/Org/captures.org")
				       "* %?")
				      ("n" "note" entry (file+headline "~/Dropbox/Org/captures.org" "IDEAS")
				       "* %?\nCaptured on %U\n  %i")
				      ("j" "Journal" entry (file+olp+datetree "~/Dropbox/journal.org")
				       "* %?\nEntered on %U\n  %i")))
	org-tag-alist (quote (("BUDD"    . ?b)
			      ("PHIL"    . ?p)
			      ("ENGL"    . ?e)))
	org-todo-keywords '((sequence "TODO(t)" "STARTED(s)" "WAITING(w)" "|" "DONE(d)" "CANCELED(c)")
			    (sequence "QUESTION(q)" "BUG(b)" "KNOWNCAUSE(k)" "|" "FIXED(f)"))
	org-log-done 'time
	org-refile-use-outline-path 'file
	org-outline-path-complete-in-steps nil
	org-refile-allow-creating-parent-nodes 'confirm)
  :config
  (progn
    (setq org-preview-latex-default-process 'imagemagick
	  org-image-actual-width (/ (display-pixel-width) 2)
	  org-pretty-entities t ; render UTF8 characters
	  org-pretty-entities-include-sub-superscripts nil
	  org-confirm-babel-evaluate nil
	  org-src-fontify-natively t ; syntax highlight in org mode
	  org-highlight-latex-and-related '(latex) ; org-mode buffer latex syntax highlighting
	  org-footnote-auto-adjust t ; renumber footnotes when new ones are inserted
	  org-export-with-smart-quotes t ; export pretty double quotation marks
	  ispell-parser 'tex
	  org-latex-caption-above '(table image)
	  ;; set value of the variable org-latex-pdf-process
	  org-latex-pdf-process
	  '("pdflatex -interaction nonstopmode -output-directory %o %f"
	    "bibtex %b"
	    "pdflatex -interaction nonstopmode -output-directory %o %f"
	    "pdflatex -interaction nonstopmode -output-directory %o %f"))
    (plist-put org-format-latex-options :scale 1.70) ; bigger latex fragment
    (setq-default truncate-lines nil) ; line wrap in org mode
    ;; Quickly insert blocks
    (add-to-list 'org-structure-template-alist '("s" "#+NAME: ?\n#+BEGIN_SRC \n\n#+END_SRC"))
    (add-hook 'org-babel-after-execute-hook 'org-display-inline-images) ; images auto-load
    (require 'smartparens-org)
    (use-package smartparens-Tex-org :straight nil :load-path "lib/") ))

(use-package org-auto-formula
  :straight nil
  :load-path "lib/"
  :after org
  :config
  (add-hook 'post-command-hook 'cw/org-auto-toggle-fragment-display))

(use-package org-download
  
  :hook ((org-mode dired-mode) . org-download-enable))

(use-package org-bullets
  
  :hook (org-mode . org-bullets-mode)
  :custom (org-bullets-bullet-list '("◉" "○" "●" "◆" "♦")))

(use-package org-ref
  
  :bind (("C-c r" . org-ref-helm-insert-cite-link)
	 ("C-c ir" . org-ref-helm-insert-ref-link)
	 ("C-c il" . org-ref-helm-insert-label-link))
  :custom
  (org-ref-bibliography-notes "~/Dropbox/bibliography/Notes.org")
  (org-ref-default-bibliography '("~/Dropbox/bibliography/references.bib"))
  (org-ref-pdf-directory "~/Dropbox/bibliography/bibtex-pdfs/")
  (org-ref-show-broken-links nil)
  (org-ref-default-ref-type "eqref")
  (org-ref-default-citation-link "citet")
  (org-ref-ref-color "Brown")
  (org-ref-label-color "light green")
  :config
  (require 'org-ref-citeproc))

(use-package ox-word
  :straight nil
  :load-path "lib/"
  :after org)

(use-package helm-bibtex
  
  :defer t
  :custom
  (bibtex-completion-bibliography "~/Dropbox/bibliography/references.bib")
  (bibtex-completion-library-path "~/Dropbox/bibliography/bibtex-pdfs")
  (bibtex-completion-notes-path "~/Dropbox/bibliography/Notes.org") )

;; a WYSiWYG HTML mail editor that can be useful for sending tables, fontified source code, and inline images in email. 
(use-package org-mime
  
  :commands (org-mime-htmlize)
  :custom
  (org-mime-up-subtree-heading 'org-back-to-heading)
  (org-mime-export-options '(:section-numbers nil
					      :with-author nil
					      :with-toc nil
					      :with-latex imagemagick)) )

(use-package org-noter
  
  :commands org-noter)

(use-package org-mind-map
  
  :commands org-mind-map-write)

(use-package demo-it
   :defer t)

(use-package org-tree-slide
  
  :commands org-tree-slide-mode
  :custom-face
  (org-tree-slide-header-overlay-face ((t (:foreground "#7F9F7F" :weight bold))))
  :config
  (progn

    (defun du-org-present-big ()
      "Make font size larger."
      (interactive)
      (text-scale-increase 0)
      (text-scale-increase 5)) ;MAKE THIS BUFFER-LOCAL

    (defun du-org-present-small ()
      "Change font size back to original."
      (interactive)
      (text-scale-increase 0))

    (add-hook 'org-tree-slide-play-hook
              (lambda ()
		(du-org-present-big)
		(org-display-inline-images)
		(writeroom--disable)
		(hide-mode-line-mode +1)))

    (add-hook 'org-tree-slide-stop-hook
              (lambda ()
		(du-org-present-small)
		(org-remove-inline-images)
		(writeroom--enable)))
    ))

(use-package org-babel-eval-in-repl
  
  :after ob
  :bind (:map org-mode-map
	      ("C-<return>" . ober-eval-in-repl)
	      ("M-<return>" . ober-eval-block-in-repl)))

(use-package yaml-mode
  
  :mode "\\.yaml\\'")

(use-package markdown-mode
  
  :mode (("\\`README\\.md\\'" . gfm-mode)
         ("\\.md\\'"          . markdown-mode)
         ("\\.markdown\\'"    . markdown-mode))
  :custom
  (markdown-enable-math t)
  (markdown-command "multimarkdown"))

(use-package writeroom-mode
  
  :commands writeroom-mode
  :hook (org-mode markdown-mode LaTeX-mode)
  :bind (:map writeroom-mode-map
	      ("s-?" . nil)
	      ("C-c m" . writeroom-toggle-mode-line))
  :custom
  (writeroom-fullscreen-effect 'maximized)
  (writeroom-bottom-divider-width 0)
  (writeroom-maximize-window nil)
  (writeroom-width 90))

(use-package ispell

  :straight nil
  :commands ispell
  :custom
  (ispell-program-name (executable-find "hunspell"))
  (ispell-choices-win-default-height 5)
  (ispell-dictionary "en_US")
  :config
  (progn
    (setenv "DICTIONARY" "en_US")
    
    (defun endless/org-ispell ()
      "Configure `ispell-skip-region-alist' for `org-mode'."
      (make-local-variable 'ispell-skip-region-alist)
      (add-to-list 'ispell-skip-region-alist '(org-property-drawer-re))
      (add-to-list 'ispell-skip-region-alist '("~" "~"))
      (add-to-list 'ispell-skip-region-alist '("=" "="))
      ;; this next line approximately ignores org-ref-links
      (add-to-list 'ispell-skip-region-alist '("cite:" . "[[:space:]]"))
      (add-to-list 'ispell-skip-region-alist '("citet:" . "[[:space:]]"))
      (add-to-list 'ispell-skip-region-alist '("label:" . "[[:space:]]"))
      (add-to-list 'ispell-skip-region-alist '("ref:" . "[[:space:]]"))
      (add-to-list 'ispell-skip-region-alist '("eqref:" . "[[:space:]]"))
      (add-to-list 'ispell-skip-region-alist '("^#\\+BEGIN_SRC" . "^#\\+END_SRC")))

    (add-hook 'org-mode-hook #'endless/org-ispell)

    ))

(use-package langtool
  
  :commands langtool-check
  :custom
  (langtool-default-language "en-US")
  (langtool-language-tool-jar "/usr/local/Cellar/languagetool/4.1/libexec/languagetool-commandline.jar"))

(use-package pyim
  
  :bind (("M-p" . pyim-convert-code-at-point)
	 ("M-f" . pyim-forward-word)
	 ("M-b" . pyim-backward-word))
  :init
  (progn
    (setq default-input-method "pyim"
	  pyim-default-scheme 'quanpin
	  pyim-page-tooltip 'posframe
	  pyim-page-length 5
	  pyim-dicts
	  '((:name "default" :file "~/pyim-dicts/pyim-bigdict.pyim")
            (:name "eng abbriv" :file "~/pyim-dicts/eng-abbrev.pyim")))
    
    (setq-default pyim-english-input-switch-functions
                '(pyim-probe-dynamic-english
                  ;pyim-probe-isearch-mode
                  pyim-probe-program-mode
                  pyim-probe-org-structure-template))

    (setq-default pyim-punctuation-half-width-functions
                '(pyim-probe-punctuation-line-beginning
                  pyim-probe-punctuation-after-punctuation)) )
  :config
  (use-package pyim-basedict
      :config (pyim-basedict-enable)))

(use-package academic-phrases
  
  :commands (academic-phrases academic-phrases-by-section))

(provide 'init-text-editor)
