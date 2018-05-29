#lang racket
(require "cmd_store.rkt")
(require "world_init.rkt")
(provide (all-defined-out))

(define (look this-UI args)
  (send args get-desc))

(add-command! "look"
              (lambda (this-ui args)
                (cond
                  ((null? args)
                   (send this-ui present "You look and see"))

                  ((equal? (car args) "closer")
                   (send this-ui present
                         (string-append
                          "You look closer and see "
                          (string-join
                           (map (lambda (x) (send x get-name))
                                (send (send player get-place) get-items))))))
                             
                  ((equal? (car args) "around")
                   (send this-ui present
                         (string-join
                          (list "You look around you are at the "
                                (send (send player get-place) get-name)))))

                  ((equal? (car args) "out")
                   (send this-ui present
                         (string-join
                          (list "You look around and see the exits: "
                                (string-join
                                 (send (send player get-place) exits))))))

                  ((equal? (car args) "pocket")
                   (if (null? (send player get-inventory))
                       (send this-ui present "Some change, but not much more..")
                       (send this-ui present
                             (string-append
                              "You have:\n"
                              (string-join
                               (map (lambda (x) (send x get-name))
                                    (send player get-inventory)) "\n")))))

                  ((equal? (car args) "people")
                   (send this-ui present
                         (string-append
                          "You see people and their name is\n"
                          (string-join
                           (map (lambda (x) (send x get-name))
                                (send (send player get-place) characters)) "\n"))))

                  (else (send this-ui present
                              "invalid look, you can use look with \ncloser, around, pocket, out, people")))))
                             

(add-command! "echo"
              (lambda (this-ui args)
                (send this-ui present (string-append "user wrote: "
                                                     (string-join args)))))

(add-command! "go"
              (lambda (this-ui args)
                (if (send (send player get-place) get-neighbour (car args))
                    (begin (send player move-to
                                 (send (send player get-place)
                                       get-neighbour
                                       (car args)))
                           (send this-ui set-place-name (send (send player get-place) get-name)))
                    (send this-ui present
                          (string-append
                           "You can not go "
                           (string-join args))))))

(add-command! "drop"
              (lambda (this-ui args)
                (if (send player have-item? (car args))
                    (begin (send player give (car args) (send player get-place))
                           (send this-ui present
                                 (string-append
                                  "You dropped "
                                  (string-join args))))
                    (send this-ui present
                          (string-append
                           "You do not have "
                           (string-join args))))))

(define giving (lambda (this-ui args)
                (if (send player have-item? (car args))
                    (begin (if (send (send player get-item (car args)) key?
                                     (cadr args))
                          (begin (car (send (send player get-item (car args)) get-usage))
                                 (send this-ui present "things happend"))
                          #f)
                          (send player give (car args) (send (send player get-place)
                                                          get-character (cadr args)))
                           (send this-ui present
                                 (string-append
                                  "You gave "
                                  (car args) " to "
                                  (cadr args))))
                    (send this-ui present
                          (string-append
                           "You do not have "
                           (string-join args))))))

(add-command! "give" giving)
(add-command! "use" giving)
  

(add-command! "take"
              (lambda (this-ui args)
                (if (send (send player get-place) have-item? (car args))
                    (begin (send (send player get-place) give (car args) player)
                           (send this-ui present
                                 (string-append
                                  "You took "
                                  (string-join args))))
                    (send this-ui present
                          (string-append
                           "There is no "
                           (string-join args))))))

(add-command! "talk"
              (lambda (this-ui args)
                (send this-ui present
                      (send (send
                             (send player get-place)
                             get-character
                             (car args))
                            get-talk-line))))

(add-command! "greet"
              (lambda (this-ui args)
                (send this-ui present "You say: Hi!")))

(add-command! "dance"
              (lambda (this-ui args)
                (send this-ui present
                      (string-join
                       (list "You dance "
                             (string-join args)
                             ".")
                       ""))))

(add-command! "help" (lambda (this-ui args)
                       (send this-ui present
                             (string-append "you can: \n"
                                            (string-join (get-valid-commands)) "\n"))))