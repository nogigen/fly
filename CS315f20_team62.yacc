/* fly.yacc */
%{
#include <stdio.h>
%}

%union{ double   real;
        int   integer; 
        char* string;
}

%token <real> FLOAT
%token <string> STRING
%token <integer> INTEGER
%token START PRIM_ZERO_PARAM PRIM_ONE_PARAM PRIM_TWO_PARAM DOT COMMA SEMICOLON BOOL LOCATION LIST_INTEGER LIST_FLOAT LIST_BOOL LIST_STRING LIST_LOCATION INT_DECLARATION_or1parameter FLOAT_DECLARATION_or1parameter STR_DECLARATION_or1parameter BOOL_DECLARATION_or1parameter LOCATION_DECLARATION_or1parameter LIST_INT_DECLARATION_or1parameter LIST_FLOAT_DECLARATION_or1parameter LIST_STR_DECLARATION_or1parameter LIST_BOOL_DECLARATION_or1parameter LIST_LOCATION_DECLARATION_or1parameter INPUT OUTPUT RETURN IF ELSE WHILE FOR DEFINE_FUNC CALL_FUNC VARIABLE LP RP LCB RCB LB RB PLUS MINUS TIMES DIVIDE NOT_EQ LESS_EQ GREATER_EQ GREATER LESS ASSIGN_OP COLON EQUAL_OP AND_LOGIC OR_LOGIC CONTINUE BREAK

%left PLUS MINUS
%left TIMES DIVIDE
%left UMINUS

%nonassoc THEN
%nonassoc ELSE
%%

program: START statements
{ printf("\n---------syntax is valid!--------\n");}
;

statements: /* empty */
	   | statements statement
;

statement: assignment SEMICOLON
	 | if_statement
	 | for_statement
	 | while_statement
	 | define_func_statement
	 | functionNum SEMICOLON
         | return_statement SEMICOLON
	 | output_statement SEMICOLON
	 | input_statement SEMICOLON
	 | CONTINUE SEMICOLON
	 | BREAK SEMICOLON
;

assignment: VARIABLE ASSIGN_OP limitedExpr
	   | VARIABLE ASSIGN_OP conditions
	   | VARIABLE ASSIGN_OP input_statement
	   | VARIABLE ASSIGN_OP LIST_INTEGER
	   | VARIABLE ASSIGN_OP LIST_FLOAT
	   | VARIABLE ASSIGN_OP LIST_BOOL
	   | VARIABLE ASSIGN_OP LIST_STRING
	   | VARIABLE ASSIGN_OP LIST_LOCATION

	   | INT_DECLARATION_or1parameter ASSIGN_OP intExpr
	   | INT_DECLARATION_or1parameter ASSIGN_OP noTypeExpr
	   | INT_DECLARATION_or1parameter ASSIGN_OP input_statement
           | FLOAT_DECLARATION_or1parameter ASSIGN_OP floatExpr
	   | FLOAT_DECLARATION_or1parameter ASSIGN_OP noTypeExpr
	   | FLOAT_DECLARATION_or1parameter ASSIGN_OP input_statement
	   | STR_DECLARATION_or1parameter ASSIGN_OP strExpr
	   | STR_DECLARATION_or1parameter ASSIGN_OP noTypeExpr
	   | STR_DECLARATION_or1parameter ASSIGN_OP input_statement
	   | BOOL_DECLARATION_or1parameter ASSIGN_OP boolExpr
	   | BOOL_DECLARATION_or1parameter ASSIGN_OP input_statement
	   | LOCATION_DECLARATION_or1parameter ASSIGN_OP locExpr
	   | LOCATION_DECLARATION_or1parameter ASSIGN_OP noTypeExpr
	   | LOCATION_DECLARATION_or1parameter ASSIGN_OP input_statement

	   | LIST_INT_DECLARATION_or1parameter ASSIGN_OP LIST_INTEGER
	   | LIST_INT_DECLARATION_or1parameter ASSIGN_OP noTypeExpr
	   | LIST_INT_DECLARATION_or1parameter ASSIGN_OP input_statement
	   | LIST_FLOAT_DECLARATION_or1parameter ASSIGN_OP LIST_FLOAT
	   | LIST_FLOAT_DECLARATION_or1parameter ASSIGN_OP noTypeExpr
	   | LIST_FLOAT_DECLARATION_or1parameter ASSIGN_OP input_statement
	   | LIST_BOOL_DECLARATION_or1parameter ASSIGN_OP LIST_BOOL
	   | LIST_BOOL_DECLARATION_or1parameter ASSIGN_OP noTypeExpr
	   | LIST_BOOL_DECLARATION_or1parameter ASSIGN_OP input_statement
	   | LIST_STR_DECLARATION_or1parameter ASSIGN_OP LIST_STRING
	   | LIST_STR_DECLARATION_or1parameter ASSIGN_OP noTypeExpr
	   | LIST_STR_DECLARATION_or1parameter ASSIGN_OP input_statement
	   | LIST_LOCATION_DECLARATION_or1parameter ASSIGN_OP LIST_LOCATION
	   | LIST_LOCATION_DECLARATION_or1parameter ASSIGN_OP noTypeExpr
	   | LIST_LOCATION_DECLARATION_or1parameter ASSIGN_OP input_statement
;

define_parameters: define_parameter
		  | define_parameter COMMA define_parameters
;

define_parameter: /* nothing */
		 | INT_DECLARATION_or1parameter | FLOAT_DECLARATION_or1parameter
		 | STR_DECLARATION_or1parameter | BOOL_DECLARATION_or1parameter | LOCATION_DECLARATION_or1parameter
		 | LIST_INT_DECLARATION_or1parameter | LIST_FLOAT_DECLARATION_or1parameter 
		 | LIST_STR_DECLARATION_or1parameter | LIST_BOOL_DECLARATION_or1parameter | LIST_LOCATION_DECLARATION_or1parameter

define_func_statement: DEFINE_FUNC LP define_parameters RP LB statements RB
;

parameters: parameter 
            | parameters COMMA parameter
;

parameter: /* empty */
	   | intExpr | floatExpr | strExpr | boolExpr | locExpr | LIST_INTEGER | LIST_FLOAT | LIST_BOOL | LIST_STRING | LIST_LOCATION

functionNum: PRIM_ZERO_PARAM LP RP
	    | PRIM_ONE_PARAM LP parameter RP
	    | PRIM_TWO_PARAM LP parameter COMMA parameter RP
  	    | CALL_FUNC LP parameters RP	 
;

output_statement: OUTPUT LP strExpr RP
		  | OUTPUT LP intExpr RP
		  | OUTPUT LP floatExpr RP
		  | OUTPUT LP boolExpr RP
		  | OUTPUT LP locExpr RP
		  | OUTPUT LP LIST_INTEGER RP
		  | OUTPUT LP LIST_FLOAT RP
		  | OUTPUT LP LIST_STRING RP
		  | OUTPUT LP LIST_BOOL RP
		  | OUTPUT LP LIST_LOCATION RP
;

input_statement: INPUT LP strExpr RP
		 | INPUT LP noTypeExpr RP
;

return_statement: RETURN | RETURN boolExpr | RETURN intExpr | RETURN floatExpr | RETURN  strExpr | RETURN locExpr | RETURN LIST_INTEGER | RETURN LIST_FLOAT | RETURN LIST_BOOL | RETURN LIST_LOCATION
;

expr: intExpr | floatExpr | strExpr | locExpr | noTypeExpr
;

limitedExpr: intExpr | floatExpr | strExpr | locExpr
;

noTypeExpr: functionNum | VARIABLE
	 | noTypeExpr PLUS noTypeExpr
	 | noTypeExpr MINUS noTypeExpr
	 | noTypeExpr TIMES noTypeExpr
	 | noTypeExpr DIVIDE noTypeExpr
	 | MINUS noTypeExpr %prec UMINUS
	 | LP noTypeExpr RP
;

logics: AND_LOGIC | OR_LOGIC
;
cond_idents: LESS_EQ | GREATER_EQ | GREATER | LESS | EQUAL_OP | NOT_EQ
;

condition: LP expr cond_idents expr RP |LP condition logics condition RP | expr cond_idents expr | noTypeExpr | BOOL
;

conditions: condition | condition logics conditions
;

if_statement: IF LP conditions RP LB statements RB           %prec THEN
   	    | IF LP conditions RP LB statements RB ELSE LB statements RB
;


for_statement: FOR LP assignment SEMICOLON conditions SEMICOLON assignment RP LB statements RB
;


while_statement: WHILE LP conditions RP LB statements RB
;

intExpr: INTEGER
	| intExpr PLUS intExpr
	| intExpr MINUS intExpr
	| intExpr TIMES intExpr
	| intExpr DIVIDE intExpr

	| noTypeExpr PLUS intExpr
	| noTypeExpr MINUS intExpr
	| noTypeExpr TIMES intExpr
	| noTypeExpr DIVIDE intExpr

	| intExpr PLUS noTypeExpr
	| intExpr MINUS noTypeExpr
	| intExpr TIMES noTypeExpr
	| intExpr DIVIDE noTypeExpr

	| MINUS intExpr %prec UMINUS
	| LP intExpr RP
;

floatExpr: FLOAT
	| floatExpr PLUS floatExpr
	| floatExpr MINUS floatExpr
	| floatExpr TIMES floatExpr
	| floatExpr DIVIDE floatExpr
	| MINUS floatExpr %prec UMINUS
	| LP floatExpr RP

	| floatExpr PLUS intExpr
	| floatExpr MINUS intExpr
	| floatExpr TIMES intExpr
	| floatExpr DIVIDE intExpr

	| intExpr PLUS floatExpr
	| intExpr MINUS floatExpr
	| intExpr TIMES floatExpr
	| intExpr DIVIDE floatExpr

	| noTypeExpr PLUS floatExpr
	| noTypeExpr MINUS floatExpr
	| noTypeExpr TIMES floatExpr
	| noTypeExpr DIVIDE floatExpr

	| floatExpr PLUS noTypeExpr
	| floatExpr MINUS noTypeExpr
	| floatExpr TIMES noTypeExpr
	| floatExpr DIVIDE noTypeExpr
;


strExpr: STRING
        | strExpr PLUS strExpr
	| noTypeExpr PLUS strExpr
	| strExpr PLUS noTypeExpr
        | LP strExpr RP 
;

boolExpr: conditions
;

locExpr: LOCATION
	 | locExpr PLUS locExpr
	 | locExpr MINUS locExpr
	 | locExpr TIMES locExpr
	 | locExpr DIVIDE locExpr

	 | locExpr PLUS floatExpr
	 | locExpr MINUS floatExpr
	 | locExpr TIMES floatExpr
	 | locExpr DIVIDE floatExpr

	 | floatExpr PLUS locExpr
	 | floatExpr MINUS locExpr
	 | floatExpr TIMES locExpr
	 | floatExpr DIVIDE locExpr

	 | noTypeExpr PLUS locExpr
	 | noTypeExpr MINUS locExpr
	 | noTypeExpr TIMES locExpr
	 | noTypeExpr DIVIDE locExpr

	 | locExpr PLUS noTypeExpr
	 | locExpr MINUS noTypeExpr
	 | locExpr TIMES noTypeExpr
	 | locExpr DIVIDE noTypeExpr

	 | MINUS locExpr %prec UMINUS
	 | LP locExpr RP
;

%%
#include "lex.yy.c"
int lineno;

main() {
    
  return yyparse();
}

yyerror( char *s ) { fprintf( stderr, "%s in line number: %d\n", s, (lineno + 1)); };