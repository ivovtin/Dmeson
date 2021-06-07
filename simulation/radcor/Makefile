.PHONY: all lib install install-lib install-data install-bin check_env

ifndef SNDSOFT
 SNDSOFT := sndsoft
endif

RANLIB	:= ranlib
FFLAGSUSER += -g -O -w

# --- foreign dependencies
LIBNAME := radcor
SNDLOCALROOT := ..
SNDDEPENDS := snd-main/fortran.mk
override SNDDEPMKFLIST := SNDDEP1
override SNDDEPDEPLIST := SNDDEP2
include $(SNDMKROOT)/snddeps.mk
include $(SNDDEP1)

SNDDEPENDS := cocha/kio/libkio.a sndlow/libsndlow.a
override SNDDEPDEPLIST := SNDDEP3
override SNDDEPLIBLIST := SNDDEP4
include $(SNDMKROOT)/snddeps.mk

# --- local dependencies
DOCUMENTS = $(wildcard *.koi)
INCFILES := $(wildcard *.inc)
SKIP_FOR = $(wildcard test*.for) cphppg.for wrhopi.for makecros.for \
    wdrho0.for

SOURCES_FOR = $(filter-out $(SKIP_FOR), $(wildcard *.for))
MODULES_LIB = $(patsubst %.for, lib$(LIBNAME).a(%.o), $(SOURCES_FOR))

all: lib

install: install-lib install-data install-doc

check_env:
	@[ -n "$(SNDROOT)" ] || \
	( echo 'SNDROOT is not set' >&2 ; false )

INC_INSTALLED := $(addprefix $(SNDROOT)/include/,$(wildcard *.inc))
KOI_INSTALLED := $(addprefix $(SNDROOT)/doc/,$(wildcard *.koi))
LIB_INSTALLED := $(SNDROOT)/lib/lib$(LIBNAME).a

install-data: check_env $(INC_INSTALLED)
	@true

$(INC_INSTALLED): $(SNDROOT)/include/%: %
	install -m 664 -g $(SNDSOFT) $< $@

install-doc: check_env $(KOI_INSTALLED)
	@true

$(KOI_INSTALLED): $(SNDROOT)/doc/%: %
	install -m 664 -g $(SNDSOFT) $< $@

install-lib: check_env $(LIB_INSTALLED)
	@true

$(LIB_INSTALLED): $(SNDROOT)/lib/%: %
	install -m 664 -g $(SNDSOFT) $< $@

install-bin:
	@true

install-wid: check_env wid
	install -m 664 -g $(SNDSOFT) $< $@

$(MODULES_LIB): $(INCFILES) $(SNDDEP2)

lib: lib$(LIBNAME).a
	@true

wid: bin
	nice -10 ./wrhopi

bin: wrhopi
	@true

wrhopi: wrhopi.o lib$(LIBNAME).a $(SNDDEP3)
	$(LINK.f) -o $@ $< -L. -l$(LIBNAME) $(SNDDEP4) \
	  -L/usr/local/lib -lz `cernlib mathlib`

lib$(LIBNAME).a: $(MODULES_LIB)
	$(RANLIB) $@
	@echo 'Library $@ has been rebuilt'

clean:
	rm -f getrad wrhopi *.a *.o
