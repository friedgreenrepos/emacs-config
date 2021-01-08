(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(tsdh-dark))
 '(inhibit-startup-screen t)
 '(initial-frame-alist '((fullscreen . maximized)))
 '(package-selected-packages
   '(base16-theme which-key ein use-package flycheck pylint magit web-mode json-mode projectile latex-preview-pane jedi))
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

;; auto close bracket insertion
(electric-pair-mode 1)

;; set zsh as default shell
(setq shell-file-name (executable-find "/usr/bin/zsh"))

;; web-mode.el configuration
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

;; disable tool bar and menu bar
(tool-bar-mode 0)
(menu-bar-mode 0)

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
