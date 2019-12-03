#include<stdio.h>
#include<string.h> 
#include<stdlib.h>
#include<time.h>
#include <stdint.h>
#include<gsl/gsl_matrix.h>
#include<gsl/gsl_cblas.h>
#include<math.h>

int **main_matrix;
int *freq_matrix;
 
//This code is adapted  from http://stackoverflow.com/questions/53161/find-the-highest-order-bit-in-c

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

	FILE * adj_list;	
	FILE * output;
        int N;
	int i,j,k,l;
	int coor1,coor2;
	int iter;
        int step1,step2;
        int base=1;
        int base1; 
        int base2=1;
        int new_iter;
        int tot; 
        int lappi;
	if (argc < 5)
	{
		//printf("insufficient arguments\n");
		exit(1);
	};	 
	
	if((adj_list = fopen(argv[1], "r")) == NULL) 
	{
		//printf("Cannot open file.\n");
		exit(1);
	};	
	
	N=atoi(argv[2]);
	
        if((output = fopen(argv[3], "w+")) == NULL)
	  {
	    //printf("Cannot open file.\n");
	    exit(1);
	  };
        iter=atoi(argv[4]);
        fflush(stdout); 
        //printf("before callocing\n");	
	gsl_matrix *mp= gsl_matrix_calloc (N,N);
	//gsl_matrix *m1=gsl_matrix_calloc (N,N);
	gsl_matrix *m3=gsl_matrix_calloc (N,N);
	gsl_matrix *m4=gsl_matrix_calloc(N,N);
	
         step1=hob(iter);
         base=hob_N(iter);
        printf("base:%d\n",base); 
        base1=iter-base;    
        printf("base1=%d\n",base1);  
        ////printf("done callocing\n");
        step2=hob(base1);
        printf("step2:%d\n",step2);
        fflush(stdout); 
	while (fscanf(adj_list, "%d %d", &(coor1), &(coor2)) != EOF)
	  {    ////printf("doing_allocations\n"); 
                if (coor1!=coor2)
	      {//gsl_matrix_set(m1,coor1,coor2,1);
		gsl_matrix_set(mp,coor1,coor2,1);
	        gsl_matrix_set(m3,coor1,coor2,1);
               }
		
	};
        //printf("done reading the matrix, Now mul:tiplication begins \n");
lappi=1;
	
for (i=0;i<(step1);i++)
{ 
    if ((i==step2)&&(i>=1))
              { printf("reached the second exponential \n"); 
                fflush(stdout);
                gsl_matrix_memcpy(m4,m3);
              }

            
          gsl_blas_dgemm(CblasNoTrans, CblasNoTrans, 1.0, m3,m3,0.0,mp);
          gsl_matrix_memcpy(m3,mp); 
         
                for (k=0;k<N;k++) 
                  {
                      for (j=0;j<N;j++) 
                       { //gsl_matrix_set(m3,j,j,0);
                          if (gsl_matrix_get(m3,k,j)>=1)
                           {gsl_matrix_set(m3,k,j,1);
                           }
                           else gsl_matrix_set(m3,k,j,0);
               //gsl_matrix_set(m3,j,j,0);
                       }   
           

                   }  
         //base=base+base;
          if (base1 >0) 
          { 
            for (j=0;j<N;j++)
               gsl_matrix_set(m3,j,j,0);
          }

          else if (i <(step1-1)) 
           {    
            for (j=0;j<N;j++)
               gsl_matrix_set(m3,j,j,0);
	   }   
lappi=lappi+lappi; 
}  
base2=hob_N(base1);
       printf("base2:%d\n",base2);
       ////printf("%d\n",base); 
       /*gsl_matrix_memcpy(mp,m1);
       //printf("before step 2 \n"); 
       //gsl_matrix_memcpy(m4,m1);
       for (i=0;i<step2;i++) 
         {gsl_blas_dgemm(CblasNoTrans, CblasNoTrans, 1.0, mp,mp,0.0,m4);
          gsl_matrix_memcpy(mp,m4);
          for (j=0;j<N;j++)
             {gsl_matrix_set(mp,j,j,0);}
          base2=base2+base2;
         }
       //printf("%d",base2);
       */ 
       if (step2>=1)
           {gsl_blas_dgemm(CblasNoTrans, CblasNoTrans, 1.0, m4,m3,0.0,mp);
       printf("finished the most dominant exponential and  multiplied the top two terms\n");
       fflush(stdout);
       //gsl_matrix_memcpy(mp,m4);
       gsl_matrix_memcpy(m3,mp);
       gsl_matrix_free(m4);}
       else 
        {gsl_matrix_free(m4);
        } 
       gsl_matrix *m1=gsl_matrix_calloc (N,N);     
       fclose(adj_list); 
       if((adj_list = fopen(argv[1], "r")) == NULL)
        {
                //printf("Cannot open file.\n");
                exit(1);
        };

       while (fscanf(adj_list, "%d %d", &(coor1), &(coor2)) != EOF)
          {    ////printf("doing_allocations\n"); 
                if (coor1!=coor2)
              {gsl_matrix_set(m1,coor1,coor2,1);
              }
          }
   
       int flag=0;	
        if (step2>=1)
        {new_iter=(iter-(base+base2));
        //printf("new_iter=%d\n",new_iter);
        }
        else 
         {new_iter=(iter -(base));}
        
        tot=base+base2;
        printf("new_iter=%d\n",new_iter);
       //sleep(10);
       for(i=0;i<(new_iter);i++)
	  {
             fprintf(stdout,"in iteration :%d \n",(tot-1+i));	 
	     fflush(stdout);
	    for (j=0;j<N;j++) 
	      {  if ((i%2)==0)
		  { ////printf("trying to get \n");
                   if (gsl_matrix_get(mp,j,j)!=0)            	
		     { gsl_matrix_set(mp,j,j,0);
		       if(i==(new_iter-1)) 
                       {fflush(output);
                       fprintf(output,"%d\n",j);
                       //fprintf(stdout, "iteration %d:kmer id:%d\n", base +base2+i,j);
		       flag=1;}
                      }
                      ////printf("got it \n");
                  } else {////printf("trying to get\n");
		  if (gsl_matrix_get(m3,j,j)!=0)
		       {gsl_matrix_set(m3,j,j,0);
			if (i==(new_iter-1))
                        {fflush(output);
                        fprintf(output,"%d\n",j);
                        //fprintf(stdout, "iteration %d:kmer id:%d\n", i,j);
		        flag=1;}
                        }
                        ////printf("got it \n");
		      }
	      }
	    if (flag!=1)	
                { if ((i%2)==0)
		  { 
		    ////printf("inside second multiplication \n");
             gsl_blas_dgemm(CblasNoTrans, CblasNoTrans, 1.0, m3,m1,0.0,mp);
	  
                    for (k=0;k<N;k++)
                    {
                   for (j=0;j<N;j++)
                     { //gsl_matrix_set(mp,j,j,0);
                         if (gsl_matrix_get(mp,k,j)>=1)
                         {gsl_matrix_set(mp,k,j,1);}
                         else gsl_matrix_set(mp,k,j,0);
                         //gsl_matrix_set(m3,j,j,0);

                      }  


                     }   
                    //for (j=0;j<N;j++)
                             //gsl_matrix_set(mp,j,j,0);

                 }
		else {////printf("inside Second multiplication \n");
                      gsl_blas_dgemm(CblasNoTrans, CblasNoTrans, 1.0, mp,m1,0.0,m3);
		              for (k=0;k<N;k++)
                              {
           				for (j=0;j<N;j++)
             			         { //gsl_matrix_set(m3,j,j,0);
                                          if (gsl_matrix_get(m3,k,j)>=1)
                                             {gsl_matrix_set(m3,k,j,1);
                                            }
                                              else gsl_matrix_set(m3,k,j,0);
                                             //gsl_ matrix_set(m3,j,j,0);}

                                         }      


                               } 
 
	             //for (j=0;j<N;j++)
                             //l_matrix_set(m3,j,j,0); 

                     } 
          
              }

  }
/*	}
	for(i=0;i<N;i++) 
		for(j=0;j<N;j++) 
		{	
			//printf("%d\n",main_matrix[i][j]);
		
		}
				
*/	gsl_matrix_free(mp);
        gsl_matrix_free(m1);
        gsl_matrix_free(m3); 
        fclose(output);
        fclose(adj_list);			
	return(0);

}








