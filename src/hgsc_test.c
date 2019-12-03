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
 
int main(int argc, char *argv[])
{

	FILE * adj_list;	
	FILE * output;
        int N;
	int i,j;
	int coor1,coor2;
	int iter;
if (argc < 5)
	{
		printf("insufficient arguments\n");
		exit(1);
	};	 
	
	if((adj_list = fopen(argv[1], "r")) == NULL) 
	{
		printf("Cannot open file.\n");
		exit(1);
	};	
	
	N=atoi(argv[2]);
	
        if((output = fopen(argv[3], "w+")) == NULL)
	  {
	    printf("Cannot open file.\n");
	    exit(1);
	  };
        iter=atoi(argv[4]);
	
	gsl_matrix *mp= gsl_matrix_calloc (N, N);
	gsl_matrix *m1=gsl_matrix_calloc (N, N);
	gsl_matrix *m3=gsl_matrix_calloc (N, N);
	
	
	while (fscanf(adj_list, "%d %d", &(coor1), &(coor2)) != EOF)
	  {       if (coor1!=coor2)
	      {gsl_matrix_set(m1,coor1,coor2,1);
		gsl_matrix_set(mp,coor1,coor2,1);
	      }
		
	};
        printf("done reading the matrix, Now multiplication begins \n");

	gsl_blas_dgemm(CblasNoTrans, CblasNoTrans, 1.0, mp,m1,0.0,m3);
	printf("the first Multiply\n");
	for(i=0;i<iter;i++)
	  {fprintf(stdout,"in iteration :%d \n",i);	 
	    
	    for (j=0;j<N;j++) 
	      {  if ((i%2)==0)
		  { //printf("trying to get \n");
                   if (gsl_matrix_get(mp,j,j)!=0)            	
		     { gsl_matrix_set(mp,j,j,0);
		       if(i==(iter-1)) 
                       {fprintf(output,"%d\n",j);
                       fprintf(stdout, "iteration %d:kmer id:%d\n", i,j);}
		      }
                      //printf("got it \n");
                  } else {//printf("trying to get\n");
		  if (gsl_matrix_get(m3,j,j)!=0)
		       {gsl_matrix_set(mp,j,j,0);
			if (i==(iter-1))
                        {fprintf(output,"%d\n",j);
                        fprintf(stdout, "iteration %d:kmer id:%d\n", i,j);}
		        }
                        //printf("got it \n");
		      }
	      }
		if ((i%2)==0)
		  { 
		    //printf("inside second multiplication \n");
             gsl_blas_dgemm(CblasNoTrans, CblasNoTrans, 1.0, m3,m1,0.0,mp);
	  }
		else {//printf("inside Second multiplication \n");
                      gsl_blas_dgemm(CblasNoTrans, CblasNoTrans, 1.0, mp,m1,0.0,m3);
		       }
	  }



/*	}
	for(i=0;i<N;i++) 
		for(j=0;j<N;j++) 
		{	
			printf("%d\n",main_matrix[i][j]);
		
		}
				
*/	gsl_matrix_free(mp);
        gsl_matrix_free(m1);
        gsl_matrix_free(m3); 
        fclose(output);
        fclose(adj_list);			
	return(0);

}








