ifeq (,$(CC_LOCAL))
CC           := gcc
else
CC           := $(CC_LOCAL)
endif
ifeq (,$(CXX_LOCAL))
CXX           := g++
else
CXX           := $(CXX_LOCAL)
endif

CPPFLAGS+=$(shell root-config --cflags) -I.
LDFLAGS+=$(shell root-config --libs --glibs) -lGui -lMinuit -lNew -Wl,-rpath -Wl,$(shell root-config --libdir)

.PHONY: all clean

all: kspp

%.o: %.cc
	$(CXX) -c $(CPPFLAGS) $^

kspp: kspp.o
	$(CXX) -o $@ $(LDFLAGS) $^
clean:
	rm -f kspp.o kspp

