;;;; read.lisp

(defpackage #:sq/read
  (:use #:cl
        #:sq)
  (:export #:*read-res*))

(in-package #:sq/read)

(defparameter *read-res* '(sq ((a 3)) a a (sq () a -1 ())))
