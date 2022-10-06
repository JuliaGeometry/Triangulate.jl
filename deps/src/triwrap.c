/* This file is not part of the Triangle distribution*/
#include <stdio.h>
#include <setjmp.h>
#include "triangle/triangle.h"


/*********************************************************************/
/*
  Handling of triunsuitable (see Triangle source/documentation)
  via callback written in Julia.
*/

/* Function type for triunsuitable func*/
typedef int (*unsuitable_func)(REAL org_x,
                               REAL org_y,
                               REAL dest_x,
                               REAL dest_y,
                               REAL apex_x,
                               REAL apex_y,
                               REAL area);

/* Trivial default triunsuitable func */
int trivial_triunsuitable(REAL org_x,
                          REAL org_y,
                          REAL dest_x,
                          REAL dest_y,
                          REAL apex_x,
                          REAL apex_y,
                          REAL area)
{
  return 0;
}

/* Static variable containing the current triunsuitable function.
   This makes things non-threadsafe. An alternative would consist
   of patching Triangle and adding this variable to the triangulateio struct.
*/
static unsuitable_func jl_unsuitable_func=trivial_triunsuitable;


/* Set triunusuitable function. This will be called from Julia, 
   and unsuitable_func will be cfunction created in Julia.
*/
void triunsuitable_callback(unsuitable_func f)
{
  jl_unsuitable_func=f;
}

/* 
   Function called by Triangle when compiled with -DEXTERNAL_TEST.
*/
int triunsuitable(REAL* triorg,
                  REAL* tridest,
                  REAL* triapex,
                  REAL area)
{
  /* call the current trinusuitable function */
  return jl_unsuitable_func(triorg[0],
                            triorg[1],
                            tridest[0],
                            tridest[1],
                            triapex[0],
                            triapex[1],
                            area);
}

/*********************************************************************/
/* 
   Catch Triangle exit calls using  setjmp/longjmp.  

   Triangle happens to call exit() if it encounters e.g. an inconsistency
   in the input. As this would exit Julia, we need to replace exit by something else.

   Here  wee  use "jumping  out  of  deep call  hierarchies"  provided
   classically by setjmp/longjmp in  C.

   For an intro see e.g. http://web.eecs.utk.edu/~huangj/cs360/360/notes/Setjmp/lecture.html

   In order to make this working, triangle.c needs to be patched, replacing
   `exit(1)` by `extern void error_exit(int); error_exit(1)`.
*/


/* 
   Buffer containing the register state at the place where
   we would like to return on error.
*/
static jmp_buf jmp_env;

/* 
   Replacement for exit() called from Triangle
*/
void error_exit(int status)
{
  /* Continue execution at
     the place where we filled the jmp_env
     with the current register state.

     Triangle on error  calls exit() with status 1, 
     and we forward this.  In order to distinguish
     then non-error case from the initialization of the
     jump buffer, we set the status to -1 if error_exit(0)
     was called.
  */
  if (status==0)
    status=-1;
  
  longjmp(jmp_env,status);
}


/* 
   Wrapper for tringulate allowing to catch exit calls.
*/
int triangulate_catch_exit(char *triswitches,
                           struct triangulateio *in,
                           struct triangulateio *out,
                           struct triangulateio *vorout)
{
  /* Status variable set by setjmp*/
  int status;

  /* This works in two ways:
     - on first call: catch the processor register state, 
       save it in jmp_env and return 0
     - after call of lomgjmp(jmp_env, status):
       continue execution from this place with status forwarded
  */
  
  status=setjmp(jmp_env);

  if (status==0)
  {
    /* We just initialized the jump buffer. 
       Call triangulate and see what happens.
    */
    printf("sizeof(ulong)=%d\n",sizeof(unsigned long));
    printf("enter triangulate...\n");
    triangulate(triswitches,in,out,vorout);
    printf("exit triangulate...\n");
    /* If we arrive here, error_exit()  not been called.
       We assume no error and signalize this by
       returning 0 to the caller.
    */
    return 0;
  }
  else
  {
    
    /*
      If we arrive here, error_exit() has been called.
      Positive nonzero status was  forwarded to the status variable
      here. 
    */
    /*
      If the status variable here is negative, error_exit(0) was called,
      so we assume no error and replace the value.
    */
    if (status==-1)
      status=0;

    /*
      We signalize an error to the caller by returning
      a nonzero positive status variable.
    */
    
    return status;
  }
}
