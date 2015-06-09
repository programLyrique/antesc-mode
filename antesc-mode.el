;; Antescofo major mode

;; Just syntax highlighting now


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;OSC

;; Documenting OSC protocol for Antescofo
;; prefix /antescofo/
;; in port: 5678 ; out_port : 6789
;; event_beatpos

;;TODO: makes it possible to choose the host

(require 'osc)

;To send messages to Antescofo
(defvar antescofo-client
  (osc-make-client  "localhost" 5678) )

;To receive messages from Antescofo
(defvar antescofo-server
  (osc-make-server
   "localhost" 6789
   (lambda (path &rest args)
     (message "Unhandled: %s %S" path args))))

(osc-server-set-handler antescofo-server "/antescofo/*"
			(lambda (path &rest args)
			  (message "Unhandled2: %s %S" path args)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Syntax Highlighting

(defvar antesc-control '("loop" "if" "else" "Curve" "whenever" "@grain" "@jump" "@guard" "@abort" "@action" "@ante" "@name" "@norec" "@post" "@kill" "@target" ) )
;(defvar antesc-control '("loop" "if" "else" "Curve" "whenever" ) )
(defvar antesc-types '("@global" "@local" "@tight" "@loose" "@type" "@dsp_channel" "@dsp_inlet" "@dsp_outlet" "@faustdef" "@macro_def" "@fun_def" "@proc_def" "@pattern_def" "@track_def" "@immediate" "@inlet" "@label" "@staticscope" "@type") )
(defvar antesc-builtin '("Annotation" "R_NOW" "VARIANCE" "NOTE" "TRILL" "CHORD" "BPM" "PITCH" "@insert"  "@coef" "@hook" "@modulate" "@refractory" "@tempo" "@transpose") )
;(defvar antesc-builtin '("Annotation" "R_NOW" "VARIANCE" "NOTE" "TRILL" "CHORD" "BPM" "PITCH" ) )
  
  ;; I'd probably put in a default that you want, as opposed to nil
 (defvar antesc-tab-width nil "Width of a tab for MYDSL mode")
  
  ;; Two small edits.
  ;; First is to put an extra set of parens () around the list
  ;; which is the format that font-lock-defaults wants
  ;; Second, you used ' (quote) at the outermost level where you wanted ` (backquote)
  ;; you were very close
  (defvar antesc-font-lock-defaults
    `((
       ("\\s\"\\|\\s|" . font-lock-string-face)
	 ("\\b\\$\\$[[:alnum:]\|_]+\\b" . font-lock-warning-face)
	 ("\\b\\$[[:alnum:]\|_]+\\b" . font-lock-variable-name-face)
	 ("\\b[[:digit:]]+\\(\\(ms\\)\\|\\(s\\)\\)?\\b" . font-lock-constant-face)
	 
	 ("::[[:alnum:]\|_]+\\b" . font-lock-preprocessor-face)

	 ("@[[:alnum:]\|_]+\\b" . font-lock-function-name-face)
     	 (,(regexp-opt antesc-control 'words) . font-lock-keyword-face)
	 (,(regexp-opt antesc-types 'words) . font-lock-type-face)
	 (,(regexp-opt antesc-builtin 'words) . font-lock-builtin-face)


	 )))


(defun highlight-line (pos)
  (beginning-of-line pos)
  (let ((overlay-highlight (make-overlay					
			     (line-beginning-position)
			    (+ 1 (line-end-position)))))
    (overlay-put overlay-highlight 'face '(:background "lightgreen"))
    (overlay-put overlay-highlight 'line-highlight-overlay-marker t)))

  
  (define-derived-mode antesc-mode c-mode "Antesc mode"
    "MYDSL mode is a major mode for editing MYDSL  files"

    ;(kill-all-local-variables)
  

  
    ;; when there's an override, use it
    ;; otherwise it gets the default value
    (when antesc-tab-width
      (setq tab-width antesc-tab-width))
  
    ;; for comments
    ;; overriding these vars gets you what (I think) you want
    ;; they're made buffer local when you set them
    (setq comment-start ";")
    (setq comment-end "")

    ;lisp style comment
    (modify-syntax-entry ?\; "<b" antesc-mode-syntax-table)
    (modify-syntax-entry ?\n ">" antesc-mode-syntax-table)

    ;;  ;; bash style comment: “# …” 
    ;; (modify-syntax-entry ?# "< c" antesc-mode-syntax-table)
    ;; (modify-syntax-entry ?\n "> c" antesc-mode-syntax-table)

    ;; ;; C++ style comment “// …” 
    ;; (modify-syntax-entry ?\/ ". 12bc" antesc-mode-syntax-table)
    ;; (modify-syntax-entry ?\n "> bc" antesc-mode-syntax-table)

     ;; C and C++ comments
    (modify-syntax-entry ?\/ ". 14b" antesc-mode-syntax-table)
    (modify-syntax-entry ?* ". 23b" antesc-mode-syntax-table)

    ;; you again used quote when you had '((mydsl-hilite))
    ;; I just updated the variable to have the proper nesting (as noted above)
    ;; and use the value directly here
    (setq font-lock-defaults antesc-font-lock-defaults)

    (highlight-line 10)

    ;;A gnu-correct program will have some sort of hook call here.

     (setq major-mode 'antesc-mode)
     (setq mode-name "antesc mode")
     (run-hooks 'antesc-mode-hook)
    )
  
  (provide 'antesc-mode)
