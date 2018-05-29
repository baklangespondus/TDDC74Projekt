#lang racket
(require "item.rkt")
(require "character.rkt")
(require "place.rkt")

;;Places
(define java-cafe
  (new place%
       [name "Java"]
       [desc "Of all the cafes in this world..."]))

(define java-restaurant
  (new place%
       [name "Java-restuarant"]
       [desc "Of all the places in this world..."]))

(define java
  (new place%
       [name "Java-brothel"]
       [desc "Of all the places in this world..."]))

;;Items
(define fedora
  (new item%
       [name "Fedora"]
       [desc "m'lady"]))

(define internationalen
  (new item%
       [name "Internationalen CD"]
       [desc "Jespers favorite song"]))

(define choker
  (new item%
       [name "choker"]
       [desc "Blackbelt prostitute"]))

(define neckpain
  (new item%
       [name "Pain"]
       [desc "Horrible pain"]))

(define svisk
  (new item%
       [name "svisk"]
       [desc "Mythical svisk from the deep forest"]))

(define HB
  (new item%
       [name "Moonshine"]
       [desc "From a source in bergslagen"]))

(define backshot
  (new item%
       [name "Lumbago"]
       [desc "Can be used in dire situations"]))

;;Characters
(define dog
  (new character%
       [name "Nazi-dog"]
       [desc "This dog hates you"]
       [inventory (list choker neckpain)]
       [foodpref "losers"]
       [talk-line "Barkenbork"]
       [place java-cafe]))

(define bangladeshu
  (new character%
       [name "Harkensork"]
       [desc "It’s really a shark."]
       [inventory (list svisk HB backshot)]
       [foodpref "Bens"]
       [talk-line "Svaskenkirk, sabaroo!"]
       [place java-cafe]))

(define aspkiddo
  (new character%
       [name "Jesper"]
       [desc "Quite nice young lad, can't tell left from right."]
       [inventory (list fedora internationalen)]
       [foodpref "Beans, Eggs & T"]
       [talk-line "REEEEE"]))

(send java-cafe add-character! dog)
(send java-cafe add-neighbour! "up" java-restaurant)
(send java-cafe add-neighbour! "down" java)
