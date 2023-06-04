#lang racket

(define ninja-output "")
(define ninja-status 0)

(define-syntax-rule (append-ln! buf str)
  (if (buf . equal? . "")
      (set! buf str)
      (set! buf (string-append buf "\n" str))))

(define-syntax-rule (format-append-ln! buf str ...)
  (append-ln! buf (format str ...)))

(define (list->string l)
  (match (count (lambda (_) #t) l)
    [0 ""]
    [_ (foldl (lambda (x xs) (format "~a ~a" xs x)) (format "~a" (car l)) (cdr l))]))

(define (parse-vars vars)
  (if (hash-has-key? vars 'command)
      (hash-set vars 'command (list->string (hash-ref vars 'command)))
      vars))

(define-syntax-rule (step! a ...)
  (when (ninja-status . = . 0)
    (define x (a ...))

    (if (null? x)
        (set! ninja-status 1)
        (append-ln! ninja-output x))))

(define (rule name vars)
  (set! vars (parse-vars vars))

  (cond
    [(hash-has-key? vars 'command)
     (begin
       (define buffer "")
       (format-append-ln! buffer "rule ~a" name)
       (for ([(key val) vars])
         (format-append-ln! buffer "  ~a = ~a" key val))
       buffer)]
    [else null]))

(define (var name value)
  (format "~a = ~a" name value))

(define (main)
  (step! rule 'foo (hash 'foo "bar" 'command '(gcc -Wall)))
  (display ninja-output))

(main)
