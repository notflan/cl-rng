
(in-package #:cl-rng-ffi)

(define-foreign-library libsrng
  (:unix (:or "libsrng.so" "libsrng" "./libsrng.so" "/usr/lib/libsrng.so" "/usr/local/lib/libsrng.so"))
  (t (:default "libsrng")))

(use-foreign-library libsrng)

(defcfun "sample" :int (to :pointer))

(defun ffi-sample ()
  (with-foreign-pointer (value 8)
    (let ((rval (sample value)))
      (values
       (mem-ref value :double 0)
       (= rval 1)))))

(export 'ffi-sample)
