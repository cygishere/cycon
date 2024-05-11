;; -*- lexical-binding: t; -*-

;; bootstraping for straight
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://radian-software.github.io/straight.el/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Basic settings
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package emacs
  :bind (
	 ("C-c c" . compile)
	 ("C-h C-m" . man)
	 :map minibuffer-mode-map
	 ("TAB" . minibuffer-complete)
	 )
  :custom
  (inhibit-splash-screen t)  ;; Turn off the welcome screen
  (initial-scratch-message nil)
  (initial-major-mode 'fundamental-mode)  ; default mode for the *scratch* buffer
  (display-time-default-load-average nil) ; this information is useless for most

  (backup-directory-alist `((".*" . ,temporary-file-directory)))
  (auto-save-file-name-transforms`((".*" ,temporary-file-directory t)))

  ;; Automatically reread from disk if the underlying file changes
  (auto-revert-interval 1)
  (auto-revert-check-vc-info t)
  ;; Fix archaic defaults
  (sentence-end-double-space nil)
  ;; C-n will add newlines when at line end
  (next-line-add-newlines t)

  (fill-column 80)  ; Set width for automatic line breaks
  (help-window-select t)  ; Focus new help windows when opened
  ;; Mode line information
  (line-number-mode t)                        ; Show current line in modeline
  (column-number-mode t)                      ; Show column as well

  (x-underline-at-descent-line nil)           ; Prettier underlines
  (switch-to-buffer-obey-display-actions t)   ; Make switching buffers more consistent
;; Enable horizontal scrolling
  (mouse-wheel-tilt-scroll t)
  (mouse-wheel-flip-direction t)
  (calendar-date-style 'iso)
  
  :config
  (global-auto-revert-mode)

  ;; Save history of minibuffer
  (savehist-mode)

  ;; Move through windows with Ctrl-<arrow keys>
  (windmove-default-keybindings 'control) ; You can use other modifiers here

  ;; Make right-click do something sensible
  (when (display-graphic-p)
    (context-menu-mode))
  
  ;; Disable scroll bar
  (scroll-bar-mode -1)
  
  (setq-default show-trailing-whitespace nil)      ; By default, don't underline trailing spaces
  (setq-default indicate-buffer-boundaries 'left)  ; Show buffer top and bottom in the margin
  
  ;; Misc. UI tweaks
  (blink-cursor-mode -1)                                ; Steady cursor
  (pixel-scroll-precision-mode)                         ; Smooth scrolling
  (display-time-mode t)
  (tool-bar-mode -1)
  (menu-bar-mode -1)

  ;; Don't use common keystrokes by default
  (cua-mode -1)

  ;; Nice line wrapping when working with text
  (add-hook 'text-mode-hook 'visual-line-mode)

  )

;; org
(use-package org
  :straight t
  :bind (
	 ("C-c a" . org-agenda)
	 ("C-c n x" . org-store-link)
	 :map org-mode-map
	 ("C-," . cyg/prev-file)
	 ("C-'" . cyg/next-file)
	 )
  :custom
  (org-agenda-files '("~/org" "~/org/agenda" "~/org/notes" "~/org/roam" "~/org/roam/daily"))
  (org-startup-with-inline-images t)
  (org-edit-src-content-indentation 0)
  )

;; allow drag & drop images into org mode
(use-package org-download
  :straight t
  :bind (
	 ("C-c n y" . org-download-clipboard)
	 )
  :config
  (setq-default org-download-image-dir "~/.config/emacs/res/pics")
  )

(use-package display-line-numbers
  :custom
  (display-line-numbers-widen t)
  :hook
  ((prog-mode conf-mode) . display-line-numbers-mode)
  )

(use-package doom-themes
  :straight t
  :config
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-one t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  ;;(doom-themes-neotree-config)
  ;; or for treemacs users
  ;;(setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  ;;(doom-themes-treemacs-config)
  ;; Corrects (and improves) org-moe's native fontification.
  (doom-themes-org-config)
 )

;; Don't litter file system with *~ backup files; put them all inside
;; ~/.emacs-backup or wherever
(defun bedrock--backup-file-name (fpath)
 "Return a new file path of a given file path.
If the new path's directories does not exist, create them."
 (let* ((backupRootDir "~/.emacs-backup/")
        (filePath (replace-regexp-in-string "[A-Za-z]:" "" fpath )) ; remove Windows driver letter in path
        (backupFilePath (replace-regexp-in-string "//" "/" (concat backupRootDir filePath "~") )))
   (make-directory (file-name-directory backupFilePath) (file-name-directory backupFilePath))
   backupFilePath))
(setq make-backup-file-name-function 'bedrock--backup-file-name)

;; Chinese font
(use-package cnfonts
  :straight t
  :config
  (cnfonts-mode 1)
  )

(use-package diminish
  :straight t
  )

(use-package selected
  :straight t
  :diminish
  :config
  (selected-global-mode)
  :bind (:map selected-keymap
         ("q" . selected-off)
         ("u" . upcase-region)
         ("d" . downcase-region)
         ("w" . count-words-region)
         ("m" . apply-macro-to-region-lines))
  )

(use-package emojify
  :straight t
  :diminish
  :custom
  (emojify-emoji-styles '(ascii unicode))
  :hook
  (after-init . global-emojify-mode)
  )

(use-package dired
  :defer
  :hook
  (dired-mode . dired-omit-mode)
  :custom
  (dired-auto-revert-buffer t)
  )

(use-package all-the-icons-dired
  :straight t
  :diminish
  :if (display-graphic-p)
  :hook (dired-mode . all-the-icons-dired-mode)
  )

(use-package dired-single
  :straight t
  :diminish
  :after dired
  :bind (:map dired-mode-map
              ([remap dired-find-file] . dired-single-buffer)
              ([remap dired-up-directory] . dired-single-up-directory)
	      )
  )

(use-package dired-subtree
  :straight t
  :diminish
  :after dired
  :bind (:map dired-mode-map
              ("<tab>" . dired-subtree-toggle))
  )

(use-package beacon
  :straight t
  :diminish
  :config
  (setq beacon-push-mark 35)
  (setq beacon-color "#d65d0e")
  (beacon-mode t)
  )

(use-package abbrev
  :diminish
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Discovery aids
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Show the help buffer after startup
;;(add-hook 'after-init-hook 'help-quick)

;; which-key: shows a popup of available keybindings when typing a long key
;; sequence (e.g. C-x ...)
(use-package which-key
  :straight t
  :diminish
  :custom
  (which-key-show-early-on-C-h t)
  (which-key-idle-delay most-positive-fixnum)
  (which-key-idle-secondary-delay 1e-9)
  :config
  (which-key-mode)
  )

;; C-h C-h shadows which-key with something less useful
(use-package help
  :config
  (dolist (key (where-is-internal 'help-for-help))
    (unbind-key key))
  )

(use-package rainbow-mode
  :straight t
  :diminish
  :hook
  (prog-mode . rainbow-mode)
  )

(use-package rainbow-delimiters
  :straight t
  :diminish
  :hook
  (prog-mode . rainbow-delimiters-mode)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Minibuffer/completion settings
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; For help, see: https://www.masteringemacs.org/article/understanding-minibuffer-completion

;; (setq enable-recursive-minibuffers t)                ; Use the minibuffer whilst in the minibuffer
;; (setq completion-cycle-threshold 1)                  ; TAB cycles candidates
;; (setq completions-detailed t)                        ; Show annotations
;; (setq tab-always-indent 'complete)                   ; When I hit TAB, try to complete, otherwise, indent
;; (setq completion-styles '(basic initials substring)) ; Different styles to match input to candidates

;; (setq completion-auto-help 'always)                  ; Open completion always; `lazy' another option
;; (setq completions-max-height 20)                     ; This is arbitrary
;; (setq completions-detailed t)
;; (setq completions-format 'one-column)
;; (setq completions-group t)
;; (setq completion-auto-select 'second-tab)            ; Much more eager
					;(setq completion-auto-select t)                     ; See `C-h v completion-auto-select' for more possible values

;; For a fancier built-in completion option, try ido-mode or fido-mode. See also
;; the file extras/base.el
					;(fido-vertical-mode)
					;(setq icomplete-delay-completions-threshold 4000)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Interface enhancements/defaults
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; We won't set these, but they're good to know about
;;
;; (setq-default indent-tabs-mode nil)
;; (setq-default tab-width 4)

;; Workspaces
(use-package perspective
  :straight t
  :custom
  (persp-mode-prefix-key (kbd "C-c p"))
  :init
  (persp-mode)
  )

;; Git enhance
(use-package magit
  :straight t
  :defer t
  )

;; Modes to highlight the current line with
;;(let ((hl-line-hooks '(text-mode-hook prog-mode-hook)))
;;  (mapc (lambda (hook) (add-hook hook 'hl-line-mode)) hl-line-hooks))
(use-package hl-line
  :hook
  (on-first-buffer . global-hl-line-mode)
  )

(use-package ibuffer
  :bind ("C-x C-b" . ibuffer)
  )

(use-package move-text
  :straight t
  :bind
  ("M-p" . move-text-up)
  ("M-n" . move-text-down)
  :config (move-text-default-bindings)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Programming
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package ledger-mode
  :straight t
  )

;; Snippets
(use-package yasnippet
  :straight t
  :diminish
  :bind (("C-c s" . yas-insert-snippet))
  :config
  (add-to-list 'load-path "~/.config/emacs/snippets")
  (yas-global-mode t)
  )

(use-package devdocs
  :straight t
  :diminish
  :bind
  ("C-h D" . devdocs-lookup)
  :custom
  (devdocs-window-select t)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   C programming
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package eldoc
  :diminish
  )

(use-package projectile
  :straight t
  :diminish
  :config
  (projectile-global-mode)
  (define-key projectile-mode-map (kbd "C-c j") 'projectile-command-map)
  )

(use-package consult-projectile
  :after (consult projectile)
  :straight (consult-projectile :type git :host gitlab :repo
                                "OlMon/consult-projectile" :branch "master")
  :commands (consult-projectile)
  )

(use-package git-modes
  :defer t
  :straight t
  )

;; Disable Flymake-mode when using Eglot
;; (use-package eglot
;;   :defer t
;;   :hook (c-mode . eglot-ensure)
;;   :init
;;   (add-hook 'eglot--managed-mode-hook (lambda ()
;; 					(flymake-mode -1)))
;;   :config
;;   (setq eglot-ignored-server-capabilities '(:inlayHintProvider))
;;   )

(use-package cc-mode
  :hook(
	(c-mode . format-all-mode)
	(c-mode . (lambda ()
		    (keymap-unset c-mode-map "C-c C-c")
		    (keymap-set c-mode-map "C-c C-c" 'comment-or-uncomment-region)
		    ))
	)
  )

(use-package cmake-mode
  :straight t
  )

;; Formatter
(use-package format-all
  :straight t
  :diminish
  :hook
  (format-all-mode . (lambda ()
		       (setq format-all-formatters
			     '(("C" (clang-format "--fallback-style=GNU"))))))
  )

(use-package sqlformat
  :straight t
  :diminish
  :config
  (setq sqlformat-command 'pgformatter)
  (setq sqlformat-args '("-s2" "-w80" "-k" "-f2" "-U2" "-p\\\$\\(.*?\\)"))
  (add-hook 'sql-mode-hook 'sqlformat-on-save-mode)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   LSP
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; The path to lsp-mode needs to be added to load-path as well as the
;; path to the `clients' subdirectory.
(add-to-list 'load-path (expand-file-name "lib/lsp-mode" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "lib/lsp-mode/clients" user-emacs-directory))

(use-package lsp-mode
  :straight t
  :hook
  (c-mode . lsp-deferred)
  (python-mode . lsp-deferred)
  (lsp-mode . lsp-enable-which-key-integration)
  :commands (lsp lsp-deferred)
  :custom
  (lsp-ui-sideline-enable nil)
  (lsp-modeline-code-actions-enable nil)
  (lsp-diagnostics-provider :none)
  (lsp-headerline-breadcrumb-enable-diagnostics nil)
  (lsp-keymap-prefix "C-;")
  (lsp-clients-clangd-args '("--background-index" "--fallback-style=GNU" "--header-insertion=never"))
  )

(use-package lsp-ui
  :straight t
  :diminish
  :hook (lsp-mode . lsp-ui-mode)
  )

(use-package company
  :straight t
  :diminish
  :hook
  (after-init . global-company-mode)
  :custom
  (company-idle-delay 0)
  (company-selection-wrap-around t)
  (company-minimum-prefix-length 1)
  :bind (
	 :map company-active-map
	      ("<return>" . nil)
	      ("RET" . nil)
	      ("C-SPC" . company-complete-selection)
	 )
  )

(use-package vertico
  :straight t
  :init
  (vertico-mode)
  :custom
  (vertico-cycle t)
  )

(use-package marginalia
  :straight t
  :after vertico
  :init (marginalia-mode)
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  )

;; (use-package all-the-icons
;;   :straight t
;;   )

(use-package all-the-icons-completion
  :straight t
  :after (marginalia all-the-icons)
  :hook (marginalia-mode . all-the-icons-completion-marginalia-setup)
  )

(use-package orderless
  :straight t
  :custom
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles . (partial-completion)))))
  (completion-styles '(orderless))
  )

(use-package consult
  :after projectile
  :bind  (;; Related to the control commands.
          ("<help> a" . consult-apropos)
          ("C-x b" . consult-buffer)
          ("C-x M-:" . consult-complex-command)
          ("C-c k" . consult-kmacro)
          ;; Related to the navigation.
          ("M-g a" . consult-org-agenda)
          ("M-g e" . consult-error)
          ("M-g g" . consult-goto-line)
          ("M-g h" . consult-org-heading)
          ("M-g i" . consult-imenu)
          ("M-g k" . consult-global-mark)
          ("C-s" . consult-line)
          ("M-g m" . consult-mark)
          ("M-g o" . consult-outline)
          ("M-g I" . consult-project-imenu)
          ;; Related to the search and selection.
          ("M-s G" . consult-git-grep)
          ("M-s g" . consult-grep)
          ("M-s k" . consult-keep-lines)
          ("M-s l" . consult-locate)
          ("M-s m" . consult-multi-occur)
          ("M-s r" . consult-ripgrep)
          ("M-s u" . consult-focus-lines)
          ("M-s f" . consult-find))
  :custom
  (completion-in-region-function #'consult-completion-in-region)
  (consult-narrow-key "<")
  (consult-project-root-function #'projectile-project-root)
  ;; Provides consistent display for both `consult-register' and the register
  ;; preview when editing registers.
  (register-preview-delay 0)
  (register-preview-function #'consult-register-preview)
  )

(use-package treemacs
  :straight t
  :defer t
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t d"   . treemacs-select-directory)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag))
  )

(use-package lsp-treemacs
  :straight t
  :commands lsp-treemacs-errors-list
  )

(use-package treemacs-projectile
  :after (treemacs projectile)
  :straight t
  :diminish
  )

(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once)
  :straight t
  )

(use-package treemacs-magit
  :after (treemacs magit)
  :straight t
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   lua programming
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Lua mode
(use-package lua-mode
  :straight t
  :bind (:map lua-mode-map
	      ("C-c r" . lua-send-region)
	      ("C-c f" . lua-send-defun))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Note taking
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Don't ask for confirm when eval code block
(defun cyg/org-confirm-babel-evaluate (lang body)
  (let ((lang-list '("sh" "python")))
    (not (member lang lang-list))
    )
  )




;; Literate programming
;; Some org-babel languages need org-contrib
;; org-contrib site: http://elpa.nongnu.org/nongnu/org-contrib.html
(use-package org-contrib
  :straight t
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((C . t) ;; https://orgmode.org/worg/org-contrib/babel/languages/ob-doc-C.html
     (python . t) ;; https://orgmode.org/worg/org-contrib/babel/languages/ob-doc-python.html
     (ledger . t) ;; https://orgmode.org/worg/org-contrib/babel/languages/ob-doc-ledger.html
     (shell . t) ;; https://orgmode.org/worg/org-contrib/babel/languages/ob-doc-shell.html
     ))
  (setq org-confirm-babel-evaluate #'cyg/org-confirm-babel-evaluate)
)


;; org-roam
(use-package org-roam
  :straight t
  :diminish
;;  :after org
  :custom
  (org-roam-directory (file-truename "~/org/roam"))
  :bind
  (("C-c n l" . org-roam-buffer-toggle)
   ("C-c n f" . org-roam-node-find)
   ("C-c n g" . org-roam-graph)
   ("C-c n i" . org-roam-node-insert)
   ("C-c n c" . org-roam-capture)
   ;; Dailies
   ("C-c n j" . org-roam-dailies-capture-today)
   ("C-c n d" . org-roam-dailies-goto-date)
   ("C-c n t" . org-roam-dailies-goto-today))
  :config
  (org-roam-db-autosync-mode)
  )

(use-package org-modern
  :straight t
  :diminish
  :after org
  :custom
  (org-modern-hide-stars nil)
  (org-modern-table nil)
  (org-modern-block-name '("" . ""))
  (org-modern-timestamp nil)
  :hook 
  (org-mode . org-modern-mode)
  (org-agenda-finalize . org-modern-mode)
  )

(use-package org-indent-mode
  :diminish
  :after org
  :hook
  (org-mode . org-indent-mode)
  )

(use-package org-modern-indent
  :straight (org-modern-indent :type git :host github :repo "jdtsmith/org-modern-indent")
  :diminish
  :after (org org-modern org-indent-mode)
  :config ; add late to hook
  (add-hook 'org-mode-hook #'org-modern-indent-mode 90)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Tab-bar configuration
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Show the tab-bar as soon as tab-bar functions are invoked
(setq tab-bar-show 0)

;; Add the time to the tab-bar, if visible
(add-to-list 'tab-bar-format 'tab-bar-format-align-right 'append)
(add-to-list 'tab-bar-format 'tab-bar-format-global 'append)
(setq display-time-format "%a %F %T")
(setq display-time-interval 1)
(display-time-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Optional extras
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package gnugo
  :straight t
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   cyg functions
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun cyg/next-file ()
  "Open the next file in the same directory."
  (interactive)
  (let ((current-file (buffer-file-name)))
    (if current-file
        (progn
          (setq current-file-nodir (file-name-nondirectory current-file))
          (setq files-list (directory-files (file-name-directory current-file) nil "^[^.#].*\\'"))
          (setq next-file (cadr (member current-file-nodir files-list)))
          (if next-file
              (find-file next-file)
            (message "No next file in the directory.")))
      (message "Not visiting a file buffer."))))

(defun cyg/prev-file ()
  "Open the previous file in the same directory."
  (interactive)
  (let ((current-file (buffer-file-name)))
    (if current-file
        (progn
          (setq current-file-nodir (file-name-nondirectory current-file))
          (setq files-list (directory-files (file-name-directory current-file) nil "^[^.#].*\\'"))
	  (setq current-file-pos (cl-position current-file-nodir files-list :test 'equal))
          (setq prev-file (nth (- current-file-pos 1) files-list))
          (if prev-file
              (find-file prev-file)
            (message "No prev file in the directory.")))
      (message "Not visiting a file buffer."))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Built-in customization framework
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
