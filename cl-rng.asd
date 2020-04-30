;;;; cl-rng.asd

(asdf:defsystem #:cl-rng
  :description "urandom for CL"
  :author "Avril (flanchan@cumallover.me)"
  :license  "None"
  :version "0.0.1"
  :serial t
  :depends-on (:cffi)
  :components ((:file "package")
	       (:file "ffi")
               (:file "urandom")
	       (:file "cl-rng")))
