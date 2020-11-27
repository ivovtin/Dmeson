all:	beam_en wiki_en lumi meas_en

LIBS	= $(shell root-config --libs --glibs) -L/space/KEDR/stable/lib -lKDB -lpq -lcrypt -lm -lstdc++
CERNLIBS	= `cernlib mathlib` -lg2c

INC	= $(shell root-config --cflags) -I/space/KEDR/stable/ -I/cern/pro/include/cfortran/ -Df2cFortran

clean:
	rm *.o

beam_en:	beam_en.c
	cc -o beam_en beam_en.c $(LIBS) $(INC)
wiki_en:	wiki_en.c
	cc -o wiki_en wiki_en.c $(LIBS) $(INC)
lumi:	lumi.cpp
	cc -o lumi lumi.cpp $(LIBS) $(INC)
meas_en:  meas_en.cpp
	cc -o meas_en meas_en.cpp $(LIBS) $(INC)


