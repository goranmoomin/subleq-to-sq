;;;; parse.lisp

(defpackage #:sq/parse
  (:use #:cl
        #:sq
        #:sq/read)
  (:export #:parse))

(in-package #:sq/parse)

(defun parse (read-result)
  (destructuring-bind (sq var-list a b p) read-result
    (declare (ignore sq))
    (let ((var-list-parse-res
            (loop :for (var expr) :in var-list
                  :collect (list var (if (consp expr) (parse expr) expr))))
          (a-parse-res (if (consp a) (parse a) a))
          (b-parse-res (if (consp b) (parse b) b))
          (p-parse-res (if (consp p) (parse p) p)))
      (make-sq var-list-parse-res a-parse-res b-parse-res p-parse-res))))
