#lang racket/gui

(define gamewindow
  (new frame%
       [label "Fönster"]
       [width 800]
       [height 800]))
(send gamewindow show #t)

(define empty-bitmap (make-object bitmap% 300 300))

(define thedc (new bitmap-dc%
                   [bitmap empty-bitmap]))

(send thedc draw-rectangle 100 100 100 100)

(define (drawing-proc2 canvas dc)
  (let ((our-picture (make-object bitmap% "test.png")))
    (send dc draw-bitmap our-picture 50 50))
  (send dc draw-bitmap empty-bitmap 100 100))

(define gamecanvas (new canvas%
                        [parent gamewindow]
                        [paint-callback drawing-proc2]))

(define (button-proc button event)
  (begin (send button set-label "klick fungerade!")
  (send thedc draw-rectangle 100 100 200 200)))

(define button (new button%
                    [parent gamewindow]
                    [label "En knapp"]
                    [callback button-proc]))


(define (drawing-proc1 canvas dc)
  (send dc set-font (make-object font% 20 'default))
  (send dc draw-text "Detta är text" 250 250)
  (send dc set-brush "red" 'solid)
  (send dc set-pen "blue" 2 'long-dash)
  (send dc draw-rectangle 100 100 100 100))

(big-bang start-state
  [on-key action]