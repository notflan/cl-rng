

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

(defun shuffle! (sequence &key (provider *default-randomness-provider*))
  (if (listp sequence)
      (loop for i from (1- (length sequence)) above 0 do
	   (rotatef (nth i sequence)
		    (nth (funcall provider :limit i :transform #'floor) sequence)))
      (loop for i from (1- (length sequence)) above 0 do
	   (rotatef (aref sequence i)
		    (aref sequence (funcall provider :limit i :transform #'floor)))))
  sequence)

(export 'shuffle!)

