;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;      CS 3 Scheme programming assignment               ;;;;
;;;;                 April 2016                            ;;;;
;;;;        <joe blogg's> solutions <stdnum000>            ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This depends on "cs3-black-jack.scm"
;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;  Your code goes here                                    ;;;;
;;;;  Submit a file of code of everything you created below  ;;;;
;;;;  please do not submit the predefined code              ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;  Question 1.  Code for "best-hand"

;;; is ace in hand dshc
(define (ace-present hand)
 (or (memq '(A d) hand) (memq '(A s) hand) (memq '(A h) hand) (memq '(A c) hand))
)

;; Dummy Version of best-hand
(define (best-hand hand)
  (if ace-present(hand)
    (if (> (+ (min-val hand) 10) 21)
      (min-val hand)
      (+ (min-val hand) 10)
    )
    (min-val hand)
    ))

;; Best Value of Hand
;; [add description and test -cases]


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;  Question 2.  "stop-at"

(define (stop-at stop-num)
	(lambda (customer-hand-so-far dealer-up-card)
    (< (best-hand customer-hand-so-far) stop-num)
    ))
;; [add description and test -cases]


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;  Question 3.  "repeat-game"
;; [add description and test -cases]

(define (repeat-game n)
  (if (= n 0)
    0
    (+ (blackjack strategy) (repeat-game (- n 1)))
  )
)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;   Question 4.    clever
;; [add description and test -cases]





(define (clever my-hand up-card)

  (if (<= (best-hand my-hand) 11)
      #t
      (if (>= (best-hand my-hand) 17)
        #f
        (if (= (best-hand my-hand) 12)
          (not (or (= (min-val up-card) 4) (= (min-val up-card) 5) (= (min-val up-card) 6)))
          (if (and (>= (best-hand my-hand) 13) (<= (best-hand my-hand) 16))
            (>= (best-hand (list up-card)) 7)
            ;;;error
          )
        )
      )
    )
  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;      Question 5.                Majority
;;;
;; [add description and test -cases]

(define (average val1 val2 val3)
  (or (and val1 (or val2 val3)) (and val2 (or val1 val3)) (and val3 (or val2 val1)))
)

(define (majority strategy1 strategy2 strategy3)
  (lambda (hand up-card)
    (average (strategy1 hand up-card) (strategy2 hand up-card) (strategy3 hand up-card))
  )
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;        Question 6.              Get Stats
;;;
;; [add description and test -cases]


(define (get-stats strategy repeat-count data-points)
    (if (= data-points 0)
        '()
        (append (point-average strategy (- data-points 1)) (repeat-game repeat-count)) 
    )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;   Question 8.   interactive
;; [add description and user insctructions]

(define (hit?)
    (lambda (hand up-card)
        (display "Your hand evaluates to: " hand)
        (display "The dealer's card is: " up-card)
        (hit-me?)    
    )    
)


; function to get the input returns #t if the user types y otherwise #f
(define (hit-me?)
  (eq? (read) 'y))
