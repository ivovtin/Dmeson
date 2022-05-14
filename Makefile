#--------------------------------------------------------------------------
# следующие 3 строки лучше не трогать
ifeq (,$(WORKDIR))
WORKDIR=..
##WORKDIR=../
endif

# Всё что делается делается вслух :) - желательно оставить как есть
VERBOSEMAKE=""
# Если ключик -g при сборки не нужен - если уверен в себе
#NDEBUG=""

# Компилятор для *.с файлов
#CC_LOCAL := gcc
# Компилятор для *.cc и *.cpp файлов
#CXX_LOCAL := g++
# Компилятор для *.f, *.for и *.F файлов
F77_LOCAL := g77
# Линкер для этого пакета по умолчанию
#LD_LOCAL := g++
# Раскомментировать, если необходимо задавать линкер для каждого
# бинарника в отдельности. Обычно не требуется.
#LD_MULTI := ""

# Дополнительные опции для компилятора C/C++
COPTS = -I. `root-config --cflags`  -I/cern/pro/include/cfortran/ -Df2cFortran #-ansi -pedantic
NOOPT = ""
# Дополнительные опции для компилятора Fortran
#FOPTS = -I.
FOPTS  = -g -fvxt -Wall -fno-automatic -finit-local-zero \
-fno-second-underscore -ffixed-line-length-120 -Wno-globals \
-DCERNLIB_LINUX -DCERNLIB_UNIX -DCERNLIB_LNX -DCERNLIB_QMGLIBC -DCERNLIB_BLDLIB \
-DCOMPDATE="'$(COMPDATE)'" -I$(CERN)/pro/include -I$(CERN)/pro/include/geant321

# Дополнительные опции для линкера
#LDOPTS = -Xlinker -rpath -Xlinker `root-config --libdir`
#LDOPTS = -lg2c -Wl,-rpath=`root-config --libdir`
LDOPTS = -lg2c `root-config --libs` /space/KEDR/stable/lib/libVDDCRec.a  -lMinuit

#Если определена переменная ONLYBINARY, то библиотека в пакете отсутствует
ONLYBINARY=""

# Если необходимо добавить CERNLIB, то лучше воспользоваться этим
# ключиком. Церновские библиотеки подшиваются в самом конце. По
# умалчанию подшиваются следущие библиотеки jetset74 mathlib graflib
# geant321 grafX11 packlib
CERNLIBRARY = ""

# Список библиотек, если вам не нравится стандартный набор, который
# расширяем по требованию. В любом случае необходимо раскомментировать
# CERNLIBRARY
#CERNLIBS =
CERNLIBS = jetset74 mathlib graflib grafX11 geant lapack3 blas packlib

# где вываливать исполняемые файлы
BINDIR := ./

# Дополнительные либы (вставляются после либ)
LIB_LOCAL= `root-config --libs` -lMinuit -lpq -lcrypt -lbz2 -ldl -lg2c
##LIB_LOCAL= `root-config --libs` -lMinuit -lcrypt -lbz2 -lg2c
##LIB_LOCAL= `root-config --libs` -lMinuit -lcrypt -lpq -lbz2 -lg2c

# Определим, какие программы мы будем собирать
BINARIES = analysis_D0meson analysis_Dplusmeson analysis_bhabha analysis_bhabha_atc analysis_Ks BhaBhaSimpleSampleCC analysis_D0meson_krKrec analysis_mono analysis_D0kppp analysis_D0meson_woATC

# укажем, из каких модулей этого пакета они состоят
# (эти модули не будут включены в библиотеку)
# и какие библиотеки надо подключить при сборке
analysis_D0meson_MODULES := analysis_D0meson
analysis_D0meson_LIBS := KaFramework KrAtc KDisplay VDDCRec KrVDDCMu KrMu \
KrdEdxPId KrDCCalibdEdx DchdEdxDataRoot VDDCRec KrToF KsToF KEmcRec LKrTools \
VDDCRec KsTrg KdConvert KrObjects KdDCSim FitTools DchGeom ReadNat KDB AppFramework KrKRec KrDONLP2

analysis_D0meson_woATC_MODULES := analysis_D0meson_woATC
analysis_D0meson_woATC_LIBS := KaFramework KrAtc KDisplay VDDCRec KrVDDCMu KrMu \
KrdEdxPId KrDCCalibdEdx DchdEdxDataRoot VDDCRec KrToF KsToF KEmcRec LKrTools \
VDDCRec KsTrg KdConvert KrObjects KdDCSim FitTools DchGeom ReadNat KDB AppFramework KrKRec KrDONLP2

analysis_D0kppp_MODULES := analysis_D0kppp
analysis_D0kppp_LIBS := KaFramework KrAtc KDisplay VDDCRec KrVDDCMu KrMu \
KrdEdxPId KrDCCalibdEdx DchdEdxDataRoot VDDCRec KrToF KsToF KEmcRec LKrTools \
VDDCRec KsTrg KdConvert KrObjects KdDCSim FitTools DchGeom ReadNat KDB AppFramework KrKRec KrDONLP2

analysis_D0meson_krKrec_MODULES := analysis_D0meson_krKrec
analysis_D0meson_krKrec_LIBS := KaFramework KrAtc KDisplay VDDCRec KrVDDCMu KrMu \
KrdEdxPId KrDCCalibdEdx DchdEdxDataRoot VDDCRec KrToF KsToF KEmcRec LKrTools \
VDDCRec KsTrg KdConvert KrObjects KdDCSim FitTools DchGeom ReadNat KDB AppFramework KrKRec KrDONLP2

analysis_Dplusmeson_MODULES := analysis_Dplusmeson
analysis_Dplusmeson_LIBS := KaFramework KrAtc KDisplay VDDCRec KrVDDCMu KrMu \
KrdEdxPId KrDCCalibdEdx DchdEdxDataRoot VDDCRec KrToF KsToF KEmcRec LKrTools \
VDDCRec KsTrg KdConvert KrObjects KdDCSim FitTools DchGeom ReadNat KDB AppFramework KrKRec KrDONLP2

analysis_bhabha_MODULES := analysis_bhabha
analysis_bhabha_LIBS := KaFramework KrAtc KDisplay VDDCRec KrVDDCMu KrMu \
KrdEdxPId KrDCCalibdEdx DchdEdxDataRoot VDDCRec KrToF KsToF KEmcRec LKrTools \
VDDCRec KsTrg KdConvert KrObjects KdDCSim FitTools DchGeom ReadNat KDB AppFramework KrKRec KrDONLP2

analysis_bhabha_atc_MODULES := analysis_bhabha_atc
analysis_bhabha_atc_LIBS := KaFramework KrAtc KDisplay VDDCRec KrVDDCMu KrMu \
KrdEdxPId KrDCCalibdEdx DchdEdxDataRoot VDDCRec KrToF KsToF KEmcRec LKrTools \
VDDCRec KsTrg KdConvert KrObjects KdDCSim FitTools DchGeom ReadNat KDB AppFramework KrKRec KrDONLP2

analysis_Ks_MODULES := analysis_Ks
analysis_Ks_LIBS := KaFramework KrAtc KDisplay VDDCRec KrVDDCMu KrMu \
KrdEdxPId KrDCCalibdEdx DchdEdxDataRoot VDDCRec KrToF KsToF KEmcRec LKrTools \
VDDCRec KsTrg KdConvert KrObjects KdDCSim FitTools DchGeom ReadNat KDB AppFramework KrKRec KrDONLP2

analysis_mono_MODULES := analysis_mono
analysis_mono_LIBS := KaFramework KrAtc KDisplay VDDCRec KrVDDCMu KrMu \
KrdEdxPId KrDCCalibdEdx DchdEdxDataRoot VDDCRec KrToF KsToF KEmcRec LKrTools \
VDDCRec KsTrg KdConvert KrObjects KdDCSim FitTools DchGeom ReadNat KDB AppFramework KrKRec KrDONLP2

BhaBhaSimpleSampleCC_MODULES := BhaBhaSimpleSampleCC
#BhaBhaSimpleSampleCC_LIBS := KaFramework KrAtc KDisplay VDDCRec KrVDDCMu KrMu \
##KrdEdxPId KrDCCalibdEdx DchdEdxDataRoot VDDCRec KrToF KsToF KEmcRec LKrTools \
##VDDCRec KsTrg KdConvert KrObjects KdDCSim FitTools DchGeom ReadNat KDB AppFramework KrKRec KrDONLP2

##BhaBhaSimpleSampleCC_LIBS := VDDCRec  KDisplay  ReadNat  KDB VDDCRec  KsTrg  KdDCSim KrToF KsToF KrVDDCMu KrMu KEmcRec  VDDCRec  KrAtc LKrTools  KdConvert KrObjects AppFramework FitTools DchGeom
BhaBhaSimpleSampleCC_LIBS := VDDCRec  KsTrg  KDisplay VDRec ReadNat KDB KdDCSim  VDDCRec DchGeom KrAtc VDDCRec  KrToF KsToF KrVDDCMu KrMu KEmcRec  VDDCRec  ReadNat LKrTools AppFramework FitTools DchGeom KdConvert  KrObjects

# следующую строку лучше не трогать
include $(WORKDIR)/KcReleaseTools/rules.mk

