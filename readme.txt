lab1 - Project Report
Amanda Priscilla Araujo da Silva
Joao Felipe Nicolaci Pimentel

Structure:
-dbmgr.scm is the main file and has functions for parsing the command line, 
verifying the existence or absence of files and it calls the main functions from dbmainfunc.scm
-dbmainfunc.scm contains the functions that represent the main features of the program. 
These features use functions from dbfileutils.scm, dbparsers.scm, dbfunc.scm
-dbfileutils.scm contains the functions that are used to manipulate the repository and data files
-dbparser.scm contains the functions that are used for parsing, processing and translating
-dbfunc.scm contains the auxiliary general functions that are used in the other files 
and are not categorized in file management or parsing


Fixes of the previous lab:
-We changed the code of verifying the existence of dat and rep files, so when the file doesn't exists, 
it doesn`t show anymore that there were bad formed parameters. It just says that the file doesn't exist instead, 
not showing again the help message with the right syntax for the command line. 
It still says that there were bad formed parameters when the given file extension doesn't match the expected extension 
(.dat or .rep) or any other syntax error.


Design decisions:
-We followed up the same structure of the previous lab to check files existence and command syntax. 
-For the process command, we made some functions to ensure that each word of the file will be included in one single list of tokens 
that will be returned to the parser that will separate them into lists of LABEL or NUMBER. 
After that, the program saves both returned lists as specified (filename_labels.dat or filename_numbers.dat).

-For the translate command, we used the following abstract representation in the output: 
a list in which the first element is a single predicate (the head) and the second element is 
another list representing the body in which each element is a predicate of the body. 
So using this list it already prints the output Horn Clause in the correct format using the display function.



