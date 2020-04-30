
(in-package #:cl-rng)

(defun crandom (&key (limit 1.0) (precision 1) (transform nil))
  (let ((transform (or transform #'identity)))
    (multiple-value-bind (result ok) (cl-rng-ffi:ffi-sample)
      (and ok
	   (funcall transform
		    (* limit
		       (if (< precision 2)
			   result
			   (/ (apply #'+ (mapcan #'(lambda (x)
						     (and (not (null x))
							  (list x)))
						 (loop for x from 0 below precision collect
						      (crandom))))
			      precision))))))))

(export 'crandom)
