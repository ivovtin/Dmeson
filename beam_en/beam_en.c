#include "stdio.h"
#include "KDB/kd_db.h"

void get_run_energy(int run, double *en, double *en_err, double *lum, int *t) {
  int array[8];
  KdDbConn* conn;
  KDBruninfo runinfo;
  int id;

  conn = kd_db_open(NULL);
  id = kd_db_get_id("runenergy",conn);
  if (kd_db_get_for_run_int(id, run, conn, array, 8)) {
    *en = array[1]/1e6;
    *en_err = array[2]/1e6;
  }
  if (kd_db_get_run_info(run, 1, conn, &runinfo))
  *lum = runinfo.intelum;
  *t = runinfo.livesec;
  kd_db_close(conn);
}

int main(int argc, char** argv) {

  if (argc < 3) {
    printf("Usage: beam_en [start_run] [stop_run]\n");
    exit(0);
  }

  if (argc == 3) {
    int start_run, stop_run;
    int i, run;
    double err = 0;
    double slum = 0;
    int tt=0;
    sscanf(argv[1],"%d",&start_run);
    sscanf(argv[2],"%d",&stop_run);

    for (run=start_run; run<=stop_run; run++) {
      double en, en_err, lum;
      int t;
      get_run_energy(run, &en, &en_err, &lum, &t);
      printf("%d %f %f %f %d\n",run,en,en_err,lum,t);
      err += en_err*lum;
      slum += lum;
      tt += t;
    }
    printf("Max. error = %f\n", err/slum);
    printf("Total live time: %d\n", tt);
  }
}
