(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(tsdh-dark))
 '(custom-safe-themes
   '("3de3f36a398d2c8a4796360bfce1fa515292e9f76b655bb9a377289a6a80a132" default))
 '(inhibit-startup-screen t)
 '(initial-frame-alist '((fullscreen . maximized)))
 '(package-selected-packages
   '(org-fragtog org-download auctex base16-theme which-key ein use-package flycheck pylint magit web-mode json-mode projectile latex-preview-pane jedi))
 '(show-paren-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq user-full-name "Giulia Calanca"
      user-mail-address "giuliacalanca13@gmail.com"
      calendar-latitude 44.78
      calendar-longitude 10.88
      calendar-location-name "Carpi (MO), Italy")

;; Set default font
(set-frame-font "Hack-11" nil t)

;; Melpa configuration
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

;; Jedi configuration for python
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)      ; optional
(setq jedi:setup-keys t)           ;; attiva le shortcut di default

(add-hook 'python-mode-hook
      (lambda ()
        (setq indent-tabs-mode nil)
        (setq python-indent 4)
        (setq tab-width 4))
      (untabify (point-min) (point-max)))

;; enable Elpy by default
;;(package-initialize)
;;(elpy-enable)

;; latex-preview-pane to load automatically with your LaTeX files
(latex-preview-pane-enable)

;; simple copy line function bound to C-C C-k
(defun copy-line (arg)
  "Copy lines (as many as prefix argument) in the kill ring"
  (interactive "p")
  (kill-ring-save (line-beginning-position)
                  (line-beginning-position (+ 1 arg)))
  (message "%d line%s copied" arg (if (= 1 arg) "" "s")))

(global-set-key "\C-c\C-k" 'copy-line)

;;;;;;;;;;; beginning of duplicate line remapping ;;;;;;;;;;;
;; Remap C-d to duplicate a line instead of deleting a character
(defun duplicate-line (arg)
  "Duplicate current line, leaving point in lower line."
  (interactive "*p")

  ;; save the point for undo
  (setq buffer-undo-list (cons (point) buffer-undo-list))

  ;; local variables for start and end of line
  (let ((bol (save-excursion (beginning-of-line) (point)))
        eol)
    (save-excursion

      ;; don't use forward-line for this, because you would have
      ;; to check whether you are at the end of the buffer
      (end-of-line)
      (setq eol (point))

      ;; store the line and disable the recording of undo information
      (let ((line (buffer-substring bol eol))
            (buffer-undo-list t)
            (count arg))
        ;; insert the line arg times
        (while (> count 0)
          (newline)         ;; because there is no newline in 'line'
          (insert line)
          (setq count (1- count)))
        )

      ;; create the undo information
      (setq buffer-undo-list (cons (cons eol (point)) buffer-undo-list)))
    ) ; end-of-let

  ;; put the point in the lowest line and return
  (next-line arg))

(global-set-key (kbd "C-d") 'duplicate-line)
;;;;;;;;;;; end of duplicate line remapping ;;;;;;;;;;;

;; bind C-v to yank (overwrites default)
(global-set-key (kbd "C-v") 'yank)

;; auto close bracket insertion
(electric-pair-mode 1)

;; disable <> auto pairing
(setq electric-pair-inhibit-predicate
      `(lambda (c)
         (if (char-equal c ?\<) t (,electric-pair-inhibit-predicate c))))

;; set zsh as default shell
(setq shell-file-name (executable-find "/usr/bin/zsh"))

;; web-mode.el configuration
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

;; disable tool, menu and scroll bar
(tool-bar-mode 0)
(menu-bar-mode 0)
(toggle-scroll-bar 0)

;; use fancy lambdas
;;(global-prettify-symbols-mode t)

;; softly highlight the current line
(global-hl-line-mode 1)

;; move cursor by camelCase
;; 1 for on, 0 for off
(global-subword-mode 1)

;; emacs ipython notebook configuration
(require 'ein)

;; Source: http://www.emacswiki.org/emacs-en/download/misc-cmds.el
(defun revert-buffer-no-confirm ()
    "Revert buffer without confirmation."
    (interactive)
    (revert-buffer :ignore-auto :noconfirm))

;; y/n over yes/no
(fset 'yes-or-no-p 'y-or-n-p)

;; auto update buffers
(global-auto-revert-mode t)

;; add recent files key-binding
(recentf-mode 1)
(setq recentf-max-menu-items 25)
(global-set-key (kbd "C-x C-r") 'recentf-open-files)

;; Delete selected region automatically when typing
(delete-selection-mode 1)

;; setup flycheck using use-package
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;; soft-wrap lines
(global-visual-line-mode 1)

;; which-key is a useful UI panel that appears when you start pressing any key binding in Emacs to offer you all possible completions for the prefix
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1))

;; Remove trailing whitespace from the entire buffer while saving
(add-hook 'before-save-hook 'delete-trailing-whitespace)


;; move lines up and down (bound to M-up, M-down)
(defun move-line-up ()
  "Move up the current line."
  (interactive)
  (transpose-lines 1)
  (forward-line -2)
  (indent-according-to-mode))

(defun move-line-down ()
  "Move down the current line."
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1)
  (indent-according-to-mode))

(global-set-key (kbd "M-<up>") 'move-line-up)
(global-set-key (kbd "M-<down>") 'move-line-down)

;;;;;;;;;;;;;;;;;;; ORG MODE config ;;;;;;;;;;;;;;;;;;;

;; I like to see an outline of pretty bullets instead of a list of asterisks
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

;; I like seeing a little downward-pointing arrow instead of the usual ellipsis
;; that org displays when there’s stuff under a header.
(setq org-ellipsis "⤵")

(setq org-hide-emphasis-markers t)

;; Use syntax highlighting in source blocks while editing.
(setq org-src-fontify-natively t)

;; Bind a few handy keys
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cc" 'org-capture)

;; Enable key bindings for structural blocks
;; such as ‘#+BEGIN_SRC’ … ‘#+END_SRC’
(require 'org-tempo)

;; Enable evaluation source blocks
(org-babel-do-load-languages
 'org-babel-load-languages
 '((ruby . t)
   (python . t)))

;; Org-mode uses org-file-apps to decide how to open a file,
;; this snippet overrides how Org-mode opens files.
(setq org-file-apps
    (quote
      ((auto-mode . emacs)
       ("\\.mm\\'" . default)
       ("\\.x?html?\\'" . "/usr/bin/firefox %s")
       ("\\.pdf\\'" . default))))

;; Org-drill flashcards
(require 'org-drill)

;; Org-downlad: this extension facilitates moving images
;; from point A to point B.
(use-package org-download
  :ensure t
  :config
  ;; add support to dired
  (add-hook 'dired-mode-hook 'org-download-enable))

;; org-fragtog: Automatically toggle Org mode LaTeX fragment previews
;; as the cursor enters and exits them
(use-package org-fragtog
  :ensure t
  :config
  (add-hook 'org-mode-hook 'org-fragtog-mode))

(setq org-image-actual-width nil)
