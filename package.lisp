;;;; package.lisp

(defpackage #:cl-rng
  (:use #:cl))

(defpackage #:cl-rng-ffi
  (:use :cl :cffi :cl-rng))
