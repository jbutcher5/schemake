#lang racket
(require file/glob)

(define VERSION 0.0)

(define (require-minimum-version ver)
  (when (VERSION . < . ver)
    (raise (format "The current version is too low try a version >=~a" ver) #t)))

(define (main)
  (require-minimum-version 0.1))

(main)
