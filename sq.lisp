;;;; sq.lisp

(defpackage #:sq
  (:use #:cl)
  (:export #:sq
           #:var-list
           #:a
           #:b
           #:p
           #:make-sq))

(in-package #:sq)

(defclass sq ()
  ((var-list :initarg :var-list :initform (vector) :accessor var-list)
   (a :initarg :a :initform (error "Cannot make a sq object without first argument.") :accessor a)
   (b :initarg :b :initform (error "Cannot make a sq object without second argument.") :accessor b)
   (p :initarg :p :initform (error "Cannot make a sq object without third argument") :accessor p)))

(defun make-sq (var-list a b p)
  (make-instance 'sq :var-list var-list :a a :b b :p p))
