#lang racket
(require file/glob)

(define VERSION 0.0)
(define PROJECT null)
(define LANGUAGE null)

(define RULES (mutable-set))
(define BUILDS (mutable-set))

(struct rule (name command))
(struct build (target rule in))

(define (rule->string r)
  (match r
    [(rule name command) (format "rule ~a\n  command = ~a\n" name command)]))

(define (build->string b)
  (match b
    [(build target rule in) (format "build ~a: ~a ~a\n" target rule in)]))

(define (require-minimum-version ver)
  (when (VERSION . < . ver)
    (raise (format "The current version is too low try a version >=~a" ver) #t)))

(define (project! name lang)
  (set! PROJECT name)
  (set! LANGUAGE lang))

(define (new-target! name src (lang null))
  (define language LANGUAGE)
  (when (not (null? lang))
    (set! language lang))

  (match language
    ['c (begin
          (set-add! RULES (rule 'cc "gcc -c $in -o $out"))

          (define obj '())
          (for ((f src))
            (define out (regexp-replace #rx"\\.c" f ".o"))
            (set! obj (cons out obj))
            (set-add! BUILDS (build out 'cc f)))

          (define obj-str (let obj->str ([o obj])
                            (match o
                              [`(,x) x]
                              ['() ""]
                              [xs (format "~a ~a" (car xs) (obj->str (cdr xs)))])))

          (set-add! RULES (rule 'link "gcc $in -o $out"))
          (set-add! BUILDS (build name 'link obj-str)))]
    ['() (raise "No language has been specified" #t)]))

(define (write-ninja! (file-name "build.ninja"))
  (define f (open-output-file file-name #:exists 'update))

  (for ([rule RULES])
    (display (rule->string rule) f))

  (for ([build BUILDS])
    (display (build->string build) f))

  (close-output-port f))

(define (main)
  (require-minimum-version 0.0)
  (project! "Schemake Test" 'c)
  (new-target! "foo" '("foo.c"))
  (write-ninja!))

(main)
