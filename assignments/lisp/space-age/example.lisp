(defpackage #:space-age
  (:use :common-lisp))

(in-package :space-age)

(defvar +earth-period+ 31557600)

(defvar +planets-and-periods+
  '((:mercury #.(* 0.2408467 +earth-period+))
    (:venus #. (* 0.61519726 +earth-period+))
    (:earth #.(* 1 +earth-period+))
    (:mars #.(* 1.8808158 +earth-period+))
    (:jupiter #.(* 11.862615 +earth-period+))
    (:saturn #.(* 29.447498 +earth-period+))
    (:uranus #.(* 84.016846 +earth-period+))
    (:neptune #.(* 164.79132 +earth-period+))))

(dolist (planet-info +planets-and-periods+)
  (let ((name (first planet-info))
	(period (second planet-info)))
    (let ((symbol (intern (string-upcase 
			   (concatenate 'string  
					"on-"
					(string name))))))
      (setf (symbol-function symbol)
	    #'(lambda (seconds) (/ seconds period)))
      (export symbol))))

