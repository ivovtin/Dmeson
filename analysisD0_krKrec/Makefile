all:    D0meson

LIBS    = $(shell root-config --libs --glibs) -L/space/KEDR/stable/lib -lKDB -lpq -lcrypt -lm -lstdc++
CERNLIBS        = `cernlib mathlib` -lg2c

INC     = $(shell root-config --cflags) -I/space/KEDR/stable/ -I/cern/pro/include/cfortran/ -Df2cFortran

clean:
	rm D0meson

D0meson:  D0meson.C
	cc -o D0meson D0meson.C $(LIBS) $(INC)

