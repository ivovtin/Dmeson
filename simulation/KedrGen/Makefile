# -*- mode: Makefile; -*- ��������� Makefile ���� ��� Emacs
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
# ��������� 3 ������ ����� �� �������
ifeq (,$(WORKDIR))
WORKDIR = $(shell pushd ../../../ 1>/dev/null && pwd )
endif

#�ӣ ��� �������� � ������� ���������� �� ����� - ���������� �����������������       
VERBOSEMAKE=""
#���� ������ -g ��� ������ �� ����� - ���� ������ � ����                 
#NDEBUG=""

#���������� ��� *.� ������
#CC_LOCAL := gcc
#���������� ��� *.cc � *.cpp ������
#CXX_LOCAL := g++
#���������� ��� *.f, *.for � *.F ������
#F77_LOCAL := g77
#������ ��� ����� ������
#LD_LOCAL := g++

# �������������� ����� ��� ����������� C/C++
COPTS  = #`root-config --cflags`

# �������������� ����� ��� ����������� Fortran
FOPTS  =  -g -fvxt -Wall -fno-automatic -finit-local-zero \
-fno-second-underscore -ffixed-line-length-120 -Wno-globals \
-DCERNLIB_LINUX -DCERNLIB_UNIX -DCERNLIB_LNX -DCERNLIB_QMGLIBC -DCERNLIB_BLDLIB \
-DCOMPDATE="'$(COMPDATE)'" -I$(CERN)/pro/include -I$(CERN)/pro/include/geant321

# �������������� ����� ��� �������                                      
#LDOPTS = -lg2c $(shell $(ROOTSYS)/bin/root-config --libs --glibs)
LDOPTS = -lg2c $(shell root-config --libs --glibs)
#-shared #���� ������� ������������ ����������� ����������
#���� ���������� �������� CERNLIB, �� ����� ��������������� ���� ��������
CERNLIBRARY = "" 
#������ ���������, ���� ��� �� �������� ����������� ����� (��������� �� ����������)
# jetset74 mathlib graflib geant321 grafX11 packlib
CERNLIBS = jetset74 mathlib graflib grafX11

#���� ���������� ���������� ONLYBINARY, �� ���������� � ������ �����������
#ONLYBINARY=""
# ���� ���������� ����������� �����
#BINDIR=./
#����������������, ���� ������� ������� ������������ ����������
#LIB_SHARED = ""

# �������������� ���������� (����������� ����� ���������)
LIB_LOCAL= -lstdc++
# `root-config --libs`       

# ���������, ����� ��������� �� ����� ��������
# ����� ������� ��������� ������ ������������ ��� ������ ������, 
# ����� �� �������� bin - ��� ����������, ������� ������� ��� �������   
# � ������������ ������� ���������� � ���������� example
BINARIES = 

# ������, �� ����� ������� ����� ������ ��� �������
# (��� ������ �� ����� �������� � ����������)
# � ����� ���������� ���� ���������� ��� ������
#templateTest_MODULES = test
#templateTest_LIBS    = KcTemplate

# ��������� ������ ����� �� �������
include $(WORKDIR)/KcReleaseTools/rules.mk

