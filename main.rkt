#lang racket

(define ninja-output "")

(define (ninja-append! str)
  (set! ninja-output (string-append ninja-output "\n" str "\n")))

(ninja-append! "Hello, World!")

(display ninja-output)
