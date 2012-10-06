; dbfileutils.scm
; Amanda Priscilla Araujo da Silva
; Joao Felipe Nicolaci Pimentel
; This file contains operations that are made in the files

; This function searchs for a data filename (dat) in a opened port of a repository file (rep-port)
; The repository file should be sorted
(define find-in-file (lambda (dat rep-port)  
	(let ((obj (read rep-port))) 
		(cond 
			((or (eof-object? obj) (string<? dat (symbol->string obj))) (begin
				(close-input-port rep-port)
				#f
			)) 
			((string=? dat (symbol->string obj)) (begin 
				(close-input-port rep-port) 
				#t
			))
			(else 
				(find-in-file dat rep-port)
			)
		)
	)
))

; This function prints out all the contents of a file opened in a port
(define print-file (lambda (port)  
	(let ((obj (read-char port))) 
		(cond 
			((eof-object? obj)
				(close-input-port port)
			) 
			(else 
				(display obj)
				(print-file port)
			)
		)
	)
))


; This function adds a word to a sorted file 
(define add-to-file (lambda (file word)
	(rename-file file (string-append "temp" file))
	(add-to-new-file (open-input-file (string-append "temp" file)) (open-output-file file) word #f)
	(delete-file (string-append "temp" file))
))

; This function adds a word to a sorted file opened in a port(port-read) 
; and copies the file to another opened port (port-add)
(define add-to-new-file (lambda (port-read port-write word added)  
	(let ((obj (read port-read))) 
		(cond 
			((and (eof-object? obj) (not added)) (begin 
				(display word port-write)
				(close-output-port port-write) 
				(close-input-port port-read)
			))
			((and (eof-object? obj) added) (begin 
				(close-output-port port-write) 
				(close-input-port port-read)
			)) 			
			((and (string<? word (symbol->string obj)) (not added))(begin 
				(display word port-write)
				(display "\n" port-write)
				(display obj port-write)
				(display "\n" port-write)
				(add-to-new-file port-read port-write word #t)
			))
			(else 
				(display obj port-write)
				(display "\n" port-write)
				(add-to-new-file port-read port-write word added)
			)
		)
	)
))


; This function removes a word from a sorted file 
(define remove-from-file (lambda (file word)
	(rename-file file (string-append "temp" file))
	(remove-from-new-file (open-input-file (string-append "temp" file)) (open-output-file file) word)
	(delete-file (string-append "temp" file))
))

; This function removes a word from a sorted file opened in a port(port-read) 
; and copies the file to another opened port (port-add)
(define remove-from-new-file (lambda (port-read port-write word)  
	(let ((obj (read port-read))) 
		(cond 
			((eof-object? obj) (begin 
				(close-output-port port-write) 
				(close-input-port port-read)
			)) 			
			((string=? word (symbol->string obj))(begin 
				(remove-from-new-file port-read port-write word)
			))
			(else 
				(display obj port-write)
				(display "\n" port-write)
				(remove-from-new-file port-read port-write word)
			)
		)
	)
))

; This function reads each line of a file and separate it into tokens
; Returns a list of list of tokens
(define file-lines-to-list (lambda (port)
	(let ((line (read-line port)))
		(cond 
			((eof-object? line) 
				(begin
					(close-input-port port)
					'()
				)
			)
			(else
				(cons (split-string line) (file-lines-to-list port))
			)
		)
	)
))


; This function returns the contents of a file in a list of words/tokens
; The parameter dat-port is the file opened in a port
(define file-to-list (lambda (dat-port)  
	(list-elements-to-list (file-lines-to-list dat-port))
))

; This function saves a list in a file
(define list-to-file (lambda (port lis)
	(cond
		((null? lis) (close-output-port port))
		(else
			(display (car lis) port)
			(display "\n" port)
			(list-to-file port (cdr lis))
		)
	)
))

