

(in-package :cl-rng)

(defparameter *default-randomness-provider* #'urandom)

(defun chance (fraction &key (provider *default-randomness-provider*))
  (< (funcall provider) fraction))

(export '*default-randomness-provider*)
(export 'chance)

(defun weighted (weights &key (default nil) (provider *default-randomness-provider*))
  (let ((previous 0)
	(result (funcall provider))
	(rval default))
    (mapc (lambda (x)
	    (let ((value (car x))
		  (weight (cdr x)))
	      (and (>= result previous)
		   (<= result (+ previous weight))
		   (setf rval value))
	      (incf previous weight)))
	  weights)
    (values rval result)))

(export 'weighted)

