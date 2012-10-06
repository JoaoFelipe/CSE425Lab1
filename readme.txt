lab1 - Project Report
Amanda Priscilla Araujo da Silva
Joao Felipe Nicolaci Pimentel

Structure:
-dbmgr.scm is the main file and has functions for parsing the command line, verifying the existence or absence of files and it calls the main functions from dbmainfunc.scm
-dbmainfunc.scm contains the functions that represents the main features of the program. This features use functions from dbfileutils.scm, dbparsers.scm, dbfunc.scm
-dbfileutils.scm contains the functions that are used to manipulate the repository and data files
-dbparser.scm contains the functions that are used for parsing, processing and translating
-dbfunc.scm contains the auxiliary general functions that are used in the other files and are not categorized in file management or parsing


Fixes of the previous lab:
-We changed the code of verifying the existence of dat and rep files, so when the file doesn't exists, it doesn`t show anymore that there were bad formed parameters. It just says that the file doesn't exist instead, not showing again the help message with the right syntax for the command line. It still says that there were bad formed parameters when the given file extension doesn't match the expected extension (.dat or .rep) or any other syntax error.


Design decisions:
-We followed up the same structure of the previous lab to check files existence and command syntax. 
-For the process command, we made some functions to ensure that each word of the file will be included in one single list of tokens that will be returned to the parser that will separate them into lists of LABEL or NUMBER. After that, the program saves both returned lists as specified (filename_labels.dat or filename_numbers.dat).
-For the translate command, 


Trials:
All the trials worked as expected for the following files:
-data.dat:
Test
New data
Verbatim listing?
2
3
(1 2 3)
       s
\n /n
EOF
The real EOF

-repository.rep
a.dat
b.dat
d.dat
data.dat
e.dat

-new_data.rep

-e.dat

All explanations for the behavior of the program are in the output

[jfn1@shell lab0]$ ./dbmgr lookup data.dat in repository.rep
The data file 'data.dat' is listed in the repository file 'repository.rep'

[jfn1@shell lab0]$ ./dbmgr lookup new_data.dat in repository.rep
The data file 'new_data.dat' is NOT listed in the repository file 'repository.rep'

[jfn1@shell lab0]$ ./dbmgr lookup data.dat in 'repository_doesnt_exist.rep'
The file repository_doesnt_exist.rep doesn't exist
Error: Bad formed parameters
Usage information:
    ./dbmgr lookup <dat1> in <rep1>
    ./dbmgr print <dat1> of <rep1>
    ./dbmgr register <dat1> with <rep1>
    ./dbmgr remove <dat1> from <rep1>
    ./dbmgr list <rep1>
    ./dbmgr duplicate <dat1> to <dat2> within <rep1>

[jfn1@shell lab0]$ ./dbmgr lookup data.txt in repository.rep
The file 'data.txt' doesn't have the expected extension
Error: Bad formed parameters
Usage information:
    ./dbmgr lookup <dat1> in <rep1>
    ./dbmgr print <dat1> of <rep1>
    ./dbmgr register <dat1> with <rep1>
    ./dbmgr remove <dat1> from <rep1>
    ./dbmgr list <rep1>
	
[jfn1@shell lab0]$ ./dbmgr lookup data.dat of repository.rep
Error: Bad formed parameters
Usage information:
    ./dbmgr lookup <dat1> in <rep1>
    ./dbmgr print <dat1> of <rep1>
    ./dbmgr register <dat1> with <rep1>
    ./dbmgr remove <dat1> from <rep1>
    ./dbmgr list <rep1>
    ./dbmgr duplicate <dat1> to <dat2> within <rep1>
	
[jfn1@shell lab0]$ ./dbmgr print data.dat of repository.rep
Test
New data
Verbatim listing?
2
3
(1 2 3)
       s
\n /n
EOF
The real EOF

[jfn1@shell lab0]$ ./dbmgr print new_data.dat of repository.rep
The data file 'new_data.dat' is NOT listed in the repository file 'repository.rep'

[jfn1@shell lab0]$ ./dbmgr print datas.dat of repository.rep
The file 'datas.dat' doesn't exist
Error: Bad formed parameters
Usage information:
    ./dbmgr lookup <dat1> in <rep1>
    ./dbmgr print <dat1> of <rep1>
    ./dbmgr register <dat1> with <rep1>
    ./dbmgr remove <dat1> from <rep1>
    ./dbmgr list <rep1>
    ./dbmgr duplicate <dat1> to <dat2> within <rep1>
	
[jfn1@shell lab0]$ ./dbmgr register new_data.dat with repository.rep
The data file 'new_data.dat' was added to the repository file 'repository.rep'

[jfn1@shell lab0]$ ./dbmgr register data.dat with repository.rep
The data file 'data.dat' is ALREADY listed in the repository file 'repository.rep'

[jfn1@shell lab0]$ ./dbmgr register datas.dat with repository.rep
The file 'datas.dat' doesn't exist
Error: Bad formed parameters
Usage information:
    ./dbmgr lookup <dat1> in <rep1>
    ./dbmgr print <dat1> of <rep1>
    ./dbmgr register <dat1> with <rep1>
    ./dbmgr remove <dat1> from <rep1>
    ./dbmgr list <rep1>
    ./dbmgr duplicate <dat1> to <dat2> within <rep1>
	
[jfn1@shell lab0]$ ./dbmgr remove data.dat from repository.rep
The data file 'data.dat' was removed from the repository file 'repository.rep'

[jfn1@shell lab0]$ ./dbmgr remove new_data.dat from repository.rep
The data file 'new_data.dat' is NOT listed in the repository file 'repository.rep'

[jfn1@shell lab0]$ ./dbmgr list repository.rep
a.dat
b.dat
d.dat
data.dat
e.dat


[jfn1@shell lab0]$ ./dbmgr list repository_doesnt_exist.rep
The file 'repository_doesnt_exist.rep' doesn't exist
Error: Bad formed parameters
Usage information:	
    ./dbmgr lookup <dat1> in <rep1>
    ./dbmgr print <dat1> of <rep1>
    ./dbmgr register <dat1> with <rep1>
    ./dbmgr remove <dat1> from <rep1>
    ./dbmgr list <rep1>
    ./dbmgr duplicate <dat1> to <dat2> within <rep1>
	
[jfn1@shell lab0]$ ./dbmgr duplicate data.dat to dat.dat within repository.rep
The data file 1 'data.dat' was duplicated into the data file 2 'dat.dat'

[jfn1@shell lab0]$ ./dbmgr duplicate data.dat to new_data.dat within repository.rep
The file 'new_data.dat' already exists
Error: Bad formed parameters
Usage information:
    ./dbmgr lookup <dat1> in <rep1>
    ./dbmgr print <dat1> of <rep1>
    ./dbmgr register <dat1> with <rep1>
    ./dbmgr remove <dat1> from <rep1>
    ./dbmgr list <rep1>
    ./dbmgr duplicate <dat1> to <dat2> within <rep1>
	
[jfn1@shell lab0]$ ./dbmgr duplicate data.dat to e.dat within repository.rep
The data file 2 'e.dat' is ALREADY listed in the repository file 'repository.rep'

[jfn1@shell lab0]$ ./dbmgr duplicate new_data.dat to new_data2.dat within repository.rep
The data file 1 'new_data.dat' is NOT listed in the repository file 'repository.rep'

[jfn1@shell lab0]$ ./dbmgr duplicate data_doesnt_exist.dat to dat.dat within repository.rep
The file 'data_doesnt_exist.dat' doesn't exist
Error: Bad formed parameters
Usage information:
    ./dbmgr lookup <dat1> in <rep1>
    ./dbmgr print <dat1> of <rep1>
    ./dbmgr register <dat1> with <rep1>
    ./dbmgr remove <dat1> from <rep1>
    ./dbmgr list <rep1>
    ./dbmgr duplicate <dat1> to <dat2> within <rep1>
	
	
	
	
Extra Credit:

Prototyped features: All features:
-lookup
-print
-register
-remove
-list
-duplicate

Language: Java


DOCUMENTATION FOR PART III

Structure:
-Dbmgr.class is the main file and has the main method which runs with the program execution,
receives the command line parameters and creates an instance of the main class with the functions, 
verifying the existence or abscence of files with extensions and validates the command structure.

Design decisions:
- Since there is a method "<file>.exists()" in java that checks whether
or not the file exists, we used this function to check the existence or
abscence of files and not the sugestion of trying to open them

- To avoid the creation of many different methods to manipulate files, because they require
many lines of code, the code was writen once to be useful for all the methods with conditions while the 
parser goes through each line. In order to this idea work to methods that write files, it was necessary
to save the lines from a file inside a collection (list) every time the program reads a file.
Also this collection was useful to order the file content alphabetically with the built-in method:
Collection.sort(...);

- There are methods inside this class that checks if the parameters are well formed or if the files
are appropriate (checkParams(args) or checkFiles(filename, extension))

Differences: 

- Scheme does not represent classes notation as java does, because java is an object-oriented language.

- As an imperative language, there is a frequent use of loops in java while there is a more frequent use
of recursion in scheme instead for being a functional language.

- In scheme compiled version, the first parameter (index = 0) is the program's name, in java we had to get
the classes name with a specific method to display the helpful message. 

- As in java, to read/write a file it is necessary many code lines, we tried to keep the code shorter
by making a generic method which will present a specific behavior according to the parameters.
For example, if it is a lookup, the loop will break when the keyword is found. When the called function
is print or list, it will display each line of the document while reading it. We also implemented a list to
save each line of the document, so we don't need to read the file again later to write a file with same content.

- Another important difference is that the types in java are static while scheme is a dynamic typing language,
in other words, you don't need to declare explicitly the type of the variables.


Trials:
All the trials worked as expected for the following files:
-data.dat:
Test
New data
Verbatim listing?
2
3
(1 2 3)
       s
\n /n
EOF
The real EOF

-repository.rep
a.dat
b.dat
d.dat
data.dat
e.dat

-new_data.rep

-e.dat


Execution Example:

[aa14@shell extra]$ java Dbmgr lookup data.dat in repository.rep
The data file 'data.dat' is listed in the repository file 'repository.rep'

[aa14@shell extra]$ java Dbmgr lookup x.dat in repository.rep
The data file  'x.dat' is NOT listed in 'repository.rep'


How the design and implementation in java was similar and/or different from the approach in Scheme for the assignment: