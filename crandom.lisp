
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
(defun %crandom-vector (range &rest params)
  (loop for x from 0 below (length range) collect
       (setf (aref range x) (apply 'crandom params))))

(defun %crandom-list (range &rest params)
  (setf (car range) (apply 'crandom params))
  (if (null (cdr range))
      (cons (car range) nil)
      (cons (car range) (apply '%crandom-list (cons (cdr range) params)))))

(defun crandom-range (range &rest params)
  (if (listp range)
      (apply '%crandom-list (cons range params))
      (apply '%crandom-vector (cons range params))))

(defun crandom-bytes (len &key (transform #'identity) (type :vector))
  (multiple-value-bind (vec ok) (cl-rng-ffi:ffi-bytes len)
    (and ok
      (if (eq type :vector)
	  (progn
	    (loop for i from 0 below len do (setf (aref vec i) (funcall transform (aref vec i))))
	    vec)
	  (loop for i from 0 below len collect (funcall transform (aref vec i)))))))

(export 'crandom)
(export 'crandom-range)
(export 'crandom-bytes)
