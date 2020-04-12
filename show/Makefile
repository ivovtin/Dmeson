# -*- mode: Makefile; -*- установка Makefile моды для Emacs
#--------------------------------------------------------------------------
#      $Id: Makefile,v 1.3 2005/04/27 05:04:21 pospelov Exp $
#
# Description:
#      Makefile for KcTemplate package
#
# Environment:
#      Software developed for the KEDR Detector at BINP.
#
# Author:
#      Baldin Evgueni Mihilovich (E.M.Baldin@inp.nsk.su)
#
# Copyright Information:
#      Copyright (C) 2000-2004  Budker's Institute of Nuclear Physics
#
#--------------------------------------------------------------------------
# следующие 3 строки лучше не трогать
#ifeq (,$(WORKDIR))
#WORKDIR = $(shell pushd ../.. 1>/dev/null && pwd )
#endif
WORKDIR=/home/ovtin/development/


#Всё что делается делается вслух :) - желательно раскомментировать
VERBOSEMAKE=""
#Если ключик -g при сборки не нужен - если уверен в себе
#NDEBUG=""

#Компилятор для *.с файлов
#CC_LOCAL := gcc
#Компилятор для *.cc и *.cpp файлов
#CXX_LOCAL := g++
#Компилятор для *.f, *.for и *.F файлов
#F77_LOCAL := g77
#Линкер для этого пакета
LD_LOCAL := g++

# Дополнительные опции для компилятора C/C++
COPTS  = -I./ -I/cern/pro/include/cfortran/ -Df2cFortran

# Дополнительные опции для компилятора Fortran
#FOPTS  =

# Отключение оптимизации - почему-то важно для моделирования
#NOOPT = " "

# Дополнительные опции для линкера
LDOPTS = -lg2c -Wl,-rpath=`root-config --libdir`
#-shared #если хочется использовать разделяемую библиотеку
#Если необходимо добавить CERNLIB, то лучше воспользоваться этим ключиком
CERNLIBRARY = ""
#Список библиотек, если вам не нравится стандартный набор (расширяем по требованию)
# jetset74 mathlib graflib geant321 grafX11 packlib
CERNLIBS = jetset74 mathlib graflib geant lapack3 blas

#Если определена переменная ONLYBINARY, то библиотека в пакете отсутствует
ONLYBINARY=""
# где вываливать исполняемые файлы
BINDIR=./
#Раскомментируйте, если хочется собрать динамическую библиотеку
#LIB_SHARED = ""

# Дополнительные либы (вставляются после либ)
#LIB_LOCAL= `root-config --libs` -lMinuit -lpq -lcrypt -lbz2 -lstdc++
LIB_LOCAL=`root-config --libs` -lMinuit -lpq -lcrypt -lbz2 -lg2c

# Определим, какие программы мы будем собирать
# Здесь следует указывать только используемые при работе пакеты,
# чтобы не засорять bin - все программки, которые пишутся дли примера
# и тестирования следует складывать в директорию example
BINARIES = show

# укажем, из каких модулей этого пакета они состоят
# (эти модули не будут включены в библиотеку)
# и какие библиотеки надо подключить при сборке
show_MODULES = show
#show_LIBS    = KrAtc KDisplay VDDCRec KrToF KsToF KdDCSim VDDCRec DchGeom ReadNat KDB FitTools KrAtc AppFramework KEmcDraw KEmcRec LKrTools VDDCRec
#show_LIBS := KaFramework KrAtc KDisplay VDDCRec KrVDDCMu KrMu \
#KrdEdxPId KrDCCalibdEdx DchdEdxDataRoot VDDCRec KrToF KsToF KEmcRec LKrTools \
#VDDCRec KsTrg KdConvert KrObjects KdDCSim FitTools DchGeom ReadNat KDB AppFramework KrKRec KrDONLP2
show_LIBS    = KDisplay VDDCRec KsTrg KdDCSim VDDCRec DchGeom FitTools KEmcRec LKrTools \
               KrToF KsToF KrAtc VDDCRec KrMu AppFramework KdConvert KrObjects KDB ReadNat g2c bz2 pq stdc++

# следующую строку лучше не трогать
#-----------------------------------
include $(WORKDIR)/KcReleaseTools/rules.mk
#-----------------------------------

#-----------------------------------
# Если хочется сделать что-то нестандартное, то не стесняйтесь
#-----------------------------------
# Свои цели следует определять здесь.
# Перед исполняемой командой следует вставить
# символ табуляции <Tab>.


#Если хотите сделать что-то до полной сборки
#Выполняется при исполнении make без параметров
PRE_MAKE:
	@echo "This should be done before compiling"

#Если хотите сделать что-то после полной сборки
#Выполняется при исполнении make без параметров
POST_MAKE:
	@echo "This should be done after compiling"

# Если хочется сделать что-то  ещё
mytag:
	@echo "my tag"
