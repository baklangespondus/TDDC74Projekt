#lang racket

(require "presentation.rkt")
(require "cmd_store.rkt")
(require "world_init.rkt")
(require "player_commands.rkt")


(define Handle_input (lambda (this-UI command arguments)
                       (if (valid-command? (string-downcase command))
                           ((get-procedure command) this-UI (map (lambda (x) (string-downcase x)) arguments))
                           (send this-UI present
                                 (string-append
                                  command " is an invalid input")))))
(define game-window
  (new adventure-UI%
       [window-name "Window 1"]
       [height 500]
       [width 300]
       [place-name "       Tub       "]
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