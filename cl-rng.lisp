

(in-package :cl-rng)

(defparameter *default-randomness-provider* #'urandom
  "The default randomness provider used by cl-rng functions")

(defun chance (fraction &key (provider *default-randomness-provider*))
  "Returns T if chance fraction is met"
  (< (funcall provider) fraction))

(defun weighted (weights &key (default nil) (provider *default-randomness-provider*))
  "Interpret weights as an alist where the key is the item and the value is the chance. If no chances are met, return default"
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
  "In-place shuffle a sequence"
  (if (listp sequence)
      (loop for i from (1- (length sequence)) above 0 do
	   (rotatef (nth i sequence)
		    (nth (funcall provider :limit i :transform #'floor) sequence)))
      (loop for i from (1- (length sequence)) above 0 do
	   (rotatef (aref sequence i)
		    (aref sequence (funcall provider :limit i :transform #'floor)))))
  sequence)

(defun within (sequence &key (provider *default-randomness-provider*))
  "A random value withing a sequence. Can be setf()'d"
  (if (listp sequence)
      (nth (funcall provider :limit (1- (length sequence)) :transform 'round) sequence)
      (aref sequence (funcall provider :limit (1- (length sequence)) :transform 'round))))

(defun within-set (sequence value)
  (let ((index (funcall *default-randomness-provider* :limit (1- (length sequence)) :transform 'round)))
    (if (listp sequence)
	(setf (nth index sequence) value)
	(setf (aref sequence index) value))))

(defun range (start end &key (integral nil) (provider *default-randomness-provider*))
  "A random number in a range"
  (+ start (funcall provider :limit (- end start) :transform (if integral 'round 'identity))))

;; Exports

(export '*default-randomness-provider*)
(defsetf within within-set)
(export 'range)
(export 'within)
(export 'shuffle!)
(export 'chance)
