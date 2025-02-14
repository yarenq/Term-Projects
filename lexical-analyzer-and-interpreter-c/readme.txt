This project consists of two components:

Lexical Analyzer – A program that scans a STAR source file (.sta) and outputs a list of tokens.
Interpreter – A program that executes STAR scripts by parsing and interpreting the language’s syntax and semantics.
Project 1: Lexical Analyzer
The lexical analyzer reads a STAR source file (code.sta) and generates a tokenized output (code.lex). It enforces language rules, detects errors (such as oversized identifiers or strings), and classifies tokens into categories like keywords, identifiers, operators, and constants.

Features
Tokenization of STAR source code (identifiers, integers, keywords, operators, brackets, strings, etc.).
Error Handling for oversized identifiers, integers, and unterminated strings or comments.
Output is a structured list of tokens that can be used for parsing.
Example Input:
r
Copy
Edit
c is c/2.
Example Output (code.lex):
scss
Copy
Edit
Identifier(c)  
Keyword(is)  
Identifier(c)  
Operator(/)  
EndOfLine  
Project 2: Interpreter
The interpreter reads STAR scripts, executes commands, and handles variables, loops, and input/output. It ensures adherence to STAR’s syntax and performs calculations while enforcing constraints (e.g., integers remain positive, strings have a max length of 256 characters).

Features
Variable Declaration and Initialization (int and text types).
Assignment Operations with arithmetic and string manipulation.
I/O Operations (read, write, newLine).
Loop Support using loop X times.
Operator Constraints ensuring only allowed operations.
Error Handling for integer overflows, negative values, and invalid assignments.
Example Input:
pgsql
Copy
Edit
int a, b.
read "First:" a.
read "Second:" b.
a is a + b.
write "Sum:", a.
Example Output:
makefile
Copy
Edit
First: 10  
Second: 5  
Sum: 15  
