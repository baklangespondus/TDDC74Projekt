#lang racket
(require "cmd_store.rkt")
(require "presentation.rkt")

;; OK att läsa.

;; --- Uppg 1
#| Bortkommenterat 

(define my-UI 
  (new adventure-UI%
       [window-name "ONE"]
       [width 500]
       [height 300]))

(define other-UI 
  (new adventure-UI%
       [window-name "TWO"]
       [width 400]
       [height 200]))

|#

;; ---- Uppg 2
#|
(send my-UI present "Text text")
(send my-UI present "En rad till")
(send other-UI present-no-lf "Vi presenterar: ")  ;; radbryt inte på slutet
(for-each
 (lambda (str)
   (send other-UI present-no-lf str))
 '("hunden, " "katten, " "glassen"))
(send other-UI present ".")

|#

;; ---- Uppg 3
#|
 (send my-UI set-place-name "Sjumilaskogen")
|#


;; ---- Uppg 4
#|
(define third-UI
  (new adventure-UI%
       [window-name "THREE"]
       [width 500]
       [height 300]
       [handle-input
        (lambda (this-ui command arguments)
          (printf "~a, ~a~n" command arguments))]))  ;; som test, skriv ut i interaktionsfönstret
|#

;; ---- Uppg 5

#|
(define my-UI
  (new adventure-UI%
       [window-name "THREE"]
       [width 500]
       [height 300]
       [handle-input
        (lambda (this-ui command arguments)
          (send this-ui present-no-lf command)
          (send this-ui present-no-lf " : ")
          (send this-ui present (string-join arguments)))]))


;; string-join eftersom arguments kommer att vara en lista. Det present vill ha
;; är en sträng.

|#


;; ---- Uppg 6
(define first-UI
  (new adventure-UI%
       [window-name "ONE"]
       [width 500]
       [height 300]
       [handle-input
        (lambda (this-ui command arguments)
          (send second-UI present-no-lf "<user 1> ")
          (send second-UI present-no-lf command)
          (send second-UI present-no-lf " ")
          (send second-UI present (string-join arguments)))]))

(define second-UI
  (new adventure-UI%
       [window-name "TWO"]
       [width 500]
       [height 300]
       [handle-input
        (lambda (this-ui command arguments)          
          (send first-UI present-no-lf "<user 2> ")
          (send first-UI present-no-lf command)
          (send first-UI present-no-lf " ")
          (send first-UI present (string-join arguments)))]))

;; alternativt kan vi se att det är en del kod-duplicering och skapa
(define (send-message from-user recipient command arguments)  
  (send recipient present-no-lf "<user 2> ")
  (send recipient present-no-lf command)
  (send recipient present-no-lf " ")
  (send recipient present (string-join arguments)))

#| och sedan ha varje anrop modell
[handle-input
 (lambda (this-ui command arguments) 
   (send-message "1" second-UI command arguments))]
|#

;; Vill man undvika upprepade send, vilket kan vara trevligt:
#|
(send recipient present
      (string-join
       (list "<user " from-user "> "
             command
             (string-join arguments)))))
|#



;; ------ Uppg 7
(define (echo-args this-ui arguments)
  (send this-ui present (string-join arguments)))

;; Det intressanta här är formatet. Vi kommer alltid att ha ett enhetligt
;; (this-ui arguments) som argument åt varje procedur i spelet.


;; ------ Uppg 8

(add-command! "echo" echo-args)
(define third-UI
  (new adventure-UI%
       [window-name "THREE"]
       [width 600]
       [height 250]
       [handle-input
        (lambda (this-ui command arguments)
          ((get-procedure "echo") this-ui arguments))]))


;; ------ Uppg 9
(define (handle-input_ this-ui command arguments)
  (cond
    [(valid-command? command) ((get-procedure command) this-ui arguments)]
    [else
     (send this-ui present-no-lf "Invalid command: ")
     (send this-ui present command)]))

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

(define fourth-UI
  (new adventure-UI%
       [window-name "FOUR"]
       [width 300]
       [height 500]
       [handle-input handle-input_]))

