#lang racket
(require "character.rkt")
(require "place.rkt")
(require "item.rkt")
(require "cmd_store.rkt")
(provide (all-defined-out))
;;Places
(define tub
  (new place%
       [name "A simple bathtub"]
       [desc "It's aerodynamic enough to be used as a car"]))

(define scrapyard
  (new place%
       [name "Scrapyard"]
       [desc "You see countless cars, none of them works.\n Maybe there is some parts that can be salvaged."]))

(define scraphut
  (new place%
       [name "A red house with a metal roof"]
       [desc "By the door you see a sign saying 'Manager's office' and a man."]))

(define dogcar
  (new place%
       [name "Scrapyard part two"]
       [desc "You see even more cars and a small doghouse."]))

(define inside
  (new place%
       [name "Inside the office"]
       [desc "The office is barren, there is only a rancid piece of meatd and a lighter here."]))


;;Characters

(define player
  (new character%
       [name "me"]
       [desc "A strapping young lad"]
       [inventory '()]
       [foodpref "Too much booze"]
       [talk-line "Can you get me home?"]
       [place tub]))
       
(define dog
  (new character%
       [name "nazi-dog"]
       [desc "This dog hates you"]
       [inventory '()]
       [foodpref "losers"]
       [talk-line "Barkenbork"]
       [place dogcar]))

(define owner
  (new character%
       [name "jesper"]
       [desc "Looks drunk and... special."]
       [inventory '()]
       [foodpref "Green eggs & Ham."]
       [talk-line "Hey kiddo, ye wanna joiwn me?
He reaches me a bottle.
After 30 minutes of ranting about how Bush did 9/11 and how the moon landing was faked he fell asleep.
You leave with the moonshine."]
       [place scraphut]))

(define aspkiddo
  (new character%
       [name "jesper"]
       [desc "Quite nice young lad, can't tell left from right. Also I HEAT the hat zone >:((("]
       [inventory '()]
       [foodpref "Beans, Eggs & T"]
       [talk-line "I am only here to be talked with. Also, that tub looks like a good vehicle."]
       [place scrapyard]))

;;Items
(define wheels
  (new item%
       [name "wheels"]
       [desc "They can surley be fitted on a vehicle."]))

(define lighter
  (new item%
       [name "lighter"]
       [desc "A small zippo-lighter"]))

(define choker
  (new item%
       [name "choker"]
       [desc "Blackbelt prostitute"]))

(define engine
  (new item%
       [name "engine"]
       [desc "Can power a vehicle but is missing a gear box"]))

(define neckpain
  (new item%
       [name "pain"]
       [desc "Horrible pain"]
       [key-item "jesper"]
       [key-conseq '(send scraphut connect-places! "in" inside "out")]))

(define svisk
  (new item%
       [name "meat"]
       [desc "You determine from the smell that it would kill anything that eats it"]))

(define HB
  (new item%
       [name "moonshine"]
       [desc "From a source in bergslagen"]))

(define backshot
  (new item%
       [name "lumbago"]
       [desc "Can be used in dire situations"]
       [key-item "nazi-dog"]
       [key-conseq (send dog give choker player)]))




(send tub connect-places! "out" scrapyard "in")
(send scrapyard connect-places! "south" scraphut "north")
(send scrapyard connect-places! "east" dogcar "west")
(send scrapyard add-item! engine)
(send inside add-item! svisk)
(send inside add-item! lighter)
(send dogcar add-item! wheels)
(map (lambda (x) (send owner recieve x)) '(HB neckpain))
(send player recieve backshot)
(send dog recieve choker)

