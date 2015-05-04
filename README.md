# antesc-mode
Emacs mode for Antescofo.

Only syntax highlighting. More is planned.

## Install 

Add in your *.emacs* (or whatever config file for emacs you use) the following lines:

```emacs-lisp
(add-to-list 'load-path path-to-antesc-mode)
(autoload 'antesc-mode "antesc-mode" "Major mode for editing Antescofo code" t)

;Extensions
(setq auto-mode-alist (append '(("\\.\\(score\\|asco\\)\\.txt$" . antesc-mode)) auto-mode-alist))
```

Replace `path-to-antesc-mode`by the right path.
