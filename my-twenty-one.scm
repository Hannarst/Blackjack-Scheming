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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;  Question 1.  Code for "best-hand"

;;; is ace in hand dshc

;;Determine best hand to play of existing cards (expects a list of cards)
;; > (best-hand '((8 c) (A h)))
;; 19
;;

(define (best-hand hand)
  (define (ace-present? hand)
   (or (memq '(A d) hand) (memq '(A s) hand) (memq '(A h) hand) (memq '(A c) hand))
  )
  (if (and (ace-present? hand) (<= (+ (min-val hand) 10) 21)) ;;; only 1 ace relevant: two aces counting as 11 busts
      (+ (min-val hand) 10) ;;; it is closer to 21 so count Ace as 11
      (min-val hand) ;;; read as 1 if 11 busts
   )
 )

;; Best Value of Hand
;; [add description and test -cases]


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;  Question 2.  "stop-at"
;; [add description and test -cases]


;>  ((stop-at 17) '((7 s) (3 c)) '(5 d))
;#t
(define (stop-at stop-num)
	(lambda (customer-hand-so-far dealer-up-card)
    (< (best-hand customer-hand-so-far) stop-num)
    ))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;  Question 3.  "repeat-game"
;; [add description and test -cases]

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
;; [add description and test -cases]


; (clever '((7 s) (3 c)) '(5 d))
;> #t

;;; code isn't optimal, but readable
(define (clever my-hand up-card)
; direct translation of clever requirements into scheme
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
;; [add description and test -cases]

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
;; [add description and user insctructions]

;>(hit? '((7 s) (3 c)) '(5 d))
;Your hand is: 7s3c
;The dealer's card is: 5d
;y
;#t

(define (hit? hand up-card)
      (display "Your hand is: ") (display hand)
      (newline)
      (display "The dealer's card is: ") (display up-card)
      (newline)
      (hit-me?)
)


; function to get the input returns #t if the user types y otherwise #f
(define (hit-me?)
  (eq? (read) 'y))
