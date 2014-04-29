%{
#include <stdio.h>
#include <string.h>
char* data[100][1000][2],*arr1[10][100];
int count=0,i,j,line=1,flag=0,p,counta=0,linea=1,arru,aflag=1;
void yyerror(const char *str)
{
        fprintf(stderr,"error: %s\n",str);
}
 
int yywrap()
{
        return 1;
} 
  
main(){
for(i=0;i<100;i++){
for(j=0;j<1000;j++){
data[i][j][0]="0";
}
}
        yyparse();
printf("%d %d\n",line,count);
for(j=0;j<line;j++){
for(i=0;i<count;i++){

printf("%5s",data[i][j][0]);
}
printf("\n");
}
/*
printf("%d %d\n",linea,counta);

for(j=0;j<linea;j++){
for(i=0;i<counta;i++){
printf("%5s",arr1[i][j]);
}
printf("\n");
}
*/
} 



%}
%token FORTOK  QUOTE OBRACE EBRACE SEMICOLON EQ   SOBRACE SEBRACE LT GT NOT SQOBRACE SQEBRACE INCLUDE FILEN MAIN TYPE COMMA
%union 
{
        int number;
        char *string;
}

%token <string> WORD
%token <number> NUMBER
%token <string> OP
%%
commands:
|commands command    
;

command:INCLUDE LT FILEN GT     {}
|part
|MAIN SOBRACE SEBRACE OBRACE parts EBRACE
|TYPE WORD SOBRACE SEBRACE OBRACE parts EBRACE
;
decl:TYPE WORD dvar
;
dvar:
|SEMICOLON
| COMMA WORD dvar
;
parts:
|parts part
; 

part:decl 
|FORTOK SOBRACE forequ SEMICOLON cond SEMICOLON forequ SEBRACE zonecontent      {} 
|equ SEMICOLON          {line++;}
;
forequ:                  
|equ           {line++;}
;
cond:
WORD condright1 {flag=0;for(i=0;i<count;i++){if(!strcmp(data[i][0][0],$1)){data[i][line][0]="r";flag=1;}}if(flag==0){data[i][0][0]=$1;count++;flag=0;data[i][line][0]="r";}line++;}
;
condright1:LT condright2
|GT condright2 
|EQ condright2
|NOT EQ NUMBER

|NOT EQ WORD     {flag=0;for(i=0;i<count;i++){if(!strcmp(data[i][0][0],$3)){data[i][line][0]="r";flag=1;}}if(flag==0){data[i][0][0]=$3;count++;flag=0;data[i][line][0]="r";}}
;
condright2:
|WORD                 {flag=0;for(i=0;i<count;i++){if(!strcmp(data[i][0][0],$1)){data[i][line][0]="r";flag=1;}}if(flag==0){data[i][0][0]=$1;count++;flag=0;data[i][line][0]="r";}}

|NUMBER                     
|EQ NUMBER                   

|EQ WORD              {flag=0;for(i=0;i<count;i++){if(!strcmp(data[i][0][0],$2)){data[i][line][0]="r";flag=1;}}if(flag==0){data[i][0][0]=$2;count++;flag=0;data[i][line][0]="r";}}
;

zonecontent:
OBRACE zonestatements EBRACE      {}


zonestatements:                                     {}
|zonestatements statements           {}
;

fordec:
|WORD EQ NUMBER        
;

for3equ:
|WORD EQ WORD OP NUMBER      {line++;}            
|WORD OP OP                  {line++;}
;

block:
FORTOK SOBRACE fordec SEMICOLON forequ SEMICOLON for3equ SEBRACE OBRACE zonestatements EBRACE  {}
;

statements: 
| statements statement
;

statement: equ SEMICOLON        {line++;}
|block                          {}    
;

equ:WORD EQ right      {flag=0;for(i=0;i<count;i++){if(!strcmp(data[i][0][0],$1)){if(!strcmp(data[i][line][0],"r")){data[i][line][0]="b";}else{data[i][line][0]="w";}flag=1;}}if(flag==0){data[i][0][0]=$1;count++;flag=0;data[i][line][0]="w";}}


|WORD OP OP            {flag=0;for(i=0;i<count;i++){if(!strcmp(data[i][0][0],$1)){data[i][line][0]="b";flag=1;}}if(flag==0){data[i][0][0]=$1;count++;flag=0;data[i][line][0]="b";}}

|WORD SQOBRACE sib SQEBRACE EQ aright    {flag=0;for(i=0;i<count;i++){if(!strcmp(data[i][0][0],$1)){if(!strcmp(data[i][line][0],"w")){data[i][line][0]="b";}else{data[i][line][0]="r";}flag=1;}}if(flag==0){data[i][0][0]=$1;count++;flag=0;data[i][line][0]="r";}}     
  
|WORD SQOBRACE sib SQEBRACE OP OP           {flag=0;for(i=0;i<count;i++){if(!strcmp(data[i][0][0],$1)){data[i][line][0]="b";flag=1;}}if(flag==0){data[i][0][0]=$1;count++;flag=0;data[i][line][0]="b";}}

|WORD  EQ aright         {flag=0;for(i=0;i<count;i++){if(!strcmp(data[i][0][0],$1)){if(!strcmp(data[i][line][0],"r")){data[i][line][0]="b";}else{data[i][line][0]="w";}flag=1;}}if(flag==0){data[i][0][0]=$1;count++;flag=0;data[i][line][0]="w";}}



right:NUMBER     
        
|WORD OP right        {flag=0;for(i=0;i<count;i++){if(!strcmp(data[i][0][0],$1)){if(!strcmp(data[i][line][0],"w")){data[i][line][0]="b";}else{data[i][line][0]="r";}flag=1;}}if(flag==0){data[i][0][0]=$1;count++;flag=0;data[i][line][0]="r";}}

|WORD                 {flag=0;for(i=0;i<count;i++){if(!strcmp(data[i][0][0],$1)){if(!strcmp(data[i][line][0],"w")){data[i][line][0]="b";}else{data[i][line][0]="r";}flag=1;}}if(flag==0){data[i][0][0]=$1;count++;flag=0;data[i][line][0]="r";}}

|NUMBER OP right
;




sib:WORD OP NUMBER //printf("%d\n",$3);}
|WORD  //flag=0;if(aflag==1){for(i=1;i<linea;i++){if(!strcmp(arr1[arru][i],$1)){flag=1;}}if(flag==0){arr1[arru][i]=$1;linea++;}}}
|NUMBER 
;

aright:NUMBER             
|WORD OP aright        

|WORD                 
|NUMBER OP aright

|WORD SQOBRACE sib SQEBRACE  {flag=0;for(i=0;i<count;i++){if(!strcmp(data[i][0][0],$1)){if(!strcmp(data[i][line][0],"r")){data[i][line][0]="b";}else{data[i][line][0]="w";}flag=1;}}if(flag==0){data[i][0][0]=$1;count++;flag=0;data[i][line][0]="w";}//flag=0;for(i=0;i<counta;i++){if(!strcmp(arr1[i][0],$1)){flag=1;}}if(flag==0){arr1[i][0]=$1;counta++;}arru=i;} 
}

|WORD SQOBRACE sib SQEBRACE OP aright   {flag=0;for(i=0;i<count;i++){if(!strcmp(data[i][0][0],$1)){if(!strcmp(data[i][line][0],"r")){data[i][line][0]="b";}else{data[i][line][0]="w";}flag=1;}}if(flag==0){data[i][0][0]=$1;count++;flag=0;data[i][line][0]="w";}//flag=0;for(i=0;i<counta;i++){if(!strcmp(arr1[i][0],$1)){flag=1;}}if(flag==0){arr1[i][0]=$1;counta++;}arru=i;} 
}
;
