#lang r5rs
(#%provide (all-defined))

(define (mystack) (list ))

(define (push element stack)
(cons element stack))

(define (top stack)
  (car stack))

(define (.s stack)
  (display "<")
  (display (length stack))
  (display ">")
  (display (reverse stack))
  (newline)
  stack)

(define (pop stack)
  (set! stack (cdr stack)))
  ;(display stack))


(define (bottom stack)
  (car (reverse stack)))

(define (dot stack)
  (display (top stack))(newline)
  (cdr stack))

(define (add stack)
  (cons (+ (car stack) (car(cdr stack))) (cdr(cdr stack))))

(define (multiply stack)
  (cons (* (car stack) (car(cdr stack))) (cdr(cdr stack))))

(define (subtract stack)
  (cons (- (car (cdr stack)) (car stack)) (cdr(cdr stack))))

(define (drop stack)
  (cdr stack))

(define (nip stack)
  (let ((pre 0))
    (begin
      (set! pre (car stack))
      (set! stack (cddr stack))
      (push pre stack))))

(define (dup stack)
  (push (car stack) stack))

(define (swap stack)
  (let ((pre 0) (cur 0))
    (begin
      (set! pre (car stack))
      (set! cur (car (cdr stack)))
      (set! stack (cddr stack))
      (set! stack (push pre stack))
      (push cur stack))))

(define (over stack)
  (let ((pre 0) (cur 0))
    (set! pre (car stack))
    (set! cur (car (cdr stack)))
    (set! stack (cddr stack))
    (set! stack (push cur stack))
    (set! stack (push pre stack))
    (push cur stack)))

(define (tuck stack)
  (let ((pre 0) (cur 0))
    (begin
      (set! pre (car stack))
      (set! cur (car (cdr stack)))
      (set! stack (cddr stack))
      (set! stack (push pre stack))
      (set! stack (push cur stack))
      (push pre stack))))

(define (compare_big stack)
  (let ((pre 0) (cur 0))
    (begin
      (set! pre (car stack))
      (set! cur (car (cdr stack)))
      (set! stack (cddr stack))
      (if (> cur pre)
          (push -1 stack)
          (push 0 stack)))))

(define (compare_small stack)
  (let ((pre 0) (cur 0))
    (begin
      (set! pre (car stack))
      (set! cur (car (cdr stack)))
      (set! stack (cddr stack))
      (if (< cur pre)
          (push -1 stack)
          (push 0 stack)))))

(define (equal stack)
  (let ((pre 0) (cur 0))
    (begin
      (set! pre (car stack))
      (set! cur (car (cdr stack)))
      (set! stack (cddr stack))
      (if (= cur pre)
          (push -1 stack)
          (push 0 stack)))))
    


     




