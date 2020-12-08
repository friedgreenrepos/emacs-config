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
- Install **magit**, **web-mode**, **json-mode** from melpa
- The other tweaks are commented already, so it should be pretty straightforward.

## Org mode
I still keep my org mode configuration inside .emacs file... Most likely it's not the best way to do it but ¯\_(ツ)_/¯ 

## Optional (currently not installed):
- Download and install Hack font from [here](https://sourcefoundry.org/hack/)
- Install atom-one-dark theme from [this repo](https://github.com/jonathanchu/atom-one-dark-theme)
