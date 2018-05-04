#lang racket

(require racket/serialize)
(require racket/trace)
(provide platform%)

(define platform%
  (class object%
    (init-field 
                [location '()])
    (super-new)))