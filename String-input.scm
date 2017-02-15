;; When working with strings in scheme,
;; remember to use "string-=?" or "equal?" to compare strings; "=" is just for numbers:
;; > (string=? "hi" "hi")
;; #t
;; > (equal? "hi" "hi")
;; #t
;;
;; This file contains many useful functions that together allow input of one word, or "token" at a time.
;; For CS245, you'll probably only need to use (get-token),
;;  which is meant to work like using "cin" for a string in C++.
;;
;; For more detail, see the function get-token-example (at the bottom) as an example
;;  To try out the example, run this file in DrScheme, type (get-token-example),
;;  and then type some words followed by a "<EOF>" (with a space before the "<EOF>")
;;
;; For many other useful Scheme string functions, see http://download.plt-scheme.org/doc/html/reference/strings.html

;; These make drracket treat this file as R5RS scheme:
#lang r5rs
(#%provide (all-defined))

;; (string-location-of "hello" #\l)    ; 2
;; (string-location-of "hello" #\z)    ; -1
;; (string-has  "hello" #\z)    ; #f
(define (string-location-of s char)  ; not sure why this isn't in R5RS ... perhaps they would use a list of char?
  "Given string S and character CHAR, return the minimum index i such that (equal? (string-ref S i) CHAR) is true"
  (letrec ((len (string-length s))
           (string-location-of-tr
            (lambda (index)
              (if (= index len)
                  -1
                  (if (equal? (string-ref s index) char)
                      index
                      (string-location-of-tr (+ 1 index)))))))
    (string-location-of-tr 0)))
(define (string-has s char)
  (>= (string-location-of s char) 0))


;; (string-location-of-any "hello" "z")  ; -1
;; (string-location-of-any "hello" "ol") ; 2
;; (string-has-any "hello" "z")   ; #f
(define (string-location-of-any s chars)
  "Given strings S and CHARS, return the minimum index i such that (string-location-of CHARS (string-ref S i)) is true"
  (letrec ((len (string-length s))
           (string-location-of-any-tr
            (lambda (index)
              (if (= index len)
                  -1
                  (if (string-has chars (string-ref s index))
                      index
                      (string-location-of-any-tr (+ 1 index)))))))
    (string-location-of-any-tr 0)))
(define (string-has-any s chars)
  (>= (string-location-of-any s chars) 0))



;; (get-until-delimiter (string #\space #\tab #\newline))
(define (get-until-delimiter end-marks)
  "Get characters from user input until one of END-MARKs is encountered; return all but END-MARK"
  (letrec ((get-until-delim-tr
            (lambda (input-so-far)
              (let ((next-char (read-char)))
                (if (string-has end-marks next-char)
                    input-so-far
                    (get-until-delim-tr (string-append input-so-far (string next-char))))))))
    (get-until-delim-tr "")))

;; (list (get-line) (get-line) (get-line))  ; this test should let you enter three lines ... note that blank lines are included
(define (get-line)   ; maybe in R6RS scheme? But I'm not sure if the newline is included in the return
  "Get characters from user input until a newline character, return as a string WITHOUT the newline, skip blank lines"
  (get-until-delimiter (string #\newline)))


;; get-token reads a token until the next separator (blank space), which is typically one of standard-token-separators
(define standard-token-separators (string #\space #\tab #\newline))
(define (get-token-separated-by blanks)
  "Get characters until we see a non-BLANK, return all non-BLANK chars before next BLANK, which is discarded"
  (let ((try (get-until-delimiter blanks)))
    (if (string=? try "")
        (get-token-separated-by blanks)
        try)))

(define (get-token)
  (get-token-separated-by standard-token-separators))

;; (string-tokenize "  this is    a test. ... " " ")  ; ("this" "is" "a" "test." "...")
(define (string-tokenize-separated-by s blanks) ; subset of R6RS functionality, as it always breaks on spaces; see http://srfi.schemers.org/srfi-13/srfi-13.html#string-tokenize
  "Break a string into a list of strings of non-space characters according to where the spaces are"
  (if (string=? s "")
      (list)
      (let ((pos (string-location-of-any s blanks)))
        (case pos
          (-1   (list s))
          (0    (string-tokenize-separated-by (substring s 1) blanks))
          (else (cons (substring s 0  pos) (string-tokenize-separated-by (substring s (+ pos 1)) blanks)))))))
(define (string-tokenize s)
  (string-tokenize-separated-by s standard-token-separators))

(define (get-token-example)
  "This function shows the use of get-token. It is typically used with the standard blanks (space, tab, and newline), i.e. called (get-token  standard-token-separators)."
  (define (get-tokens-and-print-them-with-numbers what-token-number)
    (let ((the-next-token (get-token)))
      (map display (list "Token-number " what-token-number " is \"" the-next-token "\""))
      (newline)
      (if (not (string=? the-next-token "<EOF>"))
	  (get-tokens-and-print-them-with-numbers (+ what-token-number 1)))))
  (define greeting "Welcome to the get-token example.")
  
  ; main body of get-token-example --- print a greeting, then start get-tokens-and-print-them-with-numbers
  (display greeting)
  (display "\nNow the above greeting as a list of tokens:\n")
  (map (lambda (token) (display (string-append "  token '" token "'\n"))) (string-tokenize greeting))
  
  (display "\n\nNow enter one line and see the tokens: ")
  (map (lambda (token) (display (string-append "  token '" token "'\n"))) (string-tokenize (get-line)))
  
  (display "\nType some more input with line breaks wherever, and see the tokens:\n")
  (newline)
  (display "End with a single '<EOF>' by itself.")
  (newline)
  (get-tokens-and-print-them-with-numbers 1))

