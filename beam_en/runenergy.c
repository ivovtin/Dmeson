#include <KDB/kdb.h>

#include <stdio.h>

#include <stdlib.h>

//http://kedr-wiki.inp.nsk.su/index.php/%D0%A0%D0%B0%D0%B1%D0%BE%D1%82%D0%B0_%D1%81_%D0%B1%D0%B0%D0%B7%D0%BE%D0%B9_%D0%B4%D0%B0%D0%BD%D0%BD%D1%8B%D1%85
//gcc runenergy.c -I /space/KEDR/stable -L/space/KEDR/stable/lib/ -lKDB -lpq -o runenergy

int main(int argc, char ** argv)
{
    int version=1; //version of energy

    int id; //table id
    unsigned l=16;//table length
    int32_t * buf;  //array with data
    int begin_run=23219;
    int end_run=23225;
    //int begin_run=24835;
    //int end_run=24850;
    int v;
    double E; //energy, MeV
    double dE; //energy error, MeV
    int ndf;
    double chi2;
    double sigma; //method stat error, MeV
    int r;
    KDBconn * k;
    k=kdb_open(); //open connect to db
    if(!k)  {
	k=0;
	printf("ERROR: Unable to connect to DB\n");
	exit(1);
    }
    //get table id for runenergy table
    //id=kdb_get_id(k,"runenergy");
    id=2119;
    //get table length for runenergy table
    //l=kdb_get_length(k,id);
    l=16;
    buf=malloc(sizeof(int32_t)*l);
    //initialize buffer
    //kdb_setver(k,version);
    for(r=begin_run; r<end_run;r++)   {
	kdb_read_for_run(k,id,r,buf,l);
	if(buf[3]!=r) continue; //VERY IMPORTANT. You must check that record exists for this run.
        E=buf[1]/1e6; //energy
	dE=buf[2]/1e6; //energy error
	ndf=buf[4]; //number degree of freedom
	chi2=buf[5]/1e3; //chi square
	sigma=buf[6]/1e6; //method stat error
        /* Fill data
          etc...
         */
	printf("%d %d %4.3f %1.3f %d %3.3f %1.3f\n",r,buf[3],E,dE,ndf,chi2,sigma);
    }

    kdb_setver(k,0);//return default version
    // ...
    // do something
    // ...
    kdb_close(k);//close connection to DB.
    free(buf);
    printf("DONE\n");
}
