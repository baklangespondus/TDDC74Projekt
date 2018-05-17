#lang racket
(require "player.rkt")
(require "platform.rkt")
(require "main.rkt")
;(provide (all-defined-out))

(define (collision)
  (begin (set! i-x (make-hash))
         (set! i-y (make-hash))
         (hash-set! i-x p1 ;var p1
                    `(,(- (car (send p1 get-pos)) (/ (send p1 get-sizex) 2) (car (send p1 get-speed)))
                      ,(+ (car (send p1 get-pos)) (/ (send p1 get-sizex) 2) (car (send p1 get-speed)))))
         (hash-set! i-y p1
                    `(,(+ (cadr (send p1 get-pos)) (/ (send p1 get-sizey) 2) (cadr (send p1 get-speed)))
                      ,(- (cadr (send p1 get-pos)) (/ (send p1 get-sizey) 2) (cadr (send p1 get-speed)))))
         
         (hash-set! i-x p2
                    `(,(- (car (send p2 get-pos)) (/ (send p2 get-sizex) 2) (car (send p2 get-speed)))
                      ,(+ (car (send p2 get-pos)) (/ (send p2 get-sizex) 2) (car (send p2 get-speed)))))
         (hash-set! i-y p2
                    `(,(+ (cadr (send p2 get-pos)) (/ (send p2 get-sizey) 2) (cadr (send p2 get-speed)))
                      ,(- (cadr (send p2 get-pos)) (/ (send p2 get-sizey) 2) (cadr (send p2 get-speed)))))
         
         (hash-set! i-x plat1
                    `(,(- (car (send plat1 get-pos)) (/ (send plat1 get-sizex) 2))
                      ,(+ (car (send plat1 get-pos)) (/ (send plat1 get-sizex) 2))))
         (hash-set! i-y plat1
                    `(,(+ (cadr (send plat1 get-pos)) (/ (send plat1 get-sizey) 2))
                      ,(- (cadr (send plat1 get-pos)) (/ (send plat1 get-sizey) 2))))
         
         (hash-set! i-x plat2
                    `(,(- (car (send plat2 get-pos)) (/ (send plat2 get-sizex) 2))
                      ,(+ (car (send plat2 get-pos)) (/ (send plat2 get-sizex) 2))))
         (hash-set! i-y plat2
                    `(,(- (cadr (send plat2 get-pos)) (/ (send plat2 get-sizey) 2))
                      ,(+ (cadr (send plat2 get-pos)) (/ (send plat2 get-sizey) 2))))
         (master-when p1 p2 i-x (< (send p1 get-health) (send p2 get-health)) car -)
         (master-when p1 p2 i-x (< (send p1 get-health) (send p2 get-health)) cadr -)
         (master-when p1 p2 i-y #f car -) ;p1-up p2-down
         (master-when p1 p2 i-y #f cadr +)
         (master-when plat1 p1 i-x #f car -)
         (master-when plat1 p1 i-x #f cadr -)
         (master-when plat1 p1 i-y #t car -)
         (master-when plat1 p1 i-y #t cadr +)));p1-down p2-up

;(master-when p1 p2 i-y car)
;(master-when p1 p2 i-y cadr))) ;p1-right p2-left

(define i-x (make-hash))
(define i-y (make-hash))

(hash-set! i-x p1
           `(,(- (car (send p1 get-pos)) (/ (send p1 get-sizex) 2))
             ,(+ (car (send p1 get-pos)) (/ (send p1 get-sizex) 2))))
(hash-set! i-x p2
           `(,(- (car (send p2 get-pos)) (/ (send p2 get-sizex) 2))
             ,(+ (car (send p2 get-pos)) (/ (send p2 get-sizex) 2))))
(hash-set! i-y p1
           `(,(- (cadr (send p1 get-pos)) (/ (send p1 get-sizey) 2))
             ,(+ (cadr (send p1 get-pos)) (/ (send p1 get-sizey) 2))))
(hash-set! i-y p2
           `(,(- (cadr (send p2 get-pos)) (/ (send p2 get-sizey) 2))
             ,(+ (cadr (send p2 get-pos)) (/ (send p2 get-sizey) 2))))


(define collide? (make-hash))
(hash-set! collide? p1 #f)
(hash-set! collide? p2 #f)
(define (between? interval number)
  (and (<= number (cadr interval)) (>= number (car interval))))

(define (master-when object1 object2 hash req? car? sign)
  (let ((otherside (if (equal? hash i-x) i-y
                       i-x))
        (othersign (if (equal? sign +) - +)))
    (if (and (between? (hash-ref hash object1)
                       (car? (hash-ref hash object2)))
             (or (between? (hash-ref otherside object1)
                           (car (hash-ref otherside object2)))
                 (between? (hash-ref otherside object1)
                           (cadr (hash-ref otherside object2)))))
        (begin (hash-set! collide? object1 #t)
               (hash-set! collide? object2 #t)
               (if req?
                   (send object2 set-pos! (othersign (car (send object2 get-pos))
                                                     (* 1.1 (car (send object2 get-speed))))
                         (othersign (cadr (send object2 get-pos))
                                    (cadr (send object2 get-speed))))
                   (send object1 set-pos! (sign (car (send object1 get-pos))
                                                (* 1.1 (car (send object1 get-speed))))
                         (sign (cadr (send object1 get-pos))
                               (cadr (send object1 get-speed))))))
        (begin (hash-set! collide? object1 #f)
               (hash-set! collide? object2 #f)))))
