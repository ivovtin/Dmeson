#include "stdio.h"
#include "KDB/kd_db.h"

//http://kedr-wiki.inp.nsk.su/index.php/%D0%92%D0%BE%D1%81%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BB%D0%B5%D0%BD%D0%BD%D0%B0%D1%8F_%D1%8D%D0%BD%D0%B5%D1%80%D0%B3%D0%B8%D1%8F

int main(int argc, char** argv) {
    //int run=23219;
    int run=24835;
    KDBconn * kdbConn=kdb_open();
    int id=kdb_get_id(kdbConn, "runenergy");
    time_t time=kdb_run_get_begin_time(kdbConn, run);
    kdb_setver(kdbConn, 0);
    int data[16];
    int rc=kdb_read(kdbConn, id, time, data, 16);
    kdb_error_clear();
    kdb_close(kdbConn);
    printf("%d %f %f\n",run,1E-6*data[1],1E-6*data[2]);
}
