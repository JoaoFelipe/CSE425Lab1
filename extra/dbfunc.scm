; dbfunc.scm
; Amanda Priscilla Araujo da Silva
; Joao Felipe Nicolaci Pimentel
; This file contains auxiliar general functions for the program

; Returns the name of output file
; Eg: file1.dat with type labels will return file1_labels.dat
(define file-name (lambda (name type)
	(string-append (substring name 0 (- (string-length name) 4)) "_" type ".dat")
))


; This function splits a string by space, label(sequence of alphabetic characters), 
; number(sequence of numeric characters), parenthesis('(' or ')'), comma(','), and('^'), separator(':-'), and other
; with auxiliar params
(define split (lambda (str pos curr lis status)
	(cond 
		((>= pos (string-length str)) 
			(if (= (string-length curr) 0)
				lis
				(cons curr lis)
			)
		)
		(else
			(let ((ch (string-ref str pos))) 
				(cond
					((char-whitespace? ch) 
						(split str (+ pos 1) "" 
							(if (= (string-length curr) 0)
								lis
								(cons curr lis)
							)
							""
						)
					)
					((and (char-numeric? ch) (not (string=? status "numeric")))
						(split str pos "" 
							(if (= (string-length curr) 0)
								lis
								(cons curr lis)
							)
							"numeric"
						)
					)
					((and (char-alphabetic? ch) (not (string=? status "alphabetic")))
						(split str pos "" 
							(if (= (string-length curr) 0)
								lis
								(cons curr lis)
							)
							"alphabetic"
						)
					)
					((char=? ch #\^)
						(split str (+ pos 1) "" 
							(cons "^" 
								(if (= (string-length curr) 0)
									lis
									(cons curr lis)
								)
							)
							""
						)
					)
					((char=? ch #\()
						(split str (+ pos 1) "" 
							(cons "(" 
								(if (= (string-length curr) 0)
									lis
									(cons curr lis)
								)
							)
							""
						)
					)
					((char=? ch #\))
						(split str (+ pos 1) "" 
							(cons ")" 
								(if (= (string-length curr) 0)
									lis
									(cons curr lis)
								)
							)
							""
						)
					)
					((char=? ch #\,)
						(split str (+ pos 1) "" 
							(cons "," 
								(if (= (string-length curr) 0)
									lis
									(cons curr lis)
								)
							)
							""
						)
					) 
					((and (char=? ch #\:) (< (+ pos 1) (string-length str)) (char=? (string-ref str (+ pos 1)) #\-))
						(split str (+ pos 2) "" 
							(cons ":-" 
								(if (= (string-length curr) 0)
									lis
									(cons curr lis)
								)
							)
							""
						)
					) 
					((and (string=? status "numeric") (not (char-numeric? ch)))
						(split str (+ pos 1) (string ch) 
							(if (= (string-length curr) 0)
								lis
								(cons curr lis)
							)
							"other"
						)
					)
					((and (string=? status "alphabetic") (not (char-alphabetic? ch)))
						(split str (+ pos 1) (string ch) 
							(if (= (string-length curr) 0)
								lis
								(cons curr lis)
							)
							"other"
						)
					)
					(else
						(split str (+ pos 1) (string-append curr (string ch)) lis status)
					)
				)
			)
			
		)
	)
))


; This function splits a string by space, label(sequence of alphabetic characters), 
; number(sequence of numeric characters), parenthesis('(' or ')'), comma(','), and('^'), separator(':-'), and other
; Eg.: "my ancestor(x,y):-parent(x,z)" may be separated into:
;    ["my" "ancestor" "(" "x" "," "y" ")" ":-" "parent" "(" "x" "," "z" ")"]
(define split-string (lambda (str)
	(reverse (split str 0 "" '() ""))
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
