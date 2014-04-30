%{ 
#include <stdio.h> 
#include <string.h>
#include "y.tab.h"
%}
%%
for      return FORTOK;
"#include"             return INCLUDE;
[a-zA-Z0-9]+\.[a-zA-Z0-9]+ return FILEN;
"main"           return MAIN;
\(               return SOBRACE;
\)               return SEBRACE;
int|float|char   return TYPE;
,                         return COMMA;
[0-9]+               yylval.number=atoi(yytext);return NUMBER ;
[a-zA-Z0-9]+     yylval.string=strdup(yytext); return WORD; 
[+*-/]                    return OP;
\"                      return QUOTE;
\{                      return OBRACE;
\}                      return EBRACE;
\]                      return SQEBRACE;
\[                      return SQOBRACE;
;                       return SEMICOLON;
\>                       return GT;
\<                       return LT;
\!                       return NOT;
=                       return EQ;
\n                    ;
[ \t]+                 ;

%%

