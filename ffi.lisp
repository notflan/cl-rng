
(in-package #:cl-rng-ffi)

(define-foreign-library libsrng
  (:unix (:or "libsrng.so" "libsrng" "./libsrng.so" "/usr/lib/libsrng.so" "/usr/local/lib/libsrng.so"))
  (t (:default "libsrng")))

(use-foreign-library libsrng)

(defcfun "sample" :int (to :pointer))
(defcfun "bytes" :int
  (to :pointer)
  (size :int))

(defun ffi-sample ()
  (with-foreign-pointer (value 8)
    (let ((rval (sample value)))
      (values
       (mem-ref value :double 0)
       (= rval 1)))))

(defun ffi-bytes (size)
  (with-foreign-pointer (value size)
    (let ((rval (bytes value size))
	  (output (make-array size)))
      (and (= rval 1)
	   (loop for x from 0 below size
	      do (setf (aref output x) (mem-aref value :unsigned-char x))))
      (values
       output
       (= rval 1)))))

(export 'ffi-sample)
(export 'ffi-bytes)
