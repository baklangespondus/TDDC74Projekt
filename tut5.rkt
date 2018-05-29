#lang racket
(require "presentation.rkt")
(require "cmd_store.rkt")
(require "world_init.rkt")
(require "player_commands.rkt")


(define Handle_input (lambda (this-UI command arguments)
                       (if (valid-command? command)
                           ((get-procedure command) this-UI arguments)
                           (send this-UI present
                                 (string-append
                                  command " is an invalid input")))))
(define game-window
  (new adventure-UI%
       [window-name "Window 1"]
       [height 500]
       [width 300]
       [place-name "Tub"]
       [handle-input Handle_input]))

;(define third-UI
;  (new adventure-UI%
;       [window-name "THREE"]
;       [width 600]
;       [height 250]
;       [handle-input
;        (lambda (this-ui command arguments)
;          ((get-procedure "echo") this-ui arguments))]))
                                 
;
;(define game-window2
;  (new adventure-UI%
;       [window-name "Window 2"]
;       [height 400]
;       [width 200]))

(define (echo-args this-ui arguments)
  (send this-ui present (string-append "user wrote: " (string-join arguments))))

(add-command! "echo" echo-args)

(add-command! "ask" (lambda (this-UI argument)
                      (send (car argument) give (car (last argument)))))

(add-command! "hi" (lambda (this-UI argument) (send this-UI present "hi")))

(add-command! "greet"
              (lambda (this-ui arguments)
                (send this-ui present "You say: HI!")))
(add-command! "dance"
              (lambda (this-ui arguments)
                (send this-ui present
                      (string-join
                       (list "You dance "
                             (string-join arguments)
                             ".")
                       ""))))
(add-command! "look" (lambda (this-ui arguments)
                       (send this-ui present
                             (string-join
                              (list "You look around you are at the "
                                    
                                    (send this-ui place-name)
                                    )))))