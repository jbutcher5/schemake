#lang racket
(require file/glob)

(define VERSION 0.0)
(define PROJECT null)
(define LANGUAGE null)

(define (require-minimum-version ver)
  (when (VERSION . < . ver)
    (raise (format "The current version is too low try a version >=~a" ver) #t)))

(define (project! name lang)
  (set! PROJECT name)
  (set! LANGUAGE lang))

(define (main)
  (require-minimum-version 0.1)
  (project! "Schemake Test" )
  )

(main)
