; dbmainfunc.scm
; Amanda Priscilla Araujo da Silva
; Joao Felipe Nicolaci Pimentel
; This file contains the main features of the program

(include "dbfunc.scm")
(include "dbfileutils.scm")
(include "dbparser.scm")


; This function lookup for a data filename (dat) in a repository file (rep)
; The params should be the name of the files
; Command-line usage: ./dbmgr lookup <dat> in <rep>
(define fn-lookup (lambda (dat rep)
	(if (find-in-file dat (open-input-file rep))
		(display (string-append "The data file '" dat "' is listed in the repository file '" rep "'")) 
		(display (string-append "The data file '" dat "' is NOT listed in the repository file '" rep "'"))
	)
	(newline)
))

; This function lookup for a data filename (dat) in a repository file (rep)
; If the data file exists in the repository file, a verbatim listing of the data file is displayed
; The params should be the name of the files
; Command-line usage: ./dbmgr print <dat> of <rep>
(define fn-print (lambda (dat rep)
	(if (find-in-file dat (open-input-file rep))
		(print-file (open-input-file dat))
		(display (string-append "The data file '" dat "' is NOT listed in the repository file '" rep "'"))
	)
	(newline)
))

; This function lookup for a data filename (dat) in a repository file (rep)
; If the data file doesn't exist in the repository file, the data file will be registred on the repository file
; The params should be the name of the files
; Command-line usage: ./dbmgr register <dat> with <rep>
(define fn-register (lambda (dat rep)
	(if (find-in-file dat (open-input-file rep))
		(display (string-append "The data file '" dat "' is ALREADY listed in the repository file '" rep "'"))
		(begin
			(add-to-file rep dat)
			(display (string-append "The data file '" dat "' was added to the repository file '" rep "'"))
		)
	)
	(newline)
))

; This function lookup for a data filename (dat) in a repository file (rep)
; If the data file exists in the repository file, the data file will be removed from the repository file
; The params should be the name of the files
; Command-line usage: ./dbmgr remove <dat> from <rep>
(define fn-remove (lambda (dat rep)
	(if (find-in-file dat (open-input-file rep))
		(begin
			(remove-from-file rep dat)
			(display (string-append "The data file '" dat "' was removed from the repository file '" rep "'"))
		)
		(display (string-append "The data file '" dat "' is NOT listed in the repository file '" rep "'"))
		
	)
	(newline)
))

; This function display a list of data files that are present on the repository file
; The param should be the name of the repository file
; Command-line usage: ./dbmgr list <rep>
(define fn-list (lambda (rep)
	(print-file (open-input-file rep))
	(newline)
))

; This function duplicates the dat1 into dat2 and adds the dat2 in rep
; The params should be: dat1: source .dat file
;                       dat2: name of .dat destiny
;                       rep: repository file
; Command-line usage: ./dbmgr duplicate <dat1> to <dat2> within <rep> 
(define fn-duplicate (lambda (dat1 dat2 rep)
	(cond 
		((not (find-in-file dat1 (open-input-file rep))) 
			(display (string-append "The data file 1 '" dat1 "' is NOT listed in the repository file '" rep "'"))
		)
		((find-in-file dat2 (open-input-file rep)) 
			(display (string-append "The data file 2 '" dat2 "' is ALREADY listed in the repository file '" rep "'"))
		)
		(else 
			(copy-file dat1 dat2)
			(add-to-file rep dat2)
			(display (string-append "The data file 1 '" dat1 "' was duplicated into the data file 2 '" dat2 "'"))
		)
		
	)
	(newline)
))

; This function separates the tokens of a <file>.dat file in two new dat files: <file>_labels.dat 
; and <file>_number.dat
; The params should be: the .dat file and the .rep file
; Command-line usage: ./dbmgr process <dat> within <rep>
(define fn-process (lambda (dat rep)
	(if (find-in-file dat (open-input-file rep))
		; read tokens from dat
		; process tokens in two lists
		(let 
			(
				(lists (separate-tokens (file-to-list (open-input-file dat))))
				(labels_dat (file-name dat "labels"))
				(numbers_dat (file-name dat "numbers"))
			)
			(begin
				; save lists to files
				(list-to-file (open-output-file labels_dat) (car lists))
				(list-to-file (open-output-file numbers_dat) (cadr lists))
				(display (string-append "The data file '" dat "' was processed, generating the files '" labels_dat "' and '" numbers_dat "'"))
			)
		)
		(display (string-append "The data file '" dat "' is NOT listed in the repository file '" rep "'"))
	)
	(newline)
))


; This function parses a .dat file with horn clauses and translates the valid clauses into
; another .dat file with other format
; Command-line usage: ./dbmgr translate <dat1> into <dat2> within <rep>
(define fn-translate (lambda (dat1 dat2 rep)
	(if (find-in-file dat1 (open-input-file rep))
		(begin
			(list-to-file (open-output-file dat2) (valid-hornclauses (file-lines-to-list (open-input-file dat1))))
			(display (string-append "The data file '" dat1 "' was translated into the dat file '" dat2 "'"))
		)
		(display (string-append "The data file '" dat1 "' is NOT listed in the repository file '" rep "'"))
	)
	(newline)
))
