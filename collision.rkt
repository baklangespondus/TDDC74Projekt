#lang racket
(require "player.rkt")
(provide (all-defined-out))

(define (collision)
  (begin (hash-set! i-x p1
                    `(,(car (send p1 get-pos))
                      ,(+ (car (send p1 get-pos)) (send p1 get-sizex))))
         (hash-set! i-x p2
                    `(,(car (send p2 get-pos))
                      ,(+ (car (send p2 get-pos)) (send p2 get-sizex))))
         (hash-set! i-y p1
                    `(,(cadr (send p1 get-pos))
                      ,(+ (cadr (send p1 get-pos)) (send p1 get-sizey))))
         (hash-set! i-y p2
                    `(,(cadr (send p2 get-pos))
                      ,(+ (cadr (send p2 get-pos)) (send p2 get-sizey))))
         
         (when (and (between? (hash-ref i-x p1) (car (hash-ref i-x p2)))
                    (or (between? (hash-ref i-y p1) (car (hash-ref i-y p2)))
                        (between? (hash-ref i-y p1) (cadr (hash-ref i-y p2)))))
           (display "hi"));p1-right p2-left

         (when (and (between? (hash-ref i-x p1) (cadr (hash-ref i-x p2)))
                    (or (between? (hash-ref i-y p1) (cadr (hash-ref i-y p2)))
                        (between? (hash-ref i-y p1) (car (hash-ref i-y p2)))))
           (display "bye"))));p1-left p2-right
;(define (collision-try)
;  (when (equal? (car (send p1 get-pos)) (car (send p2 get-pos)))
;      (display (send p1 get-pos))))

(define i-x (make-hash))
(define i-y (make-hash))

(define (between? interval number)
  (and (<= number (cadr interval)) (>= number (car interval))))

