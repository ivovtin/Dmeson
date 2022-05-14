all:    bhabha bhabhaATC

LIBS	= $(shell root-config --libs --glibs) -L/space/KEDR/stable/lib -lKDB -lpq -lcrypt -lm -lstdc++
CERNLIBS	= `cernlib mathlib` -lg2c

INC	= $(shell root-config --cflags) -I/space/KEDR/stable/ -I/cern/pro/include/cfortran/ -Df2cFortran

clean:
	rm -f bhabha.o bhabha bhabhaATC.o bhabhaATC

bhabha:	bhabha.C
	cc -o bhabha bhabha.C $(LIBS) $(INC)

bhabhaATC:	bhabhaATC.C
	cc -o bhabhaATC bhabhaATC.C $(LIBS) $(INC)
