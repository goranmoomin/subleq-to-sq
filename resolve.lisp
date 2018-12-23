;;;; resolve.lisp

(defpackage #:sq/resolve
  (:use #:cl
        #:sq
        #:sq/read
        #:sq/parse)
  (:export #:wrapper
           #:unwrap
           #:wrap)
  (:export #:literal
           #:value
           #:make-literal)
  (:export #:variable
           #:symbol
           #:reference
           #:make-variable)
  (:export #:resolve))

(in-package #:sq/resolve)

(defclass wrapper ()
  ((unwrap :initarg :unwrap :accessor unwrap)))

(defun wrap (value)
  (make-instance 'wrapper :unwrap value))

(defclass literal ()
  ((value :initarg :value :initform (error "Cannot make literal without value") :accessor value)))

(defun make-literal (value)
  (make-instance 'literal :value value))

(defclass variable ()
  ((symbol :initarg :symbol :initform (error "Cannot make variable without symbol") :accessor symbol)
   (reference :initarg :reference :initform (error "Cannot make variable without reference") :accessor reference)))

(defun make-variable (symbol reference)
  (make-instance 'variable :symbol symbol :reference reference))

(defun resolve (parse-result &optional (bind-map (make-hash-table)) (resolve-result (make-sq nil nil nil nil)))
  (let ((var-list (var-list parse-result))
        (new-bind-map (qtl:copy-hash-table bind-map))
        (slot-list '(a b p)))
    (loop :for (var expr) in var-list
          :do (setf (gethash var new-bind-map) (wrap expr)))
    (loop :for slot :in slot-list
          :for expr := (slot-value parse-result slot)
          :if (and (not (typep expr (find-class 'sq)))
                   (not (numberp expr))
                   (not (null expr)))
            :do (setf (slot-value resolve-result slot)
                      (make-variable
                       (slot-value parse-result slot)
                       (gethash expr new-bind-map)))
          :else
            :do (setf (slot-value resolve-result slot)
                      (make-literal expr)))
    (loop :for accessor :in (list #'a #'b #'p)
          :for expr := (funcall accessor resolve-result)
          :when (and
                 (typep expr (find-class 'literal))
                 (typep (value expr) (find-class 'sq)))
            :do (resolve (funcall accessor parse-result) new-bind-map (value expr))) resolve-result))
