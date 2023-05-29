#lang racket

(define ninja-output "")
(define ninja-status 0)

(define-syntax-rule (append-ln! buf str)
  (set! buf (string-append buf "\n" str)))

(define-syntax-rule (step! a ...)
  (when (ninja-status . = . 0)
    (define x (a ...))

    (if (null? x)
        (set! ninja-status 1)
        (append-ln! ninja-output x))))

(define (rule name vars)
  (cond
    [(hash-has-key? vars 'command)
     (begin
       (define buffer "")
       (append-ln! buffer (format "rule ~a" name))
       (for ([(key val) vars])
         (append-ln! buffer (format "  ~a = ~a" key val)))
       buffer)]
    [else null]))

(define (main)
  (step! rule 'foo (hash 'foo "bar" 'command "cowsay"))
  (display ninja-output))

(main)
