#lang racket

(require racket/serialize)
(require racket/trace)
(require "place.rkt")
(provide character%)

(define character%
  (class object%
    (init-field [name ""]
                [desc ""]
                [foodpref ""]
                [place '()]
                [inventory '()]
                [talk-line ""])
  (send place add-character! this)
    (define/public (get-name) name)
    (define/public (get-desc) desc)
    (define/public (get-place) place)
    (define/public (get-food) foodpref)
    (define/public (get-inventory) inventory)
    (define/public (get-talk-line) talk-line)

    (define/public (move-to new-place)
      (send new-place add-character! this)
      (send place remove-character! this)
      (set! place new-place))
    
    (define/public (have-item? item-name)
      (ormap (lambda (x) (equal? (send x get-name) item-name)) inventory))

    (define/public (get-item item-name)
      (ormap (lambda (x) (if (equal? (send x get-name) item-name)
                             x
                             #f)) inventory))
    
    (define/public (recieve item-name)
      (set! inventory (cons item-name inventory)))
    
    (define/public (give item-name reciever)
      (ormap (lambda (x) (if (equal? (send x get-name) item-name)
                             (begin (set! inventory (remove x inventory))
                                    (send reciever recieve x))
                             #f)) inventory))
      
    (super-new)))
