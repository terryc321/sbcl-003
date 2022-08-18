
#include <stdlib.h>
#include <stdio.h>
#include <string.h>


/* ------------------------------ */
struct abc_struct
{
  int a;
  int b;
  int c;  
};

struct abc_struct *inc_all (abc)
     struct abc_struct *abc;
{
  abc->a += 1;
  abc->b += 2;
  abc->c += 3;
  return(abc);
}

struct abc_struct *make_abc_struct (int n)
{
  struct abc_struct *p = malloc(sizeof(struct abc_struct));

  // assume it works ...?
  
  p->a = 0;
  p->b = 0;
  p->c = 0;
  return p;
}


/* -------- passed test ------------- */
int string_length(char *p)
{
  // assuming 
  return strlen(p);
}



struct c_struct
{
  int x;
  char *s;
};

struct c_struct *c_function (i, s, r, a)
    int i;
    char *s;
    struct c_struct *r;
    int a[10];
{
  int j;
  struct c_struct *r2;

  printf("i = %d\n", i);
  printf("s = %s\n", s);
  printf("r->x = %d\n", r->x);
  printf("r->s = %s\n", r->s);
  for (j = 0; j < 10; j++) printf("a[%d] = %d.\n", j, a[j]);
  r2 = (struct c_struct *) malloc (sizeof(struct c_struct));
  r2->x = i + 5;
  r2->s = "a C string";
  return(r2);
};


/* passes sanity check -- sbcl + 1 success mark */
int fg (int x){
  return x + x;
}

/* lets see if we can print to *standard-output* of common lisp */
char *hi (char *p)
{
  return p;
}


/* attempts to mutate pointer of a string as
 its passed in , could cause some interesting
 bugs
 just reversing the text passed in
*/
char *revhi (char *p)
{
  int len =strlen(p);
  char *str = malloc(sizeof(char)*(len + 1));
  int i = 0;
  for( i= 0; i < len ; i++){
       str[i] = p[len - i - 1] ;       
  }
  for( i= 0; i < len ; i++){
    p[i] = str[i];
  }
  free((void *)str);       
  return p;
}


/*
ncurses setup procedure

sbcl maintain the game loop

expose key press routine

see if we can get flat 2d game up and running

maybe like tower of hanoi

nyacc - can it produce the
define-alien-type
define-alien-routine ?

asdf

*/


void empty(){
  FILE *fp = fopen("empty","wb");
  if (fp){
    fprintf(fp,"this is the empty file");
    fclose(fp);
  }
}

void empty2(char *str){
  FILE *fp = fopen("empty2","wb");
  if (fp){
    fprintf(fp,"%s", str);
    fclose(fp);
  }
}











