; dbparser.scm
; Amanda Priscilla Araujo da Silva
; Joao Felipe Nicolaci Pimentel
; This file contains operations that are used for parsing, processing and translating

; This function receives a list of tokens, and separate them in two lists:
; LABEL and NUMBERS without repetition of tokens
(define separate-tokens (lambda (lis)
	(cond 
		((null? lis) (list (list) (list)))
		(else 
			(let ((token (car lis)) (result (separate-tokens (cdr lis))))
				(let ((label-list (car result)) (number-list (cadr result)))
					(list
						(if (and (LABEL? token) (not (find-token token label-list)))
							(cons token label-list)
							label-list
						)
						(if (and (NUMBER? token) (not (find-token token number-list)))
							(cons token number-list)
							number-list
						)
					)
				)
			)
		)
	)
))

; This function verifies if a token exists in a list of tokens
(define find-token (lambda (token lis)
	(cond
		((null? lis) #f)
		((string=? token (car lis)) #t)
		(else
			(find-token token (cdr lis))
		)
	)
))

; This function verifies the type of a string
; Returns 'numeric' if there is just digits in the string
;         'alphabetic' if there is just letters in the string
;         'alphanumeric' if there is letters and numbers in the string
;         'other' otherwise
(define verify (lambda (str pos len status)
   (cond
      ((> (+ pos 1) len) status)
       ((and (char-numeric? (string-ref str pos)) (string=? status ""))
           (verify str (+ pos 1) len "numeric")  
       )
       ((and (char-alphabetic? (string-ref str pos)) (string=? status ""))
           (verify str (+ pos 1) len "alphabetic")  
       )
       ((and (char-numeric? (string-ref str pos)) (string=? status "alphabetic"))
           (verify str (+ pos 1) len "alphanumeric")  
       )
       ((and (char-alphabetic? (string-ref str pos)) (string=? status "numeric"))
           (verify str (+ pos 1) len "alphanumeric")  
       )
       ((and (not(char-alphabetic? (string-ref str pos))) (not(char-numeric? (string-ref str pos))))
           (verify str (+ pos 1) len "other")  
       )
       (else
           (verify str (+ pos 1) len status)  
       )
   )
))

; This function verifies if a given string is a LABEL (contains just letters)
(define LABEL? (lambda (str)
	(string=? "alphabetic" (verify str 0 (string-length str) ""))
))

; This function verifies if a given string is a NUMBER (contains just digits)
(define NUMBER? (lambda (str)
	(string=? "numeric" (verify str 0 (string-length str) ""))
))

; This function verifies if a given string is a SEPARATOR (:-)
(define SEPARATOR? (lambda (str)
	(string=? str ":-")
))

; This function verifies if a given string is a AND (^)
(define AND? (lambda (str)
	(string=? str "^")
))

; This function verifies if a given string is a RIGHTPAREN (')')
(define RIGHTPAREN? (lambda (str)
	(string=? str ")")
))

; This function verifies if a given string is a LEFTPAREN ('(')
(define LEFTPAREN? (lambda (str)
	(string=? str "(")
))

; This function verifies if a given string is a COMMA (,)
(define COMMA? (lambda (str)
	(string=? str ",")
))

; This function verifies if a given string is a SYMBOL (LABEL or NUMBER)
(define SYMBOL? (lambda (str)
	(or (LABEL? str) (NUMBER? str))
))

; This function checks if a list has a valid input horn clause and returns a list with 3 elements:
; 1- tells whether it is a valid horn clause or not
; 2- head 
; 3- body list
(define hornclause? (lambda (lis state)
	(cond
		((and (null? lis) (= state 1)) (list #t '() '()))
		((and (null? lis) (= state 3)) (list #t '() '()))
		((= state 0) 
			(let ((head-result (head? lis 0)))
				(if (not (car head-result)) 
					(list #f '() '())
					(let ((result (hornclause? (caddr head-result) 1)))
						(if (null? (caddr result))
							(list (car result) (cadr head-result))
							(list (car result) (cadr head-result) (caddr result))
						)
					)
				)
			)
		)
		((and (= state 1) (SEPARATOR? (car lis))) 
			(let ((result (hornclause? (cdr lis) 2)))
				(list (car result) '() (caddr result))
			)
		)
		((= state 2) 
			(let ((body-result (body? lis 0)))
				(if (not (car body-result)) 
					(list #f '() '())
					(let ((result (hornclause? (caddr body-result) 3)))
						(list (car result) '() (cadr body-result))
					)
				)
			)
		)
		(else 
			(list #f '() '())
		)
	)
))

; This function checks if a list has a valid head and returns a list with 3 elements:
; 1- tells whether it is a valid head or not
; 2- predicate
; 3- tail of list
(define head? (lambda (lis state)
	(predicate? lis 0)
))

; This function checks if a list has a valid body and returns a list with 3 elements:
; 1- tells whether it is a valid body or not
; 2- list of predicates
; 3- tail of list
(define body? (lambda (lis state)
	(cond
		((and (null? lis) (= state 1)) (list #t '() '()))
		((or (= state 0) (= state 2)) 
			(let ((predicate-result (predicate? lis 0)))
				(if (not (car predicate-result)) 
					(list #f '() '())
					(let ((result (body? (caddr predicate-result) 1)))
						(list (car result) (cons (cadr predicate-result) (cadr result)) (caddr result))
					)
				)
			)
		)
		((and (= state 1) (AND? (car lis))) 
			(body? (cdr lis) 2)
		)
		(else
			(list #f '() '())
		)
	)
))


; This function checks if a list has a valid predicate and returns a list with 3 elements:
; 1- tells whether it is a valid predicate or not
; 2- list with name and args
; 3- tail of list
(define predicate? (lambda (lis state)
	(cond
		((null? lis) (list #f '() '()))
		((and (= state 0) (LABEL? (car lis))) 
			(let ((result (predicate? (cdr lis) 1)))
				(list (car result) (cons (car lis) (cadr result)) (caddr result))
			)
		)
		((and (= state 1) (LEFTPAREN? (car lis))) 
			(predicate? (cdr lis) 2)
		)
		((and (= state 2) (RIGHTPAREN? (car lis))) 
			(list #t '() (cdr lis))
		)
		((and (= state 2) (SYMBOL? (car lis))) 
			(let ((result (predicate? (cdr lis) 3)))
				(list (car result) (cons (car lis) (cadr result)) (caddr result))
			)
		)
		((and (= state 3) (RIGHTPAREN? (car lis))) 
			(list #t '() (cdr lis))
		)
		((and (= state 3) (COMMA? (car lis))) 
			(predicate? (cdr lis) 4)
		)
		((and (= state 4) (SYMBOL? (car lis))) 
			(let ((result (predicate? (cdr lis) 3)))
				(list (car result)  (cons (car lis) (cadr result)) (caddr result))
			)
		)
		(else
			(list #f '() '())
		)
	)
))


; This function receives a list of list of tokens and returns a list of valid 
; output horn clauses
(define valid-hornclauses (lambda (lis)
	(cond 
		((null? lis) '())
		(else
			(let ((clause (hornclause? (car lis) 0)))
				(if (car clause)
					(cons (cdr clause) (valid-hornclauses (cdr lis)))
					(valid-hornclauses (cdr lis))
				)
			)				
		)
	)
))


