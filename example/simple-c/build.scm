#lang r5rs
(#%require schemake)

(require-minimum-version 0.0)
(project! "Schemake Test" 'c)
(new-target! "foo" '("foo.c") '(clang))
(write-ninja!)
