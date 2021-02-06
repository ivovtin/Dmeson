all:    draw_dcnoise_runs

LIBS	= $(shell root-config --libs --glibs) -L/space/KEDR/stable/lib -lKDB -lpq -lcrypt -lm -lstdc++
CERNLIBS	= `cernlib mathlib` -lg2c

INC	= $(shell root-config --cflags) -I/space/KEDR/stable/ -I/cern/pro/include/cfortran/ -Df2cFortran

clean:
	rm -f draw_dcnoise_runs

draw_dcnoise_runs:     draw_dcnoise_runs.C
	cc -o draw_dcnoise_runs draw_dcnoise_runs.C $(LIBS) $(INC)
