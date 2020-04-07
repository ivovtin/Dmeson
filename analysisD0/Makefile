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

all: D0meson

%.o: %.cc
	$(CXX) -c $(CPPFLAGS) $^

Dmeson: D0meson.o
	$(CXX) -o $@ $(LDFLAGS) $^
clean:
	rm -f D0meson.o D0meson

