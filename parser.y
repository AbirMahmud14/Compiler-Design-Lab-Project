%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Symbol table structure
typedef struct {
    char* name;
    char* type;
    char* scope;
    int line;
} Symbol;

// Symbol table
Symbol symbol_table[1000];
int symbol_count = 0;

// Function declarations
void add_symbol(char* name, char* type, char* scope, int line);
void print_symbol_table();
int yylex();
void yyerror(const char* s);

extern int yylineno;
extern char* yytext;
%}

%token TOKEN_KEYWORD TOKEN_IDENTIFIER TOKEN_LITERAL TOKEN_OPERATOR TOKEN_PUNCTUATION TOKEN_COMMENT TOKEN_STRING TOKEN_PREPROCESSOR

%token <str> IDENTIFIER
%token <str> NUMBER
%token <str> STRING
%token <str> CHAR_LITERAL
%token <str> COMMENT

%token INT CHAR FLOAT DOUBLE VOID
%token IF ELSE WHILE FOR DO SWITCH CASE DEFAULT
%token RETURN BREAK CONTINUE
%token STRUCT UNION ENUM TYPEDEF
%token STATIC EXTERN AUTO REGISTER
%token CONST VOLATILE
%token SIZEOF
%token INCLUDE DEFINE

%token PLUS MINUS MULTIPLY DIVIDE MODULO
%token ASSIGN PLUS_ASSIGN MINUS_ASSIGN MULTIPLY_ASSIGN DIVIDE_ASSIGN MODULO_ASSIGN
%token EQUAL NOT_EQUAL LESS GREATER LESS_EQUAL GREATER_EQUAL
%token AND OR NOT BITWISE_AND BITWISE_OR BITWISE_XOR BITWISE_NOT
%token LEFT_SHIFT RIGHT_SHIFT LEFT_SHIFT_ASSIGN RIGHT_SHIFT_ASSIGN
%token AND_ASSIGN OR_ASSIGN XOR_ASSIGN
%token INCREMENT DECREMENT
%token ARROW DOT
%token QUESTION COLON

%token LPAREN RPAREN LBRACE RBRACE LBRACKET RBRACKET
%token SEMICOLON COMMA

%type <str> type_specifier
%type <str> declaration
%type <str> statement
%type <str> expression

%%

program
    : translation_unit
    ;

translation_unit
    : external_declaration
    | translation_unit external_declaration
    ;

external_declaration
    : function_definition
    | declaration
    | preprocessor_directive
    ;

function_definition
    : type_specifier IDENTIFIER LPAREN parameter_list RPAREN compound_statement
    {
        add_symbol($2, "function", "global", yylineno);
        printf("Function defined: %s\n", $2);
    }
    ;

parameter_list
    : /* empty */
    | parameter_declaration_list
    ;

parameter_declaration_list
    : parameter_declaration
    | parameter_declaration_list COMMA parameter_declaration
    ;

parameter_declaration
    : type_specifier IDENTIFIER
    {
        add_symbol($2, "parameter", "function", yylineno);
    }
    ;

compound_statement
    : LBRACE statement_list RBRACE
    ;

statement_list
    : /* empty */
    | statement_list statement
    ;

statement
    : expression_statement
    | compound_statement
    | selection_statement
    | iteration_statement
    | jump_statement
    | declaration_statement
    ;

expression_statement
    : expression SEMICOLON
    ;

selection_statement
    : IF LPAREN expression RPAREN statement
    | IF LPAREN expression RPAREN statement ELSE statement
    | SWITCH LPAREN expression RPAREN statement
    ;

iteration_statement
    : WHILE LPAREN expression RPAREN statement
    | FOR LPAREN expression_statement expression_statement expression RPAREN statement
    | FOR LPAREN expression_statement expression_statement RPAREN statement
    | DO statement WHILE LPAREN expression RPAREN SEMICOLON
    ;

jump_statement
    : RETURN expression SEMICOLON
    | BREAK SEMICOLON
    | CONTINUE SEMICOLON
    ;

declaration_statement
    : declaration SEMICOLON
    ;

declaration
    : type_specifier init_declarator_list
    ;

init_declarator_list
    : init_declarator
    | init_declarator_list COMMA init_declarator
    ;

init_declarator
    : IDENTIFIER
    {
        add_symbol($1, "variable", "local", yylineno);
    }
    | IDENTIFIER ASSIGN expression
    {
        add_symbol($1, "variable", "local", yylineno);
    }
    ;

type_specifier
    : INT { $$ = "int"; }
    | CHAR { $$ = "char"; }
    | FLOAT { $$ = "float"; }
    | DOUBLE { $$ = "double"; }
    | VOID { $$ = "void"; }
    ;

expression
    : assignment_expression
    | expression COMMA assignment_expression
    ;

assignment_expression
    : logical_or_expression
    | IDENTIFIER ASSIGN assignment_expression
    | IDENTIFIER PLUS_ASSIGN assignment_expression
    | IDENTIFIER MINUS_ASSIGN assignment_expression
    | IDENTIFIER MULTIPLY_ASSIGN assignment_expression
    | IDENTIFIER DIVIDE_ASSIGN assignment_expression
    | IDENTIFIER MODULO_ASSIGN assignment_expression
    | IDENTIFIER LEFT_SHIFT_ASSIGN assignment_expression
    | IDENTIFIER RIGHT_SHIFT_ASSIGN assignment_expression
    | IDENTIFIER AND_ASSIGN assignment_expression
    | IDENTIFIER OR_ASSIGN assignment_expression
    | IDENTIFIER XOR_ASSIGN assignment_expression
    ;

logical_or_expression
    : logical_and_expression
    | logical_or_expression OR logical_and_expression
    ;

logical_and_expression
    : inclusive_or_expression
    | logical_and_expression AND inclusive_or_expression
    ;

inclusive_or_expression
    : exclusive_or_expression
    | inclusive_or_expression BITWISE_OR exclusive_or_expression
    ;

exclusive_or_expression
    : and_expression
    | exclusive_or_expression BITWISE_XOR and_expression
    ;

and_expression
    : equality_expression
    | and_expression BITWISE_AND equality_expression
    ;

equality_expression
    : relational_expression
    | equality_expression EQUAL relational_expression
    | equality_expression NOT_EQUAL relational_expression
    ;

relational_expression
    : shift_expression
    | relational_expression LESS shift_expression
    | relational_expression GREATER shift_expression
    | relational_expression LESS_EQUAL shift_expression
    | relational_expression GREATER_EQUAL shift_expression
    ;

shift_expression
    : additive_expression
    | shift_expression LEFT_SHIFT additive_expression
    | shift_expression RIGHT_SHIFT additive_expression
    ;

additive_expression
    : multiplicative_expression
    | additive_expression PLUS multiplicative_expression
    | additive_expression MINUS multiplicative_expression
    ;

multiplicative_expression
    : cast_expression
    | multiplicative_expression MULTIPLY cast_expression
    | multiplicative_expression DIVIDE cast_expression
    | multiplicative_expression MODULO cast_expression
    ;

cast_expression
    : unary_expression
    ;

unary_expression
    : postfix_expression
    | INCREMENT unary_expression
    | DECREMENT unary_expression
    | unary_operator cast_expression
    ;

unary_operator
    : PLUS
    | MINUS
    | BITWISE_NOT
    | NOT
    ;

postfix_expression
    : primary_expression
    | postfix_expression LPAREN argument_expression_list RPAREN
    | postfix_expression LPAREN RPAREN
    | postfix_expression LBRACKET expression RBRACKET
    | postfix_expression DOT IDENTIFIER
    | postfix_expression ARROW IDENTIFIER
    | postfix_expression INCREMENT
    | postfix_expression DECREMENT
    ;

primary_expression
    : IDENTIFIER
    | NUMBER
    | STRING
    | CHAR_LITERAL
    | LPAREN expression RPAREN
    ;

argument_expression_list
    : assignment_expression
    | argument_expression_list COMMA assignment_expression
    ;

preprocessor_directive
    : INCLUDE STRING
    | DEFINE IDENTIFIER
    | DEFINE IDENTIFIER NUMBER
    ;

%%

void add_symbol(char* name, char* type, char* scope, int line) {
    // Check if symbol already exists
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbol_table[i].name, name) == 0) {
            return; // Symbol already exists
        }
    }
    
    if (symbol_count < 1000) {
        symbol_table[symbol_count].name = strdup(name);
        symbol_table[symbol_count].type = strdup(type);
        symbol_table[symbol_count].scope = strdup(scope);
        symbol_table[symbol_count].line = line;
        symbol_count++;
    }
}

void print_symbol_table() {
    printf("\nSymbol Table:\n");
    printf("%-20s %-15s %-10s %s\n", "Symbol", "Type", "Scope", "Line");
    printf("------------------------------------------------\n");
    
    for (int i = 0; i < symbol_count; i++) {
        printf("%-20s %-15s %-10s %d\n", 
               symbol_table[i].name, 
               symbol_table[i].type, 
               symbol_table[i].scope, 
               symbol_table[i].line);
    }
}

void yyerror(const char* s) {
    fprintf(stderr, "Error at line %d: %s\n", yylineno, s);
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
    printf("Parsing C code...\n");
    
    int result = yyparse();
    
    if (result == 0) {
        printf("Parsing completed successfully!\n");
        print_symbol_table();
    } else {
        printf("Parsing failed!\n");
    }
    
    fclose(file);
    return result;
}
