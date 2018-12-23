;;;; sq.asd

(asdf:defsystem #:sq
  :description "Describe sq here"
  :version "0.0.1"
  :depends-on (#:alexandria
               #:quickutil)
  :serial t
  :components ((:file "utils")
               (:file "sq")
               (:file "read")
               (:file "parse")
               (:file "resolve")
               (:file "codegen")))
