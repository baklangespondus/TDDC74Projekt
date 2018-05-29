#lang racket

(require racket/serialize)
(provide item%)

(define item%
  (class object%
    (init-field [name ""]
                [desc ""]
                [place #f]
                [key-item ""]
                [key-conseq '()])
  
    (define/public (get-name) name)
    (define/public (get-desc) desc)
    (define/public (get-place) place)

    (define/public (move-to new-place)
      (send new-place add-item! this)
      (send place remove-item! this)
      (set! place new-place))

    (define/public (key? name)
      (equal? name key-item))

    (define/public (get-usage) key-conseq)

    (super-new)))

