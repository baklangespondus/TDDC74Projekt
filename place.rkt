#lang racket

(require racket/serialize)
(provide place%)

(define place%
  (class object%
    (init-field [name ""]
                [desc ""]
                [character-list '()]
                [exit '()]
                [items '()])
  
    (define/public (get-name) name)
    (define/public (get-desc) desc)
    (define/public (characters) character-list)
    (define/public (add-item! item-name) (set! items (cons item-name items)))
    (define/public (remove-item! item-name) (set! items(remove item-name items)))
    (define/public (exits) (map (lambda (x) (car x)) exit))
    (define/public (get-items) items)
    
    (define/public (get-item item-name)
      (ormap (lambda (x) (if (equal? (send x get-name) item-name)
                             x
                             #f))items))

    (define/public (have-item? item-name)
      (ormap (lambda (x) (equal? (send x get-name) item-name)) items))
    
    (define/public (recieve item-name)
      (set! items (cons item-name items)))
    
    (define/public (give item-name reciever)
      (ormap (lambda (x) (equal? x item-name)
               (begin (send reciever recieve x)
                      (set! items (remove x items)))) items))
    
    (define/public (get-character character-name)
      (ormap (lambda (x) (if (equal? (send x get-name) character-name)
                             x
                             #f)) character-list))

    (define/public (add-character! character)
      (set! character-list (cons character character-list)))

    (define/public (remove-character! character-name)
      (set! character-list (remove character-name character-list)))

    (define/public (get-neighbour exit-name)
      (ormap (lambda (x) (if (equal? (car x) exit-name)
                             (cdr x)
                             #f)) exit))

    (define/public (add-neighbour! exit-name place)
      (set! exit (cons (cons exit-name place) exit)))

    (define/public (connect-places! exit1 place2 exit2)
      (add-neighbour! exit1 place2)
      (send place2 add-neighbour! exit2 this))

    (define/public (remove-neighbour! exit-name)
      (ormap (lambda (x) (if (equal? (car x) exit-name)
                             (set! exit (remove x exit))
                             #f)) exit))
    ;      (set! exit (remove (get-neighbour exit-name) exit))
    ;     (set! exit (remove exit-name exit)))
    
    (define/public (neighbours)
      (map (lambda (x) (send (cdr x) get-name)) exit))
      
    (super-new)))