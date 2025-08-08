%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

// Token definitions
#define TOKEN_KEYWORD 1
#define TOKEN_IDENTIFIER 2
#define TOKEN_LITERAL 3
#define TOKEN_OPERATOR 4
#define TOKEN_PUNCTUATION 5
#define TOKEN_COMMENT 6
#define TOKEN_STRING 7
#define TOKEN_PREPROCESSOR 8

extern int yylineno;
extern char* yytext;

// Function declarations
void print_token(int token_type, char* token_value, int line);
%}

%option yylineno
%option noyywrap

/* C Keywords */
KEYWORD (auto|break|case|char|const|continue|default|do|double|else|enum|extern|float|for|goto|if|int|long|register|return|short|signed|sizeof|static|struct|switch|typedef|union|unsigned|void|volatile|while)

/* Identifiers */
IDENTIFIER [a-zA-Z_][a-zA-Z0-9_]*

/* Numbers */
DIGIT [0-9]
INTEGER {DIGIT}+
FLOAT {DIGIT}+\.{DIGIT}*|{DIGIT}*\.{DIGIT}+
EXPONENT [eE][+-]?{DIGIT}+
SCIENTIFIC {FLOAT}{EXPONENT}|{INTEGER}{EXPONENT}

/* Character and String literals */
CHAR_LITERAL \'([^\\\']|\\.)\'
STRING_LITERAL \"([^\\\"]|\\.)*\"

/* Comments */
SINGLE_LINE_COMMENT \/\/.*
MULTI_LINE_COMMENT \/\*([^*]|\*+[^*/])*\*+\/

/* Operators */
OPERATOR (\+\+|--|->|\.|<=|>=|==|!=|\+\=|-\=|\*=|/=|%=|<<=|>>=|&=|\|=|\^=|&&|\|\||<<|>>|\+|-|\*|/|%|<|>|=|!|&|\||\^|~|\?|:)

/* Punctuation */
PUNCTUATION [(){}\[\];,]

/* Preprocessor directives */
PREPROCESSOR #[a-zA-Z]+

/* Whitespace */
WHITESPACE [ \t]+

/* Newlines */
NEWLINE \n

%%

{KEYWORD} {
    print_token(TOKEN_KEYWORD, yytext, yylineno);
}

{IDENTIFIER} {
    print_token(TOKEN_IDENTIFIER, yytext, yylineno);
}

{INTEGER} {
    print_token(TOKEN_LITERAL, yytext, yylineno);
}

{FLOAT} {
    print_token(TOKEN_LITERAL, yytext, yylineno);
}

{SCIENTIFIC} {
    print_token(TOKEN_LITERAL, yytext, yylineno);
}

{CHAR_LITERAL} {
    print_token(TOKEN_LITERAL, yytext, yylineno);
}

{STRING_LITERAL} {
    print_token(TOKEN_STRING, yytext, yylineno);
}

{SINGLE_LINE_COMMENT} {
    print_token(TOKEN_COMMENT, yytext, yylineno);
}

{MULTI_LINE_COMMENT} {
    print_token(TOKEN_COMMENT, yytext, yylineno);
}

{OPERATOR} {
    print_token(TOKEN_OPERATOR, yytext, yylineno);
}

{PUNCTUATION} {
    print_token(TOKEN_PUNCTUATION, yytext, yylineno);
}

{PREPROCESSOR} {
    print_token(TOKEN_PREPROCESSOR, yytext, yylineno);
}

{WHITESPACE} {
    /* Skip whitespace */
}

{NEWLINE} {
    /* Skip newlines but they increment yylineno */
}

. {
    printf("Unknown character: %s at line %d\n", yytext, yylineno);
}

%%

void print_token(int token_type, char* token_value, int line) {
    char* type_name;
    
    switch(token_type) {
        case TOKEN_KEYWORD:
            type_name = "KEYWORD";
            break;
        case TOKEN_IDENTIFIER:
            type_name = "IDENTIFIER";
            break;
        case TOKEN_LITERAL:
            type_name = "LITERAL";
            break;
        case TOKEN_OPERATOR:
            type_name = "OPERATOR";
            break;
        case TOKEN_PUNCTUATION:
            type_name = "PUNCTUATION";
            break;
        case TOKEN_COMMENT:
            type_name = "COMMENT";
            break;
        case TOKEN_STRING:
            type_name = "STRING";
            break;
        case TOKEN_PREPROCESSOR:
            type_name = "PREPROCESSOR";
            break;
        default:
            type_name = "UNKNOWN";
    }
    
    printf("Token: %-20s Type: %-15s Line: %d\n", token_value, type_name, line);
}

int main(int argc, char* argv[]) {
    if (argc != 2) {
        printf("Usage: %s <input_file>\n", argv[0]);
        return 1;
    }
    
    FILE* file = fopen(argv[1], "r");
    if (!file) {
        printf("Error: Cannot open file %s\n", argv[1]);
        return 1;
    }
    
    yyin = file;
    printf("Token Table:\n");
    printf("%-20s %-15s %s\n", "Token", "Type", "Line");
    printf("------------------------------------------------\n");
    
    yylex();
    
    fclose(file);
    return 0;
}
