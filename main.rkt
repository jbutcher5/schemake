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

(define (cmd->string c)
  (cond
    [(string? c) c]
    [(symbol? c) (format "~a" c)]
    [else (list->string c)]
    ))

(define (parse-vars vars)
  (hash-map/copy
   vars
   (lambda (k v) (values k (cmd->string v)))))

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
  (if (or (null? name) (null? value))
      null
      (format "~a = ~a" name value)))

(define-syntax (build stx)
  (syntax-case stx ()
    [(_ input output) #'(format "build ~a = ~a" (cmd->string input) (cmd->string output))]
    [(_ input output vars)
     #'(begin (define input (cmd->string input))
              (define output (cmd->string output))
              (define var (parse-vars var))
              (define buffer (build input output))
              (for ([(key val) vars])
                (format-append-ln! buffer "  ~a = ~a" key val)))]))

(define (main)
  (step! rule 'cc (hash 'command '(gcc $in -o $out)))
  (step! build '*.c '(cc *.o))
  (step! rule 'foo (hash 'foo 'bar 'command '(gcc -Wall)))
  (display ninja-output))

(main)
