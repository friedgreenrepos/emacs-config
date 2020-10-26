# emacs-config
My custom emacs config and packages.
## Instructions
1. Configure melpa 
```
;; Melpa configuration
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
```
- Start emacs full-screen following [the wiki](https://www.emacswiki.org/emacs/FullScreen)
- Install **jedi** for emacs following [these instructions](https://tkf.github.io/emacs-jedi/latest/)
- Install **latex-preview-pane**. Read [the wiki](https://www.emacswiki.org/emacs/LaTeXPreviewPane) for more info.
- Install **auctex**, read [the wiki](https://www.emacswiki.org/emacs/AUCTeX) for more info.
- Install **projectile**, read [the wiki]()
- Remap C-d to duplicate a line
```
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
;; end of duplicate line remapping
```
## Optional (currently not installed):
- Download and install Hack font from [here](https://sourcefoundry.org/hack/)
- Install atom-one-dark theme from [this repo](https://github.com/jonathanchu/atom-one-dark-theme)
