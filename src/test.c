
#include<stdio.h>
#include<string.h> 
#include<stdlib.h>
#include<time.h>
#include <stdint.h>
#include<gsl/gsl_matrix.h>
#include<gsl/gsl_cblas.h>
#include<math.h>

int hob_N (int num)
{
    if (!num)
      return 0;
 
    int ret = 1;
    int i=0;
     	      
while (num >>= 1)
{ ret <<= 1;
  i++;
}
return ret;
     	     	            
}



int hob (int num)
{
    if (!num)
    	return 0;

    int ret = 1;
    int i=0; 
 
    while (num >>= 1)
    	{ ret <<= 1;
          i++;
        }
    return i;

}


int main(int argc, char *argv[])
{
   int i,j; 
    printf("%d\n", hob_N(1));
    printf("%d\n", hob(1));

 j=1; 
   for (i=0;i<10;i++) 
   {j=j+j;
   }    

printf("j=%d",j);


}

