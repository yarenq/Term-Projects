#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define MAX_IDENTIFIER_LENGTH 64
#define MAX_STRING_LENGTH 256
#define MAX_INTEGER_LENGTH 16
#define MAX_SYMBOLS 256

typedef enum {
    Keyword,
    Identifier,
    IntegerConstant,
    StringConstant,
    Operator,
    Comma,
    LeftCurlyBracket,
    RightCurlyBracket,
    EndOfLine,
    EndOfFile
} TokenType;

typedef struct {
    TokenType type;
    char value[MAX_STRING_LENGTH];
} Token;

typedef struct {
    char name[MAX_IDENTIFIER_LENGTH];
    enum { INT, TEXT } type;
    union {
        int intValue;
        char textValue[MAX_STRING_LENGTH];
    } value;
} Symbol;

// Function declarations
void processTokens();
void parseProgram();
void parseStatement();
void parseDeclaration();
void parseRead();
void parseWrite();
void parseNewLine();
void parseLoop();
void parseAssignment();
void addSymbol(const char* name, int type);
Symbol* getSymbol(const char* name);
void setSymbolValue(const char* name, int intValue, const char* textValue);

Symbol symbolTable[MAX_SYMBOLS];
int symbolCount = 0;

Token currentToken;
FILE *source;

int is_valid_identifier_char(int c) {
    return isalnum(c) || c == '_';
}

int is_valid_integer_char(int c) {
    return isdigit(c);
}

void setSymbolValue(const char* name, int intValue, const char* textValue) {
    Symbol *symbol = getSymbol(name);
    if (!symbol) {
        fprintf(stderr, "Semantic error: undeclared variable %s\n", name);
        exit(EXIT_FAILURE);
    }
    if (symbol->type == INT) {
        symbol->value.intValue = intValue;
    } else {
        strcpy(symbol->value.textValue, textValue);
    }
}

Symbol* getSymbol(const char* name) {
    for (int i = 0; i < symbolCount; i++) {
        if (strcmp(symbolTable[i].name, name) == 0) {
            return &symbolTable[i];
        }
    }
    return NULL;
}

void addSymbol(const char* name, int type) {
    if (symbolCount >= MAX_SYMBOLS) {
        fprintf(stderr, "Error: Symbol table overflow\n");
        exit(EXIT_FAILURE);
    }
    strcpy(symbolTable[symbolCount].name, name);
    symbolTable[symbolCount].type = type;
    symbolCount++;
}

void processTokens() {
    int c;
    while ((c = fgetc(source)) != EOF) {
        if (isspace(c)) {
            continue;
        } else if (isalpha(c)) {
            int i = 0;
            while (is_valid_identifier_char(c) && i < MAX_IDENTIFIER_LENGTH - 1) {
                currentToken.value[i++] = c;
                c = fgetc(source);
            }
            if (i >= MAX_IDENTIFIER_LENGTH - 1 && is_valid_identifier_char(c)) {
                fprintf(stderr, "Error: Identifier exceeds maximum length\n");
                exit(EXIT_FAILURE);
            }
            currentToken.value[i] = '\0';
            ungetc(c, source);
            if (strcmp(currentToken.value, "int") == 0 || strcmp(currentToken.value, "text") == 0 ||
                strcmp(currentToken.value, "is") == 0 || strcmp(currentToken.value, "loop") == 0 ||
                strcmp(currentToken.value, "times") == 0 || strcmp(currentToken.value, "read") == 0 ||
                strcmp(currentToken.value, "write") == 0 || strcmp(currentToken.value, "newLine") == 0) {
                currentToken.type = Keyword;
            } else {
                currentToken.type = Identifier;
            }
            return;
        } else if (isdigit(c)) {
            int i = 0;
            while (is_valid_integer_char(c) && i < MAX_INTEGER_LENGTH - 1) {
                currentToken.value[i++] = c;
                c = fgetc(source);
            }
            if (i >= MAX_INTEGER_LENGTH - 1 && is_valid_integer_char(c)) {
                fprintf(stderr, "Error: Integer exceeds maximum number of digits.\n");
                exit(EXIT_FAILURE);
            }
            currentToken.value[i] = '\0';
            ungetc(c, source);
            currentToken.type = IntegerConstant;
            return;
        } else if (c == '"') {
            int i = 0;
            currentToken.value[i++] = '"';
            while ((c = fgetc(source)) != EOF && c != '"' && i < MAX_STRING_LENGTH - 1) {
                currentToken.value[i++] = c;
            }
            if (c != '"') {
                fprintf(stderr, "Error: Unterminated string constant\n");
                exit(EXIT_FAILURE);
            }
            currentToken.value[i++] = '"';
            currentToken.value[i] = '\0';
            currentToken.type = StringConstant;
            return;
        } else if (c == '/') {
            if ((c = fgetc(source)) == '*') {
                int commentEnded = 0;
                while ((c = fgetc(source)) != EOF) {
                    if (c == '*') {
                        if ((c = fgetc(source)) == '/') {
                            commentEnded = 1;
                            break;
                        }
                    }
                }
                if (!commentEnded) {
                    fprintf(stderr, "Error: Unterminated comment\n");
                    exit(EXIT_FAILURE);
                }
            } else {
                ungetc(c, source);
                currentToken.type = Operator;
                strcpy(currentToken.value, "/");
                return;
            }
        } else if (c == '+' || c == '-' || c == '*') {
            currentToken.type = Operator;
            currentToken.value[0] = c;
            currentToken.value[1] = '\0';
            return;
        } else if (c == ',') {
            currentToken.value[0] = ',';
            currentToken.value[1] = '\0';
            currentToken.type = Comma;
            return;
        } else if (c == '{') {
            currentToken.type = LeftCurlyBracket;
            strcpy(currentToken.value, "{");
            return;
        } else if (c == '}') {
            currentToken.type = RightCurlyBracket;
            strcpy(currentToken.value, "}");
            return;
        } else if (c == '.') {
            currentToken.type = EndOfLine;
            strcpy(currentToken.value, ".");
            return;
        } else {
            fprintf(stderr, "Error: Invalid character '%c'\n", c);
            exit(EXIT_FAILURE);
        }
    }
    currentToken.type = EndOfFile;
}

void parseProgram() {
    processTokens();
    while (currentToken.type != EndOfFile) {
        parseStatement();
    }
    printf("\n"); // Dosyanın sonunda bir satır sonu belirteci ekle
}

void parseStatement() {
    if (currentToken.type == Keyword) {
        if (strcmp(currentToken.value, "int") == 0 || strcmp(currentToken.value, "text") == 0) {
            parseDeclaration();
        } else if (strcmp(currentToken.value, "read") == 0) {
            parseRead();
        } else if (strcmp(currentToken.value, "write") == 0) {
            parseWrite();
        } else if (strcmp(currentToken.value, "newLine") == 0) {
            parseNewLine();
        } else if (strcmp(currentToken.value, "loop") == 0) {
            parseLoop();
        }
    } else if (currentToken.type == Identifier) {
        parseAssignment();
    } else if (currentToken.type == EndOfLine) {
        processTokens();
    } else {
        fprintf(stderr, "Syntax error: unexpected token %s\n", currentToken.value);
        exit(EXIT_FAILURE);
    }
}

void parseDeclaration() {
    char varName[MAX_IDENTIFIER_LENGTH];
    int varType = (strcmp(currentToken.value, "int") == 0) ? INT : TEXT;
    processTokens();
    if (currentToken.type != Identifier) {
        fprintf(stderr, "Syntax error: expected identifier after %s\n", varType == INT ? "int" : "text");
        exit(EXIT_FAILURE);
    }
    strcpy(varName, currentToken.value);
    addSymbol(varName, varType);
    processTokens();
    if (currentToken.type == Keyword && strcmp(currentToken.value, "is") == 0) {
        processTokens();
        if (varType == INT) {
            if (currentToken.type != IntegerConstant) {
                fprintf(stderr, "Syntax error: expected integer constant\n");
                exit(EXIT_FAILURE);
            }
            setSymbolValue(varName, atoi(currentToken.value), NULL);
        } else {
            if (currentToken.type != StringConstant) {
                fprintf(stderr, "Syntax error: expected string constant\n");
                exit(EXIT_FAILURE);
            }
            setSymbolValue(varName, 0, currentToken.value);
        }
        processTokens();
    }
    if (currentToken.type != EndOfLine) {
        fprintf(stderr, "Syntax error: expected end of line\n");
        exit(EXIT_FAILURE);
    }
    processTokens();
}

void parseAssignment() {
    char varName[MAX_IDENTIFIER_LENGTH];
    strcpy(varName, currentToken.value);
    processTokens();
    if (currentToken.type != Keyword || strcmp(currentToken.value, "is") != 0) {
        fprintf(stderr, "Syntax error: expected 'is'\n");
        exit(EXIT_FAILURE);
    }
    processTokens();
    Symbol *symbol = getSymbol(varName);
    if (!symbol) {
        fprintf(stderr, "Semantic error: undeclared variable %s\n", varName);
        exit(EXIT_FAILURE);
    }
    if (symbol->type == INT) {
        int result = 0;
        if (currentToken.type == IntegerConstant) {
            result = atoi(currentToken.value);
        } else if (currentToken.type == Identifier) {
            Symbol *rhsSymbol = getSymbol(currentToken.value);
            if (!rhsSymbol || rhsSymbol->type != INT) {
                fprintf(stderr, "Semantic error: invalid right-hand side of assignment\n");
                exit(EXIT_FAILURE);
            }
            result = rhsSymbol->value.intValue;
        } else {
            fprintf(stderr, "Syntax error: invalid right-hand side of assignment\n");
            exit(EXIT_FAILURE);
        }
        setSymbolValue(varName, result, NULL);
    } else { // String variable
        if (currentToken.type != StringConstant && currentToken.type != Identifier) {
            fprintf(stderr, "Syntax error: expected string constant or identifier\n");
            exit(EXIT_FAILURE);
        }
        if (currentToken.type == StringConstant) {
            setSymbolValue(varName, 0, currentToken.value);
        } else if (currentToken.type == Identifier) {
            Symbol *rhsSymbol = getSymbol(currentToken.value);
            if (!rhsSymbol || rhsSymbol->type != TEXT) {
                fprintf(stderr, "Semantic error: invalid right-hand side of assignment\n");
                exit(EXIT_FAILURE);
            }
            setSymbolValue(varName, 0, rhsSymbol->value.textValue);
        }
    }
    processTokens();
    if (currentToken.type != EndOfLine) {
        fprintf(stderr, "Syntax error: expected end of line\n");
        exit(EXIT_FAILURE);
    }
    processTokens();
}


void parseRead() {
    processTokens();
    if (currentToken.type != Identifier) {
        fprintf(stderr, "Syntax error: expected identifier after 'read'\n");
        exit(EXIT_FAILURE);
    }
    char varName[MAX_IDENTIFIER_LENGTH];
    strcpy(varName, currentToken.value);
    Symbol *symbol = getSymbol(varName);
    if (!symbol) {
        fprintf(stderr, "Semantic error: undeclared variable %s\n", varName);
        exit(EXIT_FAILURE);
    }
    if (symbol->type == INT) {
        int value;
        printf("Enter integer value for %s: ", varName);
        scanf("%d", &value);
        setSymbolValue(varName, value, NULL);
    } else {
        char value[MAX_STRING_LENGTH];
        printf("Enter text value for %s: ", varName);
        scanf("%s", value);
        setSymbolValue(varName, 0, value);
    }
    processTokens();
    if (currentToken.type != EndOfLine) {
        fprintf(stderr, "Syntax error: expected end of line\n");
        exit(EXIT_FAILURE);
    }
    processTokens();
}

void parseWrite() {
    processTokens();
    if (currentToken.type != Identifier) {
        fprintf(stderr, "Syntax error: expected identifier after 'write'\n");
        exit(EXIT_FAILURE);
    }
    char varName[MAX_IDENTIFIER_LENGTH];
    strcpy(varName, currentToken.value);
    Symbol *symbol = getSymbol(varName);
    if (!symbol) {
        fprintf(stderr, "Semantic error: undeclared variable %s\n", varName);
        exit(EXIT_FAILURE);
    }
    if (symbol->type == INT) {
        printf("%d\n", symbol->value.intValue);
    } else {
        printf("%s\n", symbol->value.textValue);
    }
    processTokens();
    if (currentToken.type != EndOfLine) {
        fprintf(stderr, "Syntax error: expected end of line\n");
        exit(EXIT_FAILURE);
    }
    processTokens();
}

void parseNewLine() {
    printf("\n");
    processTokens();
    if (currentToken.type != EndOfLine && currentToken.type != EndOfFile) {
        fprintf(stderr, "Syntax error: expected end of line\n");
        exit(EXIT_FAILURE);
    }
}

void parseLoop() {
    int loopCount = 0;
    processTokens();
    if (currentToken.type != IntegerConstant) {
        fprintf(stderr, "Syntax error: expected integer constant after 'loop'\n");
        exit(EXIT_FAILURE);
    }
    loopCount = atoi(currentToken.value);
    processTokens();
    if (currentToken.type != Keyword || strcmp(currentToken.value, "times") != 0) {
        fprintf(stderr, "Syntax error: expected 'times'\n");
        exit(EXIT_FAILURE);
    }
    processTokens();
    if (currentToken.type != LeftCurlyBracket) {
        fprintf(stderr, "Syntax error: expected '{'\n");
        exit(EXIT_FAILURE);
    }
    processTokens();
    for (int i = 1; i <= loopCount; i++) {
        while (currentToken.type != RightCurlyBracket) {
            parseStatement();
        }
        if (i != loopCount) {
            printf("\n");
        }
    }
    if (currentToken.type != RightCurlyBracket) {
        fprintf(stderr, "Syntax error: expected '}'\n");
        exit(EXIT_FAILURE);
    }
    processTokens();
    if (currentToken.type != EndOfLine && currentToken.type != EndOfFile) {
        fprintf(stderr, "Syntax error: expected end of line\n");
        exit(EXIT_FAILURE);
    }
}



int main() {
    source = fopen("source.star", "r");
    if (!source) {
        fprintf(stderr, "Error: Could not open source file\n");
        return 1;
    }
    parseProgram();
    fclose(source);
    return 0;
}