; dbmgr.scm
; Amanda Priscilla Araujo da Silva
; Joao Felipe Nicolaci Pimentel
; This file has the functions that parses the command line 

; macro defined to check wether something is already bounded
(define-macro (bound? x)
 `(with-exception-handler
    (lambda (e) #f)
    (lambda () (and ,x #t))))

(include "dbmainfunc.scm")

; This function prints out a helpful message telling the user how to run the program
; The param should be the program name
(define helpful-message (lambda (program-name)
	(display "Usage information:") (newline)
	(display "    ") (display program-name) (display " lookup <dat1> in <rep1>") (newline)
	(display "    ") (display program-name) (display " print <dat1> of <rep1>") (newline)
	(display "    ") (display program-name) (display " register <dat1> with <rep1>") (newline)
	(display "    ") (display program-name) (display " remove <dat1> from <rep1>") (newline)
	(display "    ") (display program-name) (display " list <rep1>") (newline)
	(display "    ") (display program-name) (display " duplicate <dat1> to <dat2> within <rep1>") (newline)
	(display "    ") (display program-name) (display " process <dat1> within <rep1>") (newline)
	(display "    ") (display program-name) (display " translate <dat1> into <dat2> within <rep1>") (newline)
))

; This function prints out a error message followed by a helpful message
; The param should be the program name
(define error-message (lambda (program-name)
	(display "Error: Bad formed parameters") (newline)
	(helpful-message program-name)
))


; This function verifies if the file has the expected extension
(define extension (lambda (file ext)
	(if (and
			(> (string-length file) (string-length ext))
			(string=? (substring file (- (string-length file) (string-length ext)) (string-length file)) ext)
		) 
		#t 
		(begin
			(display "The file '") (display file) (display "' doesn't have the expected extension") (newline)
			#f
		)
	)
))

; This function verifies if the file is .dat 
(define dat? (lambda (file)
	(extension file ".dat")
))

; This function verifies if the file is .rep 
(define rep? (lambda (file)
	(extension file ".rep")
))

; This function parses the command-line and executes the desired function if it is well formed
; or executes the helpful-message function if it ins't
; The param should be the list of command line arguments
(define parse-command-line (lambda (line)
	(cond
		((< (length line) 3) 
			(error-message (car line))
		)
		((string=? (list-ref line 1) "lookup") 
			(if (and
					(= (length line) 5)				
					(dat? (list-ref line 2))
					(string=? (list-ref line 3) "in") 
					(rep? (list-ref line 4))
				) 
				(if (file-exists? (list-ref line 4)) ; Check existence of rep
					(fn-lookup (list-ref line 2) (list-ref line 4))
					(display (string-append "The file '" (list-ref line 4) "' doesn't exist\n"))
				)
				(error-message (car line))
			)
		)
		((string=? (list-ref line 1) "print") 
			(if (and
					(= (length line) 5)			
					(dat? (list-ref line 2))
					(string=? (list-ref line 3) "of") 
					(rep? (list-ref line 4))
				) 
				(cond 
					((not (file-exists? (list-ref line 2))) ; Check existence of dat
						(display (string-append "The file '" (list-ref line 2) "' doesn't exist\n"))
					)
					((not (file-exists? (list-ref line 4))) ; Check existence of rep
						(display (string-append "The file '" (list-ref line 4) "' doesn't exist\n"))
					)
					(else 
						(fn-print (list-ref line 2) (list-ref line 4)) 
					)
				)
				(error-message (car line))
			)
		)
		((string=? (list-ref line 1) "register") 
			(if (and 
					(= (length line) 5)
					(dat? (list-ref line 2)) ; it is only possible to register files that exists
					(string=? (list-ref line 3) "with")
					(rep? (list-ref line 4))
				) 
				(cond 
					((not (file-exists? (list-ref line 2))) ; Check existence of dat
						(display (string-append "The file '" (list-ref line 2) "' doesn't exist\n"))
					)
					((not (file-exists? (list-ref line 4))) ; Check existence of rep
						(display (string-append "The file '" (list-ref line 4) "' doesn't exist\n"))
					)
					(else 
						(fn-register (list-ref line 2) (list-ref line 4)) 
					)
				)
				(error-message (car line))
			)
		)
		((string=? (list-ref line 1) "remove") 
			(if (and 
					(= (length line) 5)
					(dat? (list-ref line 2))
					(string=? (list-ref line 3) "from") 
					(rep? (list-ref line 4))
				) 
				(if (file-exists? (list-ref line 4)) ; Check existence of rep
					(fn-remove (list-ref line 2) (list-ref line 4)) 
					(display (string-append "The file '" (list-ref line 4) "' doesn't exist\n"))
				)
				(error-message (car line))
			)
		)
		((string=? (list-ref line 1) "list") 
			(if (and
					(= (length line) 3)
					(rep? (list-ref line 2))
				)
				(if (file-exists? (list-ref line 2)) ; Check existence of rep
					(fn-list (list-ref line 2))
					(display (string-append "The file '" (list-ref line 2) "' doesn't exist\n"))
				)
				(error-message (car line))
			)
		)
		((string=? (list-ref line 1) "duplicate") 
			(if (and 
					(= (length line) 7)
					(dat? (list-ref line 2))
					(string=? (list-ref line 3) "to") 
					(dat? (list-ref line 4))
					(string=? (list-ref line 5) "within") 
					(rep? (list-ref line 6))
				) 
				(cond 
					((not (file-exists? (list-ref line 2))) ; Check existence of dat1
						(display (string-append "The file '" (list-ref line 2) "' doesn't exist\n"))
					)
					((file-exists? (list-ref line 4)) ; Check non existence of dat2
						(display (string-append "The file '" (list-ref line 4) "' already exists\n"))
					)
					((not (file-exists? (list-ref line 6))) ; Check existence of rep
						(display (string-append "The file '" (list-ref line 6) "' doesn't exist\n"))
					)
					(else 
						(fn-duplicate (list-ref line 2) (list-ref line 4) (list-ref line 6)) 
					)
				)
				(error-message (car line))
			)
		)
		((string=? (list-ref line 1) "process") 
			(if (and 
					(= (length line) 5)
					(dat? (list-ref line 2))
					(string=? (list-ref line 3) "within") 
					(rep? (list-ref line 4))
				) 
				(cond 
					((not (file-exists? (list-ref line 2))) ; Check existence of dat
						(display (string-append "The file '" (list-ref line 2) "' doesn't exist\n"))
					)
					((not (file-exists? (list-ref line 4))) ; Check existence of rep
						(display (string-append "The file '" (list-ref line 4) "' doesn't exist\n"))
					)
					(else 
						(fn-process (list-ref line 2) (list-ref line 4)) 
					)
				)
				(error-message (car line))
			)
		)
		((string=? (list-ref line 1) "translate") 
			(if (and 
					(= (length line) 7)
					(dat? (list-ref line 2))
					(string=? (list-ref line 3) "into") 
					(dat? (list-ref line 4))
					(string=? (list-ref line 5) "within") 
					(rep? (list-ref line 6))
				) 
				(cond 
					((not (file-exists? (list-ref line 2))) ; Check existence of dat1
						(display (string-append "The file '" (list-ref line 2) "' doesn't exist\n"))
					)
					((not (file-exists? (list-ref line 6))) ; Check existence of rep
						(display (string-append "The file '" (list-ref line 6) "' already exists\n"))
					)
					(else 
						(fn-translate (list-ref line 2) (list-ref line 4) (list-ref line 6)) 
					)
				)
				(error-message (car line))
			)
		)
		(else 
			(error-message (car line))
		)
	)
))

; Main: executes the parse-command-line function
(parse-command-line (command-line))