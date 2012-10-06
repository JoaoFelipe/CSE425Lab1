; dbfunc.scm
; Amanda Priscilla Araujo da Silva
; Joao Felipe Nicolaci Pimentel
; This file contains auxiliar general functions for the program

; Returns the name of output file
; Eg: file1.dat with type labels will return file1_labels.dat
(define file-name (lambda (name type)
	(string-append (substring name 0 (- (string-length name) 4)) "_" type ".dat")
))


; This function splits a string by space with auxiliar params
(define split (lambda (str pos curr lis)
	(cond 
		((>= pos (string-length str)) 
			(if (= (string-length curr) 0)
				lis
				(cons curr lis)
			)
		)
		(else
			(let ((ch (string-ref str pos))) 
				(if (char-whitespace? ch) 
					(split str (+ pos 1) "" 
						(if (= (string-length curr) 0)
							lis
							(cons curr lis)
						)
					)
					(split str (+ pos 1) (string-append curr (string ch)) lis)
				)
			)
			
		)
	)
))


; This function splits a string by space 
(define split-string (lambda (str)
	(reverse (split str 0 "" '()))
))


; This function converts a list of lists into a list
(define list-elements-to-list (lambda (lis)
	(cond 
		((null? lis) '())
		(else
			(append (car lis) (list-elements-to-list (cdr lis)))
		)
	)
))
