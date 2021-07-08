all:    D0kppp

LIBS    = $(shell root-config --libs --glibs) -L/space/KEDR/stable/lib -lKDB -lpq -lcrypt -lm -lstdc++
CERNLIBS        = `cernlib mathlib` -lg2c

INC     = $(shell root-config --cflags) -I/space/KEDR/stable/ -I/cern/pro/include/cfortran/ -Df2cFortran

clean:
	rm D0kppp

D0kppp:  D0kppp.C
	cc -o D0kppp D0kppp.C $(LIBS) $(INC)

