#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

//constants
#define MAX_IDENTIFIER_LENGTH 10
#define MAX_INTEGER_LENGTH 8
#define MAX_STRING_LENGTH 256

//defining token types
typedef enum {
    Identifier, IntegerConstant, 
    Operator, LeftCurlyBracket, 
    RightCurlyBracket, StringConstant, 
    Keyword, EndOfLine, Comma
    } TokenType;

//structure to represent a token and it's attributes
typedef struct {
    TokenType type;
    char value[MAX_STRING_LENGTH];
} Token;

//function to check if a character is a valid identifier character
int is_valid_identifier_char(char c) {
    return isalnum(c) || c == '_';
}

//function to check if a character is a valid integer character
int is_valid_integer_char(char c) {
    return isdigit(c);
}

int is_valid_string_char(char c) {
    return c == '"' || isalnum(c) || c == ' '; 
}

void tokenize(FILE *source, FILE *output) { //giving FILE pointers as arguments
    char c;
    Token token;
    while ((c = fgetc(source)) != EOF) { //continues looping until the pointer reaches the EOF
        if (isspace(c)) {
            continue; //ignores whitespace
        } 
        
        else if (isalpha(c)) { 
            //identifier or keyword
            int i = 0;
            while (is_valid_identifier_char(c) && i < MAX_IDENTIFIER_LENGTH - 1) { //loops through the characters in a token
                token.value[i++] = c; //adds the characters to value (char array) of the token
                c = fgetc(source);  //reads the next char 
            }
            if (i >= MAX_IDENTIFIER_LENGTH - 1 && is_valid_identifier_char(c)) {
                fprintf(stderr, "Error: Identifier exceeds maximum length\n");
                exit(EXIT_FAILURE);
            }
            token.value[i] = '\0'; //default null char to state the end of the string
            ungetc(c, source);
            //determining if the token is an identifier or a keyword 
            if (strcmp(token.value, "int") == 0 || strcmp(token.value, "text") == 0 ||
                strcmp(token.value, "is") == 0 || strcmp(token.value, "loop") == 0 ||
                strcmp(token.value, "times") == 0 || strcmp(token.value, "read") == 0 ||
                strcmp(token.value, "write") == 0 || strcmp(token.value, "newLine") == 0) {
                token.type = Keyword;
            } else {
                token.type = Identifier;
            }
        } 
        
        else if (isdigit(c)) {
            //integer constant
            int i = 0;
            while (is_valid_integer_char(c) && i < MAX_INTEGER_LENGTH - 1) {
                token.value[i++] = c;
                c = fgetc(source);
            }
            if (i >= MAX_INTEGER_LENGTH - 1 && is_valid_integer_char(c)) {
                fprintf(stderr, "Error: Integer exceeds maximum number of digits.\n");
                exit(EXIT_FAILURE);
            }           
            token.value[i] = '\0';
            ungetc(c, source);
            token.type = IntegerConstant;
        } 
        
        else if (c == '"') {
            //string constant
            int i = 0;
            token.value[i++] = '"';
            while ((c = fgetc(source)) != EOF && c != '"' && i < MAX_STRING_LENGTH - 1) {
                token.value[i++] = c;
            }
            if (c != '"') {
                fprintf(stderr, "Error: Unterminated string constant\n");
                exit(EXIT_FAILURE);
            }
            token.value[i++] = '"';
            token.value[i] = '\0';
            token.type = StringConstant;
        }

        else if (c == '/') {
            //possible comment
            if ((c = fgetc(source)) == '*') {
                int commentEnded = 0; //checks if the comments end properly
                while ((c = fgetc(source)) != EOF) {
                    if (c == '*') {
                        //checks if it's the end of comment
                        if ((c = fgetc(source)) == '/') {
                            commentEnded = 1; //sets the comment flag to indicate end
                            break;
                        }
                    }
                }
                if (!commentEnded) {
                    fprintf(stderr, "Error: Unterminated comment\n");
                    exit(EXIT_FAILURE);
                }
            } else {
                //not a comment, operator
                ungetc(c, source);
                token.type = Operator;
                strcpy(token.value, "/");
            }


        } else if (c == '+' || c == '-' || c == '*') {
            //operators
            token.type = Operator;
            token.value[0] = c;
            token.value[1] = '\0';
        } else if (c == ',') {
            //comma
            token.value[0] = '\0';
            token.type = Comma;
        }

        //brackets
        else if (c == '{') {
            token.type = LeftCurlyBracket;
            strcpy(token.value, "{");
        } else if (c == '}') {
            token.type = RightCurlyBracket;
            strcpy(token.value, "}");
        } 
        
        //end of line
        else if (c == '.') {
            token.type = EndOfLine;
            strcpy(token.value, ".");
        }
        
        else {
            fprintf(stderr, "Error: Invalid character '%c'\n", c);
            exit(EXIT_FAILURE);
        }

        //the string format for printing
        const char *formatString;
            if (token.type == EndOfLine || token.type == LeftCurlyBracket || token.type == RightCurlyBracket) {
                formatString = "%s\n";  //prints only the token name
            } else if (token.type == Comma){
                formatString = ""; //doesn't print anything
            }
             else {
                formatString = "%s(%s)\n";  //prints the token name with its value
            }

        //writing the tokens to the output file according to the format string
        fprintf(output, formatString,
            (token.type == Keyword ? "Keyword" :
            token.type == Identifier ? "Identifier" :
            token.type == IntegerConstant ? "IntConst" :
            token.type == Operator ? "Operator" :
            token.type == LeftCurlyBracket ? "LeftCurlyBracket" :
            token.type == RightCurlyBracket ? "RightCurlyBracket" :
            token.type == StringConstant ? "String" :
            token.type == EndOfLine ? "EndOfLine" : "Unknown Token"),
            token.value);
            
    }
}


int main() {
    FILE *source, *output;  //creating the FILE pointers
    source = fopen("code.sta", "r");
    if (source == NULL) {
        fprintf(stderr, "Unable to open code.sta source file.\n");
        return EXIT_FAILURE;
    }
    output = fopen("code.lex", "w"); //creating the output file
    if (output == NULL) {
        fprintf(stderr, "Unable to create code.lex output file.\n");
        fclose(source);
        return EXIT_FAILURE;
    }
    tokenize(source, output); //tokenizing process
    fclose(source);
    fclose(output);
    printf("Lexical analysis is completed.\n"); //successful analysis
    return EXIT_SUCCESS;
}
