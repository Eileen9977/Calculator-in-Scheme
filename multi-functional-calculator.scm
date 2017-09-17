#lang r5rs
(#%provide (all-defined))
(#%require "stack.scm")
(#%require "String-input.scm")

(define (false input-so-far)
  (display "Invalid input!")(newline)
  input-so-far)

(define (haha input-so-far)
  (display " ") (newline)
  input-so-far)

(define functions (list
                   (list ".s"     .s)
                   (list "."      dot)
                   (list "+"      add)
                   (list "-"      subtract)
                   (list "*"      multiply)
                   (list "nip"    nip)
                   (list "drop"   drop)
                   (list "dup"    dup)
                   (list "swap"   swap)
                   (list "tuck"   tuck)
                   (list "over"   over)
                   (list ">"      compare_big)
                   (list "<"      compare_small)
                   (list "="      equal)
                   (list "false"  false)
                   
                   ))

(define (contain? l i)
  (if (null? l) #f
      (if (string=? (car l) i)
          #t
          (contain? (cdr l) i))))


(define (calculator)
  (let*
      ((input (mystack))
       (search-list functions)
       (counter 0)
       (counter2 0)
       (op false)
       ; below is for defining while
       (define-while #f)
       (is-condition #f)
       (is-loop-code #f)
       (store-loop #f)
       (count-begin 0)
       (condition (mystack))
       (loop-code (mystack))
       (read-while-into-if #f)
       (things-to-push-when-repeat (mystack))
       (loop-length 0)
       (total-loop 0)
       (has-while #f)
       ;below is for function definition
       (put-flag #f)
       (set-name #f)
       (def-flag #f)
       (func-name "")
       (func-string "")
       (user-func-name (list ))
       (user-func (list ))
       ; below is for if statements
       (define-if-flag #t)
       (if-true (mystack))
       (if-false (mystack))
       (not-apply "")
       (readin-if-true-flag #f)
       (readin-if-false-flag #f)
       (apply-if #f)
       (apply-else-if #f)
       (contain-flag #f)
       (has-if #f)
       (if-length 0)
       (count-if 0)
       (count-total-if 0)
       (func-def (mystack))) 
    (do ((a 1 (+ a 1))) ((= a 0) input)
      (let ((track (string-tokenize-separated-by (get-until-delimiter (string #\newline)) " ")))
        (letrec ((calculate
                  (lambda (t)
                    (begin
                      (set! counter (length t))
                      (do ((n 0 (+ n 1))) ((>= n counter) input) 
                        (if (string=? ":" (top t))
                            (begin
                              (set! put-flag #t)
                              (set! define-if-flag #t)
                              (set! define-while #t)
                              (set! t (cdr t))
                              (set! set-name #t))
                            (if set-name 
                                (begin
                                  (set! func-name (car t))
                                  (set! func-string (car t))
                                  (set! set-name #f)
                                  (set! t (cdr t)))
                                
                                ; below is for defining while loop
                                
                                (if (and (not read-while-into-if) (not define-while) (string=?  (top t) "begin"))
                                    (begin
                                      (set! count-begin (+ count-begin 1))
                                      (if (> count-begin 1)
                                          (begin
                                            (cond (is-condition (set! condition (cons "begin" condition)))
                                                  (is-loop-code (set! loop-code (cons "begin" loop-code))))
                                            (set! t (cdr t)))
                                          (begin
                                            (set! is-condition #t)
                                            (set! is-loop-code #f)
                                            (set! has-while #t)
                                            (set! store-loop #t)
                                            (set! t (cdr t)))))
                                    
                                    (if (and (not define-while) (not read-while-into-if) (string=? (top t) "repeat"))
                                        (if (> count-begin 1)
                                            (begin
                                              (cond (is-condition (set! condition (cons (top t) condition)))
                                                    (is-loop-code (set! loop-code (cons (top t) loop-code))))
                                              (set! count-begin (- count-begin 1))
                                              (set! t (cdr t)))
                                            (begin
                                              (set! is-loop-code #f)
                                              (set! has-while #f)
                                              (set! store-loop #f)
                                              (set! loop-length 0)
                                              (set! count-begin (- count-begin 1))
                                              (set! things-to-push-when-repeat (mystack))
                                              (set! things-to-push-when-repeat
                                                    (append condition
                                                            (list "if") (reverse loop-code)
                                                            (list "begin") condition
                                                            (list "while") (reverse loop-code)
                                                            (list "repeat")(list "else") (list "endif")))
                                              (set! loop-length (length things-to-push-when-repeat))
                                              (set! counter (+ counter loop-length))
                                              (set! total-loop (+ total-loop loop-length))
                                              (set! t (append things-to-push-when-repeat (cdr t)))
                                              (set! condition (mystack))
                                              (set! loop-code (mystack))))
                                        
                                        (if (and (not define-while) (not read-while-into-if) store-loop)
                                            (cond ((string=? (top t) "while")
                                                   (if (> count-begin 1)
                                                       (begin 
                                                         (cond (is-condition (set! condition (cons "while" condition)))
                                                               (is-loop-code (set! loop-code (cons "while" loop-code))))
                                                         (set! t (cdr t)))
                                                       
                                                       (begin
                                                         (set! is-condition #f)
                                                         (set! is-loop-code #t)
                                                         (set! condition (reverse condition))
                                                         (set! t (cdr t)))))
                                                  (is-condition
                                                   (begin (set! condition (cons (top t) condition))
                                                          (set! t (cdr t))))
                                                  (is-loop-code
                                                   (begin (set! loop-code (cons (top t) loop-code))
                                                          (set! t (cdr t)))))
                                            
                                            ;below if for defining if
                                            
                                            (if (and (not define-if-flag) (string=? "if" (top t)))
                                                (begin
                                                  (set! count-if (+ count-if 1))
                                                  (if (> count-if 1)
                                                      (begin
                                                        (cond
                                                          (readin-if-true-flag (set! if-true (cons (top t) if-true)))
                                                          (readin-if-false-flag (set! if-false (cons (top t) if-false))))
                                                        (set! t (cdr t)))
                                                      (begin
                                                        (set! readin-if-true-flag #t)
                                                        (set! read-while-into-if #t)
                                                        (set! readin-if-false-flag #f)
                                                        (if (= (top input) 0)
                                                            (begin (set! apply-else-if #t) (set! apply-if #f) (set! input (cdr input))(set! t (cdr t)))
                                                            (begin (set! apply-if #t)(set! apply-else-if #f) (set! input (cdr input)) (set! t (cdr t)))))))
                                                (if (and (not define-if-flag) (string=? (top t) "else"))
                                                    (if (> count-if 1)
                                                        (begin
                                                          (cond
                                                            (readin-if-true-flag (set! if-true (cons (top t) if-true)))
                                                            (readin-if-false-flag (set! if-false (cons (top t) if-false))))
                                                          (set! t (cdr t)))
                                                        (begin
                                                          (set! readin-if-true-flag #f)
                                                          (set! readin-if-false-flag #t)
                                                          (set! t (cdr t))) )
                                                    (if (and (not define-if-flag) (string=? (top t) "endif")) 
                                                        (if (and (> count-if 1)
                                                                 (< (+ n 1) counter))
                                                            (begin
                                                              (cond
                                                                (readin-if-true-flag (set! if-true (cons (top t) if-true)))
                                                                (readin-if-false-flag (set! if-false (cons (top t) if-false))))
                                                              (set! count-if (- count-if 1))
                                                              (set! t (cdr t)))
                                                            
                                                            (begin
                                                              (set! readin-if-false-flag #f)
                                                              (set! read-while-into-if #f)
                                                              (set! has-if #t)
                                                              (cond (apply-if
                                                                     (begin
                                                                       (set! t (append (reverse if-true) (cdr t)))
                                                                       (set! if-length (length if-true))
                                                                       (set! if-true (list )) (set! if-false (list )) (set! count-if 0)))
                                                                    (apply-else-if
                                                                     (begin
                                                                       (set! t (append (reverse if-false) (cdr t)))
                                                                       (set! if-length (length if-false))
                                                                       (set! if-false (list )) (set! if-true (list )) (set! count-if 0))))
                                                              (set! count-total-if (+ count-total-if if-length))
                                                              (set! counter (+ counter if-length)))  )
                                                        
                                                        (if (and (not define-if-flag) readin-if-true-flag)
                                                            (begin
                                                              (set! if-true (cons (car t) if-true))
                                                              (set! t (cdr t)))
                                                            (if (and (not define-if-flag) readin-if-false-flag)
                                                                (begin
                                                                  (set! if-false (cons (car t) if-false))
                                                                  (set! t (cdr t)))
                                                                
                                                                (if (string=? ";" (top t))
                                                                    (begin (set! put-flag #f)
                                                                           (set! define-if-flag #f)
                                                                           (set! define-while #f)
                                                                           (set! func-def (reverse func-def))
                                                                           (display "You have defined a function: ")
                                                                           (display func-def) (newline)
                                                                           (set! user-func-name (push func-name user-func-name))
                                                                           (set! def-flag #t)  ;flag of define function
                                                                           (set! t (cdr t)))
                                                                    (if put-flag
                                                                        (begin
                                                                          (set! func-def (cons (car t) func-def))
                                                                          (set! t (cdr t)))
                                                                        ; this is calculator part
                                                                        (if (number? (string->number (top t))) 
                                                                            (begin 
                                                                              (set! input (cons (string->number (top t)) input))
                                                                              (set! t (cdr t)))
                                                                            (if (contain? user-func-name (car t))
                                                                                (begin (map (lambda (s)
                                                                                              (if (null? t)
                                                                                                  (display "")
                                                                                                  (if (string=? (top t) (car s))
                                                                                                      (set! op (car(cdr s)))                          
                                                                                                      ))) user-func)
                                                                                       (set! t (op t))
                                                                                       (if (and (not has-if) (not has-while))
                                                                                           (set! counter (- counter (- counter2 1)))
                                                                                           (begin
                                                                                             (set! counter (- counter (- counter2 1) count-total-if total-loop)) (set! has-if #f))))   
                                                                                (begin
                                                                                  (map (lambda (s)
                                                                                         (if (null? t)
                                                                                             (display "false")
                                                                                             (if (string=? (top t) (car s))
                                                                                                 (set! op (car(cdr s)))
                                                                                                 ))) search-list)
                                                                                  (set! input (op input))
                                                                                  (set! op haha)
                                                                                  (set! t (cdr t)))))))))))))))  )))
                      
                      (if def-flag 
                          (begin
                            (let ((definition func-def))
                              (letrec ((func-name
                                        (lambda (s)    
                                          (begin
                                            (set! s (append definition (cdr s)))  
                                            (set! counter2 (length s))
                                            (calculate s)))))
                                (begin
                                  (display "Function name is: ") (display func-string) (newline)
                                  (set! user-func (append user-func (list (list func-string func-name))))))
                              (set! def-flag #f)
                              (set! func-def (list))))) (set! func-def (list )) (set! if-true (list )) (set! if-false (list)))
                    ))) (calculate track))
        ))input))

(calculator)





