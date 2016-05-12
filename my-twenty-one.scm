;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;      CS 3 Scheme programming assignment               ;;;;
;;;;                 April 2016                            ;;;;
;;;;        Anna Borysova's solutions BRYANN004            ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This depends on "cs3-black-jack.scm"
;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;  Your code goes here                                    ;;;;
;;;;  Submit a file of code of everything you created below  ;;;;
;;;;  please do not submit the predefined code              ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (member? ele lst)
  (cond ((null? lst) #f)
        ((not (list? lst))
         (equal? ele lst))
        (else (or (member? ele (car lst))
                  (member? ele (cdr lst))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;  Question 1.  Code for "best-hand"


;;; is ace in hand dshc
;;Determine best hand to play of existing cards (expects a list of cards)
;; > (best-hand '((8 c) (A h)))
;; 19

(define (best-hand hand)
  (if (and (member? 'A hand) (<= (+ (min-val hand) 10) 21)) ;;; only 1 ace relevant: two aces counting as 11 busts
      (+ (min-val hand) 10) ;;; it is closer to 21 so count Ace as 11
      (min-val hand) ;;; read as 1 if 11 busts
   )
 )

;; Best Value of Hand
;; [add description and test -cases]


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;  Question 2.  "stop-at"

; takes an argument n that determines a strategy where a card is taken only if the best hand so far is less than n
;>  ((stop-at 17) '((7 s) (3 c)) '(5 d))
;#t
(define (stop-at n)
	(lambda (customer-hand-so-far dealer-up-card)
    (< (best-hand customer-hand-so-far) n)
    ))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;  Question 3.  "repeat-game"

;takes a strategy and a number as arguments such that:
;(repeat‐game strategy n)
;plays n games with the strategy specified and returns the number of games won minus the
;number of games lost (draws don’t count either way).
;> (repeat-game stop-at-17 10)
; -5
(define (repeat-game strategy n)
  (if (= n 0)
    0
    (+ (black-jack strategy) (repeat-game strategy (- n 1)))
  )
)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;   Question 4.    clever

;takes into account both the player’s current total and what the dealer’s up card is
; (clever '((7 s) (3 c)) '(5 d))
;> #t
(define (clever my-hand up-card)
; direct translation of clever requirements into scheme
; code isn't optimal, but readable
  (cond ((<= (best-hand my-hand) 11) #t)
      ((>= (best-hand my-hand) 17) #f)
      ((= (best-hand my-hand) 12)
          (not (or (= (min-val (list up-card)) 4) (= (min-val (list up-card)) 5) (= (min-val (list up-card)) 6))))
      ((and (>= (best-hand my-hand) 13) (<= (best-hand my-hand) 16))
          (>= (best-hand (list up-card)) 7))
    )
  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;      Question 5.                Majority
;;;

; takes three strategies as arguments and produces a strategy as a
;result. This resulting strategy decides whether or not to “hit” by checking the three argument
;strategies, and going with the majority
;((majority stop-at-17 stupid clever) '((7 s) (3 c)) '(5 d))
;>#t
(define (majority strategy1 strategy2 strategy3)
  (define (average val1 val2 val3)
    (or (and val1 (or val2 val3)) (and val2 (or val1 val3)) (and val3 (or val2 val1)))
  )
  (lambda (hand up-card)
    (average (strategy1 hand up-card) (strategy2 hand up-card) (strategy3 hand up-card))
  )
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;        Question 6.              Get Stats
;;;
;; [add description and test -cases]

;which gathers
;the statistics of several repeats of the game, in a list. Every data point represents a large number of
;repeats of the game and there will be several such data points in the output list.
;(get-stats stupid 10 5)
;>(-6 -10 -8 -6 -8)
(define (get-stats strategy repeat-count data-points)
    (if (= data-points 0)
        '()
        (append (get-stats strategy repeat-count (- data-points 1)) (list (repeat-game strategy repeat-count)))
    )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;   Question 8.   interactive

;returns true if the user types 'y'
;false for anything else
(define (hit? hand up-card)
      (display "Your hand is: ") (display hand)
      (newline)
      (display "The dealer's card is: ") (display up-card)
      (newline)
      (display "Hit? Enter 'y' for hit and anything else for stand: ")
      (newline)
      (hit-me?)
)


; function to get the input returns #t if the user types y otherwise #f
(define (hit-me?)
  (eq? (read) 'y))
