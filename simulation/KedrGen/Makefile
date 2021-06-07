# -*- mode: Makefile; -*- установка Makefile моды для Emacs
#--------------------------------------------------------------------------
#      $Id: Makefile,v 1.1 2006/03/21 04:25:04 tayursky Exp $
#
# Description:
#      Makefile for KcTemplate package
#
# Environment:
#      Software developed for the KEDR Detector at BINP.
#
# Author:
#      Baldin Evgueni Mihailovich (E.M.Baldin@inp.nsk.su)             
#
# Copyright Information:
#      Copyright (C) 2000-2004  Budker's Institute of Nuclear Physics
#
#--------------------------------------------------------------------------
# следующие 3 строки лучше не трогать
ifeq (,$(WORKDIR))
WORKDIR = $(shell pushd ../../../ 1>/dev/null && pwd )
endif

#Всё что делается с выводом результата на экран - желательно раскомментировать       
VERBOSEMAKE=""
#Если ключик -g при сборке не нужен - если уверен в себе                 
#NDEBUG=""

#Компилятор для *.с файлов
#CC_LOCAL := gcc
#Компилятор для *.cc и *.cpp файлов
#CXX_LOCAL := g++
#Компилятор для *.f, *.for и *.F файлов
#F77_LOCAL := g77
#Линкер для этого пакета
#LD_LOCAL := g++

# Дополнительные опции для компилятора C/C++
COPTS  = #`root-config --cflags`

# Дополнительные опции для компилятора Fortran
FOPTS  =  -g -fvxt -Wall -fno-automatic -finit-local-zero \
-fno-second-underscore -ffixed-line-length-120 -Wno-globals \
-DCERNLIB_LINUX -DCERNLIB_UNIX -DCERNLIB_LNX -DCERNLIB_QMGLIBC -DCERNLIB_BLDLIB \
-DCOMPDATE="'$(COMPDATE)'" -I$(CERN)/pro/include -I$(CERN)/pro/include/geant321

# Дополнительные опции для линкера                                      
#LDOPTS = -lg2c $(shell $(ROOTSYS)/bin/root-config --libs --glibs)
LDOPTS = -lg2c $(shell root-config --libs --glibs)
#-shared #если хочется использовать разделяемую библиотеку
#Если необходимо добавить CERNLIB, то лучше воспользоваться этим ключиком
CERNLIBRARY = "" 
#Список библиотек, если вам не нравится стандартный набор (расширяем по требованию)
# jetset74 mathlib graflib geant321 grafX11 packlib
CERNLIBS = jetset74 mathlib graflib grafX11

#Если определена переменная ONLYBINARY, то библиотека в пакете отсутствует
#ONLYBINARY=""
# куда переносить исполняемые файлы
#BINDIR=./
#Раскомментируйте, если хочется собрать динамическую библиотеку
#LIB_SHARED = ""

# Дополнительные библиотеки (вставляются после библиотек)
LIB_LOCAL= -lstdc++
# `root-config --libs`       

# Определим, какие программы мы будем собирать
# Здесь следует указывать только используемые при работе пакеты, 
# чтобы не засорять bin - все программки, которые пишутся для примера   
# и тестирования следует складывать в директорию example
BINARIES = 

# укажем, из каких модулей этого пакета они состоят
# (эти модули не будут включены в библиотеку)
# и какие библиотеки надо подключить при сборке
#templateTest_MODULES = test
#templateTest_LIBS    = KcTemplate

# следующую строку лучше не трогать
include $(WORKDIR)/KcReleaseTools/rules.mk

