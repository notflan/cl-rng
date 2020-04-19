;;;; cl-rng.lisp

(in-package #:cl-rng)

(defun urandom (&key (limit 1.0) (precision 1) (transform nil))
  (let ((transform (or transform (lambda (x) x))))
    (with-open-file (rng "/dev/urandom" :element-type 'unsigned-byte)
      (assert (> precision 0))
      (if (= precision 1)
	  (funcall transform (* limit (/ (read-byte rng) 255)))
	  (let* ((val (apply '+ (loop for i from 0 below precision collect (read-byte rng))))
		 (max (* precision 255))
		 (frac (/ val max)))
	    (values (* limit frac) frac))))))

(defun %urandom-vector (range &rest params)
  (loop for x from 0 below (length range) collect
       (setf (aref range x) (apply 'urandom params))))

(defun %urandom-list (range &rest params)
  (setf (car range) (apply 'urandom params))
  (when (not (null (cdr range)))
    (apply '%urandom-list (cons (cdr range) params))))

(defun urandom-range (range &rest params)
  (if (listp range)
      (apply '%urandom-list (cons range params))
      (apply '%urandom-vector (cons range params))))

(export 'urandom)
(export 'urandom-range)

