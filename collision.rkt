#lang racket
(require "player.rkt")
(provide (all-defined-out))

(define (collision)
  (begin (hash-set! i-x p1
                    `(,(+ (car (send p1 get-pos)) 5)
                      ,(+ (car (send p1 get-pos)) (send p1 get-sizex) -5)))
         (hash-set! i-x p2
                    `(,(+ (car (send p2 get-pos)) 5)
                      ,(+ (car (send p2 get-pos)) (send p2 get-sizex) -5)))
         (hash-set! i-y p1
                    `(,(+ (cadr (send p1 get-pos)) 5)
                      ,(+ (cadr (send p1 get-pos)) (send p1 get-sizey) -5)))
         (hash-set! i-y p2
                    `(,(+ (cadr (send p2 get-pos)) 5)
                      ,(+ (cadr (send p2 get-pos)) (send p2 get-sizey) -5)))
         
         ;         (when (and (between? (hash-ref i-x p1) (car (hash-ref i-x p2)))
         ;                    (or (between? (hash-ref i-y p1) (car (hash-ref i-y p2)))
         ;                        (between? (hash-ref i-y p1) (cadr (hash-ref i-y p2)))))
         ;           (if (< (send p1 get-health) (send p2 get-health))
         ;               (send p2 set-pos! (cadr (hash-ref i-x p1)) (car (hash-ref i-y p2)))
         ;               (send p1 set-pos! (car (hash-ref i-x p2)) (car (hash-ref i-y p1)))))
         (master-when p1 p2 i-x (< (send p1 get-health) (send p2 get-health)) car -)
         (master-when p1 p2 i-x (< (send p1 get-health) (send p2 get-health)) cadr +)
         (master-when p1 p2 i-y #f car +) ;p1-up p2-down
         (master-when p2 p1 i-y #t car +))) ;p1-down p2-up
;(master-when p1 p2 i-y car)
;(master-when p1 p2 i-y cadr))) ;p1-right p2-left


(define i-x (make-hash))
(define i-y (make-hash))

(define (between? interval number)
  (and (<= number (cadr interval)) (>= number (car interval))))

(define (master-when object1 object2 hash req? car? sign)
  (let ((otherside (if (equal? hash i-x) i-y
                       i-x))
        (othercar (if (equal? car? car) cadr
                      car))
        (othersign (if (equal? sign +) - +)))
    (when (and (between? (hash-ref hash object1)
                         (car? (hash-ref hash object2)))
               (or (between? (hash-ref otherside object1)
                             (car (hash-ref otherside object2)))
                   (between? (hash-ref otherside object1)
                             (cadr (hash-ref otherside object2)))))
      (if req?
          (send object2 set-pos! (othersign (car (hash-ref hash object2)) 2) (car (hash-ref otherside object2)))
          (send object1 set-pos! (sign (car (hash-ref hash object1)) 2) (car (hash-ref otherside object1)))))))

;(master-when p1 p2 i-y #f car) ;p1-up p2-down
;(master-when p1 p2 i-y #f cadr))) ;p1-down p2-up

;         (when (and (between? (hash-ref i-x p1) (cadr (hash-ref i-x p2)))
;                    (or (between? (hash-ref i-y p1) (cadr (hash-ref i-y p2)))
;                        (between? (hash-ref i-y p1) (car (hash-ref i-y p2)))))
;           (display "right"));p1-right p2-left
;         (when (and (between? (hash-ref i-y p1) (cadr (hash-ref i-y p2)))
;                    (or (between? (hash-ref i-x p1) (cadr (hash-ref i-x p2)))
;                        (between? (hash-ref i-x p1) (car (hash-ref i-x p2)))))
;           (display "down")) ;p1-down p2-up
;         (when (and (between? (hash-ref i-y p1) (car (hash-ref i-y p2)))
;                    (or (between? (hash-ref i-x p1) (cadr (hash-ref i-x p2)))
;                        (between? (hash-ref i-x p1) (car (hash-ref i-x p2)))))
;           (display "up")))) ;p1-up p2-down

;(define (collision-try)
;  (when (equal? (car (send p1 get-pos)) (car (send p2 get-pos)))
;      (display (send p1 get-pos))))