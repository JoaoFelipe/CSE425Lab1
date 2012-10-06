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
The predicate was represented as a list with the first element being the name and the following elements being the arguments. 
This representation follows the output horn clause especification when we display it
So, when we use the function display to a horn clause that is parsed from the input horn clause, it shows an output horn clause in the correct format

This way, we don`t need a new function to read the result of parsed input horn clause and print out it in the right way, because the structure is already in the right way

Trials:
All the trials worked as expected for the following files:
-input_horn_clauses.dat:
cos ( x ) :- sen ( x )
invalid ( ) :- q
valid ( )
invalid ( ) :- q ( ) ^
exec ( x ,    y ) :- q ( 2 ) ^ r ( 4 ) ^ p ( a , b , c )
invalid ( x 
invalid ( x ) :-
test ( 1 , 2 , 3 )
invalid
ancestor ( x , y ) :- parent ( x , z ) ^ ancestor ( z , y )
ancestor ( x , y ) ^ other ( x ) :- parent ( x , z ) ^ ancestor ( z , y )
cos(x):-sen(x)
invalid():-q
valid()
invalid():-q()^
exec(x,y):-q(2)^r(4)^p(a,b,c)
invalid(x
invalid(x):-
test(1,2,3)
invalid
ancestor(x,y):-parent(x,z)^ancestor(z,y)
ancestor(x,y)^other(x):-parent(x,z)^ancestor(z,y)

-data.dat:

-repository.rep:
input_horn_clauses.dat

Test Cases:

[jfn1@shell lab1]$ ./dbmgr process input_horn_clauses.dat within repository.rep 
The data file 'input_horn_clauses.dat' was processed, generating the files 'input_horn_clauses_labels.dat' and 'input_horn_clauses_numbers.dat'

The content of the generated files are:
-input_horn_clauses_labels.dat:
cos
sen
valid
exec
q
r
p
a
b
c
test
invalid
other
parent
x
ancestor
z
y

-input_horn_clauses_numbers.dat:
4
1
2
3

This is the expected behavior. All the labels were read and written in the labels file without repetition and the same occurred for the numbers

[jfn1@shell lab1]$ ./dbmgr translate input_horn_clauses.dat into output_horn_clauses.dat within repository.rep
The data file 'input_horn_clauses.dat' was translated into the dat file 'output_horn_clauses.dat'

The content of the generated file is:
-output_horn_clauses.dat:
((cos x) ((sen x)))
((valid))
((exec x y) ((q 2) (r 4) (p a b c)))
((test 1 2 3))
((ancestor x y) ((parent x z) (ancestor z y)))
((cos x) ((sen x)))
((valid))
((exec x y) ((q 2) (r 4) (p a b c)))
((test 1 2 3))
((ancestor x y) ((parent x z) (ancestor z y)))

This is the correct behavior. All lines that were parsed as an input horn clause were successfully translated into output horn clause, as specified in the EBNFs


The following test cases are for invalid configurations.
All explanations for the behavior of the program are in the output 

[jfn1@shell lab1]$ ./dbmgr process 
Error: Bad formed parameters
Usage information:
    ./dbmgr lookup <dat1> in <rep1>
    ./dbmgr print <dat1> of <rep1>
    ./dbmgr register <dat1> with <rep1>
    ./dbmgr remove <dat1> from <rep1>
    ./dbmgr list <rep1>
    ./dbmgr duplicate <dat1> to <dat2> within <rep1>
    ./dbmgr process <dat1> within <rep1>
    ./dbmgr translate <dat1> into <dat2> within <rep1>

[jfn1@shell lab1]$ ./dbmgr process input_horn_clauses.txt within repository.rep
The file 'input_horn_clauses.txt' doesn't have the expected extension
Error: Bad formed parameters
Usage information:
    ./dbmgr lookup <dat1> in <rep1>
    ./dbmgr print <dat1> of <rep1>
    ./dbmgr register <dat1> with <rep1>
    ./dbmgr remove <dat1> from <rep1>
    ./dbmgr list <rep1>
    ./dbmgr duplicate <dat1> to <dat2> within <rep1>
    ./dbmgr process <dat1> within <rep1>
    ./dbmgr translate <dat1> into <dat2> within <rep1>

[jfn1@shell lab1]$ ./dbmgr process input_horn_clauses.dat within repository.txt
The file 'repository.txt' doesn't have the expected extension
Error: Bad formed parameters
Usage information:
    ./dbmgr lookup <dat1> in <rep1>
    ./dbmgr print <dat1> of <rep1>
    ./dbmgr register <dat1> with <rep1>
    ./dbmgr remove <dat1> from <rep1>
    ./dbmgr list <rep1>
    ./dbmgr duplicate <dat1> to <dat2> within <rep1>
    ./dbmgr process <dat1> within <rep1>
    ./dbmgr translate <dat1> into <dat2> within <rep1>

[jfn1@shell lab1]$ ./dbmgr process a.dat within repository.rep 
The file 'a.dat' doesn't exist

[jfn1@shell lab1]$ ./dbmgr process data.dat within repository.rep
The data file 'data.dat' is NOT listed in the repository file 'repository.rep'

[jfn1@shell lab1]$ ./dbmgr translate
Error: Bad formed parameters
Usage information:
    ./dbmgr lookup <dat1> in <rep1>
    ./dbmgr print <dat1> of <rep1>
    ./dbmgr register <dat1> with <rep1>
    ./dbmgr remove <dat1> from <rep1>
    ./dbmgr list <rep1>
    ./dbmgr duplicate <dat1> to <dat2> within <rep1>
    ./dbmgr process <dat1> within <rep1>
    ./dbmgr translate <dat1> into <dat2> within <rep1>

	
[jfn1@shell lab1]$ ./dbmgr translate input_horn_clauses.txt into output_horn_clauses.dat within repository.rep
The file 'input_horn_clauses.txt' doesn't have the expected extension
Error: Bad formed parameters
Usage information:
    ./dbmgr lookup <dat1> in <rep1>
    ./dbmgr print <dat1> of <rep1>
    ./dbmgr register <dat1> with <rep1>
    ./dbmgr remove <dat1> from <rep1>
    ./dbmgr list <rep1>
    ./dbmgr duplicate <dat1> to <dat2> within <rep1>
    ./dbmgr process <dat1> within <rep1>
    ./dbmgr translate <dat1> into <dat2> within <rep1>
	
[jfn1@shell lab1]$ ./dbmgr translate input_horn_clauses.dat into output_horn_clauses.txt within repository.rep
The file 'output_horn_clauses.txt' doesn't have the expected extension
Error: Bad formed parameters
Usage information:
    ./dbmgr lookup <dat1> in <rep1>
    ./dbmgr print <dat1> of <rep1>
    ./dbmgr register <dat1> with <rep1>
    ./dbmgr remove <dat1> from <rep1>
    ./dbmgr list <rep1>
    ./dbmgr duplicate <dat1> to <dat2> within <rep1>
    ./dbmgr process <dat1> within <rep1>
    ./dbmgr translate <dat1> into <dat2> within <rep1>

[jfn1@shell lab1]$ ./dbmgr translate input_horn_clauses.dat into output_horn_clauses.dat within repository.txt
The file 'repository.txt' doesn't have the expected extension
Error: Bad formed parameters
Usage information:
    ./dbmgr lookup <dat1> in <rep1>
    ./dbmgr print <dat1> of <rep1>
    ./dbmgr register <dat1> with <rep1>
    ./dbmgr remove <dat1> from <rep1>
    ./dbmgr list <rep1>
    ./dbmgr duplicate <dat1> to <dat2> within <rep1>
    ./dbmgr process <dat1> within <rep1>
    ./dbmgr translate <dat1> into <dat2> within <rep1>
	
[jfn1@shell lab1]$ ./dbmgr translate doesnt_exist.dat into output_horn_clauses.dat within repository.rep
The file 'doesnt_exist.dat' doesn't exist

[jfn1@shell lab1]$ ./dbmgr translate data.dat into output_horn_clauses.dat within repository.rep
The data file 'data.dat' is NOT listed in the repository file 'repository.rep'

[jfn1@shell lab1]$ ./dbmgr translate input_horn_clauses.dat into output_horn_clauses.dat within doesnt_exist.rep
The file 'doesnt_exist.rep' already exists
 
-----

Extra Credit:

For the input horn clause grammar, the head definition were changed:
  head -> predicate
became
  head -> predicate {AND predicate}
allowing more than one predicate in the head

For the output horn clause grammar, the head definition were also changed to allow more than one predicate:
  head -> predicate
became
  head -> LEFTPAREN predicate {predicate} RIGHTPAREN
  
Since we are using the scheme lists to display the output horn clause without any posterior parsing, 
we just change the head? function to instead of parsing just one predicate and return a predicate, parse a 
list of predicates in the new input syntax and return that list (that matches the new output syntax)

Test case:
Using the same input files:

[jfn1@shell extra]$ ./dbmgr translate input_horn_clauses.dat into output_horn_clauses.dat within repository.rep
The data file 'input_horn_clauses.dat' was translated into the dat file 'output_horn_clauses.dat'

The content of the generated file is:
-output_horn_clauses.dat:
(((cos x)) ((sen x)))
(((valid)))
(((exec x y)) ((q 2) (r 4) (p a b c)))
(((test 1 2 3)))
(((ancestor x y)) ((parent x z) (ancestor z y)))
(((ancestor x y) (other x)) ((parent x z) (ancestor z y)))
(((cos x)) ((sen x)))
(((valid)))
(((exec x y)) ((q 2) (r 4) (p a b c)))
(((test 1 2 3)))
(((ancestor x y)) ((parent x z) (ancestor z y)))
(((ancestor x y) (other x)) ((parent x z) (ancestor z y)))

This is the correct behavior.
All lines that were parsed as a modified input horn clause were successfully translated into the modified output horn clause








