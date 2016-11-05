;;; red.el --- Support for the Red programming language.

;; Copyright (C) 2015 Joshua Cearley and contributors.

;; This file is NOT part of Emacs.

;; Author: Joshua Cearley <joshua.cearley@gmail.com>
;; Version: 0.0.4

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;; Code:
;; (require 'dash)

(defconst red-integer-regex
  "\\<\\(-?[1-9][0-9]*\\|0\\)\\>"
  "Definition of Red integers.")

(defconst red-hexadecimal-regex
  "\\<\\([0-9A-F]+h\\)\\>"
  "Definition of Red hexadecimal integers.")

(defconst red-float-regex
  "\\<\\([-+]?\\(0\\|[1-9][0-9]*\\)\\(E[-+]?[1-9][0-9]*\\|\\.[0-9]+\\(E[-+]?[1-9][0-9]*\\)?\\)\\)\\>"
  "Definition of Red floating point numbers.")

;;; pairs are two integers
;;; http://www.red-lang.org/2015/06/054-new-datatypes-exceptions-and-set.html
(defconst red-pair-regex
  "\\<\\(-?[1-9][0-9]*\\|0\\)x\\(-?[1-9][0-9]*\\|0\\)\\>"
  "Definition of Red pairs.")

;; percentages are simple floats with a % sigil
(defconst red-percent-regex
  "\\<-?[1-9][0-9]*\\(?:\\.[0-9]+\\)?%\\>"
  "Definition of Red percentage numbers.")

;; tuples are 3-12 integers separated by periods
(defconst red-tuple-regex
  "\\<\\(?:0\\|[1-9][0-9]*\\)\\(?:\\.\\(?:0\\|[1-9][0-9]*\\)\\)\\{2,12\\}\\>"
  "Definition of Red tuples.")

;; setters are words ending with :
(defconst red-setter-regex
  "\\(\\w\\|\\s_\\)+:"
  "Definition of Red setters.")

;; getters are words starting with :
(defconst red-getter-regex
  ":\\(\\w\\|\\s_\\)+"
  "Definition of Red getters.")

;; datatypes are t and words ending with !
(defconst red-datatype-regex
  "\\(\\w\\|\\s_\\)+!\\|\\<t\\>"
  "Definition of Red datatypes.")

;;; Special parts which require text highlights

;; symbols
;; "% * ** + - / // < << <= <> = == =? > >= >> >>> ? ?? NaN? a-an"

;; words
(defconst red-words-regex
  (concat "\\<"
          (regexp-opt-group
           (split-string
            (regexp-quote
             "% * ** + - / // < << <= <> = == =? > >= >> >>> ? ?? a-an about absolute acos action? add all also alter and and~ any any-block! any-block? any-function! any-function? any-list! any-list? any-object! any-object? any-path! any-path? any-string! any-string? any-type! any-word! any-word? append aqua arccosine arcsine arctangent arctangent2 as-color as-ipv4 as-pair as-rgba asin ask at atan atan2 attempt back beige binary? bind bitset? black block? blue body-of break brick brown browse case catch cause-error cd change change-dir char? charset checksum clean-path clear clear-reactions coal coffee collect comma comment complement complement? compose construct context context? continue copy cos cosine cr create-dir crimson crlf cyan datatype? dbl-quote debase deep-reactor! default! default-input-completer dehex difference dir dir? dirize divide do do-file does dot dump-reactions either empty? enbase equal? error? escape eval-set-path even? exclude exists? exit exp extend extract extract-boot-args false fifth file? find first flip-exe-flag float? forall foreach forest forever form fourth func function function? get get-current-dir get-env get-path? get-word? glass gold gray greater-or-equal? greater? green halt has hash? head head? help if image? immediate! inindex? input insert integer? internal! intersect is issue? ivory keys-of khaki last last-lf? leaf length? lesser-or-equal? lesser? lf linen list-dir list-env lit-path? lit-word? ll load log-10 log-2 log-e logic? loop lowercase ls magenta make make-dir map? maroon max min mint modify modulo mold move multiply NaN? native? navy negate negative? new-line new-line? newline next no none none? normalize-dir not not-equal? now null number! number? object object? odd? off offset? oldrab olive on on-parse-event op? or orange or~ overlap? p-indent pad pair? papaya paren? parse parse-trace path? percent? pewter pi pick pink poke positive? power prin print probe purple put pwd q quit quit-return quote random react react? reactor! read reblue Rebol rebolor Red red-complete-file red-complete-path reduce refinement? reflect remainder remove remove-each repeat repend replace request-dir request-file return reverse round routine routine? same? save scalar! second select series! series? set set-current-dir set-env set-path? set-quiet set-word? shift shift-left shift-logical shift-right sienna silver sin sine skip sky slash snow sort source sp space spec-of split split-path square-root stats strict-equal? string? subtract suffix? swap switch system tab tail tail? take tan tangent tanned teal third throw time? to to-hex to-image to-local-file to-red-file transparent trim true try tuple? type? typeset? union unique unless unset unset? until uppercase url? value value? values-of vector? violet wait water what what-dir wheat while white within? word? words-of write xor xor~ yello yellow yes zero? _read-input _set-buffer-history"))
           t t)
          "\\>")
  "Words which are defined by default in the Red programming language.")

(defconst red-font-lock-keywords
  `((,red-tuple-regex . font-lock-constant-face)
    (,red-percent-regex . font-lock-constant-face)
    (,red-float-regex . font-lock-constant-face)
    (,red-hexadecimal-regex . font-lock-constant-face)
    (,red-pair-regex . font-lock-constant-face)
    (,red-integer-regex . font-lock-constant-face)
    (,red-words-regex . font-lock-function-name-face)
    (,red-setter-regex . font-lock-variable-name-face)
    (,red-getter-regex . font-lock-variable-name-face)
    (,red-datatype-regex . font-lock-type-face))
  "Font lock table for the Red programming language")

;;; Syntax table.
(defvar red-syntax-table
  (let ((syn-table (make-syntax-table)))
    ;; Lisp style comments
    (modify-syntax-entry ?\; "<" syn-table)
    (modify-syntax-entry ?\n ">" syn-table)
    (modify-syntax-entry ?\\ "." syn-table)
    (modify-syntax-entry ?^ "\\" syn-table)
    ;; Dashes are part of identifiers, and thus words
    (modify-syntax-entry ?- "w" syn-table)
    syn-table
    )
  "Syntax table for the Red language.")

;;; Standard intelligent comments.
(defun red-comment-dwim (arg)
  "`Do What I Mean' commenting for Red. Based on the `comment-dwim' function."
  (interactive "*P")
  (require 'newcomment)
  (let ((comment-start ";") (comment-end ""))
    (comment-dwim arg)))

;;; Line indentation.
(defvar red-indentation-amount 3
  "How many cells of indentation are used in Red source code.")

(defun red-get-indentation-for-line ()
  "Figures out the proper indentation for the current line."
  (save-excursion
    (if (bobp)
        0
      (let ((indentation 0)
            (closers "[\])}]")
            (openers "[\[({]")
            (potatos "[^])}\t ]"))
        ;; dedent if closers are present, but only if the line
        ;; contains nothing except for closers
        (let* ((bol (progn (beginning-of-line)
                           (point)))
               (eol (progn (end-of-line)
                           (point)))
               (open (how-many openers bol eol))
               (close (how-many closers bol eol))
               (vegetables (how-many potatos bol eol))
               (diff (- open close)))
          (if (and (= 0 vegetables) (< diff 0))
              (setq indentation (* diff red-indentation-amount))))
        ;; add previous line's indentation
        (previous-line)
        (setq indentation (+ indentation (current-indentation)))
        ;; indent if openers are present
        (let* ((bol (progn (beginning-of-line)
                           (point)))
               (eol (progn (end-of-line)
                           (point)))
               (open (how-many openers bol eol))
               (close (how-many closers bol eol))
               (diff (- open close)))
          (if (> diff 0)
              (setq indentation (+ indentation (* diff red-indentation-amount)))))
        (max 0 indentation)))))

(defun red-indent-line ()
  "Indents the current line using Red's indentation rules."
  (interactive "*")
  (let* ((a (point))
         (b (progn (back-to-indentation) (point))))
    (indent-line-to (red-get-indentation-for-line))
    (back-to-indentation)
    (forward-char (- a b))))

(defun red-electric-insert-and-indent ()
  "Automatically reindents the current line after inserting a character."
  (interactive "*")
  (self-insert-command 1)
  (red-indent-line))

(defun comment-or-string-p (&optional pos)
  "Returns true if the point is in a comment or string."
  (save-excursion (let ((parse-result (syntax-ppss pos)))
                    (or (elt parse-result 3) (elt parse-result 4)))))

(defun propertize-bracket-string (start fin)
  (save-excursion
    (goto-char start)
    (while (< (point) fin)
      (let ((beg (search-forward "{" fin 'noerror)))
        (when (and beg (not (comment-or-string-p beg)))
          (let* ((end (or (re-search-forward "[^^]}" fin 'noerror) (point)))
                 (last-match beg)
                 (openers (how-many "{" last-match end)))
            (while (> openers 0)
              (setq last-match end
                    end (or (re-search-forward "[^^]}" fin 'noerror) (point))
                    openers (1- (how-many "{" (1+ last-match) end))))
            (put-text-property (1- beg) beg 'syntax-table (string-to-syntax "|"))
            (put-text-property (1- end) end 'syntax-table (string-to-syntax "|"))))))))

;;; Mode definition.
(define-derived-mode red-mode prog-mode
  "Red"
  "Major mode for editing source code in the Red or Red/System programming languages."
  :syntax-table red-syntax-table

  ;; install font lock settings
  (setq font-lock-defaults '((red-font-lock-keywords)))

  ;; map smart commenting
  (define-key red-mode-map [remap comment-dwim] 'red-comment-dwim)

  ;; map electric indentation
  ;;(define-key red-mode-map "]" 'red-electric-insert-and-indent)
  ;;(define-key red-mode-map ")" 'red-electric-insert-and-indent)
  ;;(define-key red-mode-map "}" 'red-electric-insert-and-indent)

  ;; map our indenter
  (make-local-variable indent-line-function)
  (setq indent-line-function 'red-indent-line)

  ;; make {} strings behave
  (if (boundp 'syntax-propertize-function)
      (setq-local syntax-propertize-function 'propertize-bracket-string))
  )

;;; Auto-insert

(define-auto-insert
  '("\\.red\\'" . "Red script")
  '(lambda ()
     (skeleton-insert
      '(""
        "Red [" \n
        > "Title: \"Untitled\"" \n
        > "Author: \"" user-full-name "\"" \n
        > "Version: 0.0.1" \n
        "]" > \n
        nil))))

(define-auto-insert
  '("\\.reds\\'" . "Red/System module")
  '(lambda ()
     (skeleton-insert
      '(""
        "Red/System [" \n
        > "Title: \"Untitled\"" \n
        > "Author: \"" user-full-name "\"" \n
        > "Version: 0.0.1" \n
        "]" > \n
        nil))))

;;; Postamble

;; Automatically activated `red-mode' when a Red or Red/System buffer
;; is opened.
(add-to-list 'auto-mode-alist '("\\.reds?\\'" . red-mode))

;; Allow auto-loading this plugin.
(provide 'red)

;;; red.el ends here
