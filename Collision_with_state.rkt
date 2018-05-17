#lang racket
(require "main.rkt")
(provide (all-defined-out))
(struct playerxy (left right up down))

(define p1xy 0)
(define p2xy 0)
(define collide? (make-hash))
(hash-set! collide? p1 #f)
(hash-set! collide? p2 #f)

(define (collision state)
  (begin (set! p1xy (playerxy (caar state) (+ (caar state) (send p1 get-sizex))
                              (cadar state) (+ (cadar state) (send p1 get-sizey))))
         (set! p2xy (playerxy (caadr state) (+ (caadr state) (send p2 get-sizex))
                              (cadadr state) (+ (cadadr state) (send p2 get-sizey))))

         (cond ((and (<= (playerxy-up p2xy) (playerxy-down p1xy))
                     (>= (playerxy-up p2xy) (playerxy-up p1xy))
                     (<= (playerxy-left p2xy) (playerxy-right p1xy))
                     (>= (playerxy-left p2xy) (playerxy-left p1xy)))
                
                `((,(- (playerxy-left p1xy) (+ 2 (abs (car (send p1 get-speed)))))
                   ,(- (playerxy-up p1xy) (+ 2 (abs (cadr (send p1 get-speed))))))
                  (,(playerxy-left p2xy)
                   ,(playerxy-up p2xy))))
               
               ((and (<= (playerxy-up p2xy) (playerxy-down p1xy))
                     (>= (playerxy-up p2xy) (playerxy-up p1xy))
                     (<= (playerxy-right p2xy) (playerxy-right p1xy))
                     (>= (playerxy-right p2xy) (playerxy-left p1xy)))
                
                `((,(+ (playerxy-right) (+ 2 (abs (car (send p1 get-speed)))))
                   ,(- (playerxy-up) (+ 2 (abs (cadr (send p1 get-speed))))))
                  (,(playerxy-right p2xy)
                   ,(playerxy-up p2xy))))
               
               ((and (<= (playerxy-down p2xy) (playerxy-down p1xy))
                     (>= (playerxy-down p2xy) (playerxy-up p1xy))
                     (<= (playerxy-left p2xy) (playerxy-right p1xy))
                     (>= (playerxy-left p2xy) (playerxy-left p1xy)))
                
                `(,(playerxy-left p2xy)
                  ,(playerxy-up p2xy)
                  ,(+ (playerxy-left) (+ 2 (abs (car (send p2 get-speed)))))
                  ,(- (playerxy-up) (+ 2 (abs (cadr (send p2 get-speed)))))))
               
               ((and (<= (playerxy-down p2xy) (playerxy-down p1xy))
                     (>= (playerxy-down p2xy) (playerxy-up p1xy))
                     (<= (playerxy-right p2xy) (playerxy-right p1xy))
                     (>= (playerxy-right p2xy) (playerxy-left p1xy)))
                
                `(,(playerxy-left p2xy)
                  ,(playerxy-up p2xy)
                  ,(- (playerxy-left) (+ 2 (abs (car (send p2 get-speed)))))
                  ,(- (playerxy-up) (+ 2 (abs (car (send p2 get-speed)))))))
               
               (else state))))
  
  
