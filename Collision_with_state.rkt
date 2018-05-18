#lang racket
(require "main.rkt")
(provide (all-defined-out))
(struct playerxy (left right up down))


(define collide? (make-hash))
(hash-set! collide? "p1p2" #f)
(hash-set! collide? p1 #f)
(hash-set! collide? p2 #f)

(define p1xy 0)
(define p2xy 0)
(define plat1xy (playerxy (- (car  (send plat1 get-pos))  (/ (send plat1 get-sizex) 2))
                          (+ (car  (send plat1 get-pos))  (/ (send plat1 get-sizex) 2))
                          (- (cadr (send plat1 get-pos))  (/ (send plat1 get-sizey) 2))
                          (+ (cadr (send plat1 get-pos))  (/ (send plat1 get-sizey) 2))))

(define plat2xy (playerxy (- (car  (send plat2 get-pos))  (/ (send plat2 get-sizex) 2))
                          (+ (car  (send plat2 get-pos))  (/ (send plat2 get-sizex) 2))
                          (- (cadr (send plat2 get-pos))  (/ (send plat2 get-sizey) 2))
                          (+ (cadr (send plat2 get-pos))  (/ (send plat2 get-sizey) 2))))

(define walllxy (playerxy (- (car  (send walll get-pos))  (/ (send walll get-sizex) 2))
                          (+ (car  (send walll get-pos))  (/ (send walll get-sizex) 2))
                          (- (cadr (send walll get-pos))  (/ (send walll get-sizey) 2))
                          (+ (cadr (send walll get-pos))  (/ (send walll get-sizey) 2))))

(define wallrxy (playerxy (- (car  (send wallr get-pos))  (/ (send wallr get-sizex) 2))
                          (+ (car  (send wallr get-pos))  (/ (send wallr get-sizex) 2))
                          (- (cadr (send wallr get-pos))  (/ (send wallr get-sizey) 2))
                          (+ (cadr (send wallr get-pos))  (/ (send wallr get-sizey) 2))))

(define wallupxy (playerxy (- (car  (send wallup get-pos))  (/ (send wallup get-sizex) 2))
                           (+ (car  (send wallup get-pos))  (/ (send wallup get-sizex) 2))
                           (- (cadr (send wallup get-pos))  (/ (send wallup get-sizey) 2))
                           (+ (cadr (send wallup get-pos))  (/ (send wallup get-sizey) 2))))



(define (between? y-side x-side player platform)
  (and (<= (y-side player) (playerxy-down platform))
       (>= (y-side player) (playerxy-up platform))
       (<= (x-side player) (playerxy-right platform))
       (>= (x-side player) (playerxy-left platform))))

(define (collision state)
  (let ((p1xy (playerxy (caar state) (+ (caar state) (send p1 get-sizex))
                        (cadar state) (+ (cadar state) (send p1 get-sizey))))
        (p2xy (playerxy (caadr state) (+ (caadr state) (send p2 get-sizex))
                        (cadadr state) (+ (cadadr state) (send p2 get-sizey)))))
    (cond ((between? playerxy-up playerxy-left p2xy p1xy) ;;p1-down-right p2-up-left
           (begin (hash-set! collide? "p1p2" #t)
                  (collision-p1 `((,(- (playerxy-left p1xy) (+ 2 (abs (car (send p1 get-speed)))))
                                   ,(- (playerxy-up p1xy) (+ 2 (abs (cadr (send p1 get-speed))))))
                                  (,(playerxy-left p2xy)
                                   ,(playerxy-up p2xy))))))
               
          ((between? playerxy-up playerxy-right p2xy p1xy) ;;p1-down-left p2-up-right
           (begin (hash-set! collide? "p1p2" #t)
                  (collision-p1 `((,(+ (playerxy-left p1xy) (+ 2 (abs (car (send p1 get-speed)))))
                                   ,(- (playerxy-up p1xy) (+ 2 (abs (cadr (send p1 get-speed))))))
                                  (,(playerxy-left p2xy)
                                   ,(playerxy-up p2xy))))))
               
          ((between? playerxy-down playerxy-left p2xy p1xy) ;;p1-up-right p2-down-left
           (begin (hash-set! collide? "p1p2" #t)
                  (collision-p1 `((,(playerxy-left p1xy)
                                   ,(playerxy-up p1xy))
                                  (,(+ (playerxy-left p2xy) (+ 2 (abs (car (send p2 get-speed)))))
                                   ,(- (playerxy-up p2xy) (+ 2 (abs (cadr (send p2 get-speed))))))))))
               
          ((between? playerxy-down playerxy-right p2xy p1xy) ;;p1-up-left p2-down-right
           (begin (hash-set! collide? "p1p2" #t)
                  (collision-p1 `((,(playerxy-left p1xy)
                                   ,(playerxy-up p1xy))
                                  (,(- (playerxy-left p2xy) (+ 2 (abs (car (send p2 get-speed)))))
                                   ,(- (playerxy-up p2xy) (+ 2 (abs (cadr (send p2 get-speed))))))))))
          (else (begin (hash-set! collide? "p1p2" #f)
                       (collision-p1 state))))))


(define (collision-p1 state)
  (let ((p1xy (playerxy (caar state) (+ (caar state) (send p1 get-sizex))
                        (cadar state) (+ (cadar state) (send p1 get-sizey))))
        (p2xy (playerxy (caadr state) (+ (caadr state) (send p2 get-sizex))
                        (cadadr state) (+ (cadadr state) (send p2 get-sizey)))))
    (cond ;;Player 1's actions
      ((between? playerxy-down playerxy-left p1xy plat1xy) ;;p1-down-left plat1
       (begin (when (not (hash-ref collide? p1)) (send p1 set-speedy-super! 0))
              (hash-set! collide? p1 #t)
              (collision-p2 `((,(playerxy-left p1xy)
                               ,(playerxy-up p1xy))
                              (,(playerxy-left p2xy)
                               ,(playerxy-up p2xy))))))

      ((between? playerxy-down playerxy-right p1xy plat1xy) ;;p1-down-right plat1
       (begin (when (not (hash-ref collide? p1)) (send p1 set-speedy-super! 0))
              (hash-set! collide? p1 #t)
              (collision-p2 `((,(playerxy-left p1xy)
                               ,(playerxy-up p1xy))
                              (,(playerxy-left p2xy)
                               ,(playerxy-up p2xy))))))
 
      ((between? playerxy-up playerxy-left p1xy plat1xy) ;;p1-up-left plat1
       (collision-p2 `((,(playerxy-left p1xy)
                        ,(+ (playerxy-up p1xy) (+ 2 (abs (cadr (send p2 get-speed))))))
                       (,(playerxy-left p2xy)
                        ,(playerxy-up p2xy)))))

      ((between? playerxy-up playerxy-right p1xy plat1xy) ;;p1-up-right plat1
       (collision-p2 `((,(playerxy-left p1xy)
                        ,(+ (playerxy-up p1xy) (+ 2 (abs (car (send p2 get-speed))))))
                       (,(playerxy-left p2xy)
                        ,(playerxy-up p2xy)))))

      ((between? playerxy-down playerxy-left p1xy plat2xy) ;;p1-down-left plat2
       (begin (send p1 set-health! 0)
              (hash-set! collide? p1 #t)
              (collision-p2 
               `((,(playerxy-left p1xy)
                  ,(playerxy-up p1xy))
                 (,(playerxy-left p2xy)
                  ,(playerxy-up p2xy))))))

      ((between? playerxy-down playerxy-right p1xy plat2xy) ;;p1-down-right plat2
       (begin (send p1 set-health! 0)
              (hash-set! collide? p1 #t)
              (collision-p2 
               `((,(playerxy-left p1xy)
                  ,(playerxy-up p1xy))
                 (,(playerxy-left p2xy)
                  ,(playerxy-up p2xy))))))

      ((between? playerxy-down playerxy-right p1xy walllxy) ;;p1-down-left walll
       (collision-p2 `((,(- (playerxy-left p1xy) (+ 2 (abs (car (send p1 get-speed)))))
                        ,(playerxy-up p1xy))
                       (,(playerxy-left p2xy)
                        ,(playerxy-up p2xy)))))
 
      ((between? playerxy-down playerxy-left p1xy wallrxy) ;;p1-down-right wallr
       (collision-p2 `((,(+ (playerxy-left p1xy) (+ 2 (abs (car (send p1 get-speed)))))
                        ,(playerxy-up p1xy))
                       (,(playerxy-left p2xy)
                        ,(playerxy-up p2xy)))))

      ((between? playerxy-up playerxy-right p1xy wallupxy) ;;p1-up-right wallup
       (collision-p2 `((,(playerxy-left p1xy)
                        ,(+ (playerxy-up p1xy) (+ 2 (abs (cadr (send p1 get-speed))))))
                       (,(playerxy-left p2xy)
                        ,(playerxy-up p2xy)))))

      ((between? playerxy-down playerxy-left p1xy plat2xy) ;;p1-down-left plat2
       (begin (send p1 set-health! 0)
              (hash-set! collide? p1 #t)
              (collision-p2 
               `((,(playerxy-left p1xy)
                  ,(playerxy-up p1xy))
                 (,(playerxy-left p2xy)
                  ,(playerxy-up p2xy))))))
      (else (begin (hash-set! collide? p1 #f) (collision-p2 state))))))

(define (collision-p2 state)
  (let ((p1xy (playerxy (caar state) (+ (caar state) (send p1 get-sizex))
                        (cadar state) (+ (cadar state) (send p1 get-sizey))))
        (p2xy (playerxy (caadr state) (+ (caadr state) (send p2 get-sizex))
                        (cadadr state) (+ (cadadr state) (send p2 get-sizey)))))
    (cond ;;Player2's actions
      ((between? playerxy-down playerxy-right p2xy plat2xy) ;;p2-down-right plat2
       (begin (send p2 set-health! 0)
              (hash-set! collide? p2 #t)
              `((,(playerxy-left p1xy)
                 ,(playerxy-up p1xy))
                (,(playerxy-left p2xy)
                 ,(playerxy-up p2xy)))))
  
      ((between? playerxy-down playerxy-left p2xy plat2xy) ;;p2-down-left plat2
       (begin (send p2 set-health! 0)
              (hash-set! collide? p2 #t)
              `((,(playerxy-left p1xy)
                 ,(playerxy-up p1xy))
                (,(playerxy-left p2xy)
                 ,(playerxy-up p2xy)))))
  
      ((between? playerxy-up playerxy-right p2xy plat1xy) ;;p2-up-right plat1
       `((,(playerxy-left p1xy)
          ,(playerxy-up p1xy))
         (,(playerxy-left p2xy)
          ,(+ (playerxy-up p2xy) (+ 2 (abs (car (send p2 get-speed))))))))
  
      ((between? playerxy-up playerxy-left p2xy plat1xy) ;;p2-up-left plat1
       `((,(playerxy-left p1xy)
          ,(playerxy-up p1xy))
         (,(playerxy-left p2xy)
          ,(+ (playerxy-up p2xy) (+ 2 (abs (car (send p2 get-speed))))))))
  
      ((between? playerxy-down playerxy-right p2xy plat1xy) ;;p2-down-right plat1
       (begin (when (not (hash-ref collide? p2)) (send p2 set-speedy-super! 0))
              (hash-set! collide? p2 #t)
              `((,(playerxy-left p1xy)
                 ,(playerxy-up p1xy))
                (,(playerxy-left p2xy)
                 ,(playerxy-up p2xy)))))
           
      ((between? playerxy-down playerxy-left p2xy plat1xy) ;;p2-down-left plat1
       (begin (when (not (hash-ref collide? p2)) (send p2 set-speedy-super! 0))
              (hash-set! collide? p2 #t)
              `((,(playerxy-left p1xy)
                 ,(playerxy-up p1xy))
                (,(playerxy-left p2xy)
                 ,(playerxy-up p2xy)))))
      (else (begin (hash-set! collide? p2 #f)
                   state)))))



