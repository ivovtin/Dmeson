# -*- mode: Makefile; -*- ��������� Makefile ���� ��� Emacs
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
# ��������� 3 ������ ����� �� �������
#ifeq (,$(WORKDIR))
#WORKDIR = $(shell pushd ../.. 1>/dev/null && pwd )
#endif
WORKDIR=/home/ovtin/development/


#�ӣ ��� �������� �������� ����� :) - ���������� �����������������
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
LD_LOCAL := g++

# �������������� ����� ��� ����������� C/C++
COPTS  = -I./ -I/cern/pro/include/cfortran/ -Df2cFortran

# �������������� ����� ��� ����������� Fortran
#FOPTS  =

# ���������� ����������� - ������-�� ����� ��� �������������
#NOOPT = " "

# �������������� ����� ��� �������
LDOPTS = -lg2c -Wl,-rpath=`root-config --libdir`
#-shared #���� ������� ������������ ����������� ����������
#���� ���������� �������� CERNLIB, �� ����� ��������������� ���� ��������
CERNLIBRARY = ""
#������ ���������, ���� ��� �� �������� ����������� ����� (��������� �� ����������)
# jetset74 mathlib graflib geant321 grafX11 packlib
CERNLIBS = jetset74 mathlib graflib geant lapack3 blas

#���� ���������� ���������� ONLYBINARY, �� ���������� � ������ �����������
ONLYBINARY=""
# ��� ���������� ����������� �����
BINDIR=./
#����������������, ���� ������� ������� ������������ ����������
#LIB_SHARED = ""

# �������������� ���� (����������� ����� ���)
#LIB_LOCAL= `root-config --libs` -lMinuit -lpq -lcrypt -lbz2 -lstdc++
LIB_LOCAL=`root-config --libs` -lMinuit -lpq -lcrypt -lbz2 -lg2c

# ���������, ����� ��������� �� ����� ��������
# ����� ������� ��������� ������ ������������ ��� ������ ������,
# ����� �� �������� bin - ��� ����������, ������� ������� ��� �������
# � ������������ ������� ���������� � ���������� example
BINARIES = show

# ������, �� ����� ������� ����� ������ ��� �������
# (��� ������ �� ����� �������� � ����������)
# � ����� ���������� ���� ���������� ��� ������
show_MODULES = show
#show_LIBS    = KrAtc KDisplay VDDCRec KrToF KsToF KdDCSim VDDCRec DchGeom ReadNat KDB FitTools KrAtc AppFramework KEmcDraw KEmcRec LKrTools VDDCRec
#show_LIBS := KaFramework KrAtc KDisplay VDDCRec KrVDDCMu KrMu \
#KrdEdxPId KrDCCalibdEdx DchdEdxDataRoot VDDCRec KrToF KsToF KEmcRec LKrTools \
#VDDCRec KsTrg KdConvert KrObjects KdDCSim FitTools DchGeom ReadNat KDB AppFramework KrKRec KrDONLP2
show_LIBS    = KDisplay VDDCRec KsTrg KdDCSim VDDCRec DchGeom FitTools KEmcRec LKrTools \
               KrToF KsToF KrAtc VDDCRec KrMu AppFramework KdConvert KrObjects KDB ReadNat g2c bz2 pq stdc++

# ��������� ������ ����� �� �������
#-----------------------------------
include $(WORKDIR)/KcReleaseTools/rules.mk
#-----------------------------------

#-----------------------------------
# ���� ������� ������� ���-�� �������������, �� �� �����������
#-----------------------------------
# ���� ���� ������� ���������� �����.
# ����� ����������� �������� ������� ��������
# ������ ��������� <Tab>.


#���� ������ ������� ���-�� �� ������ ������
#����������� ��� ���������� make ��� ����������
PRE_MAKE:
	@echo "This should be done before compiling"

#���� ������ ������� ���-�� ����� ������ ������
#����������� ��� ���������� make ��� ����������
POST_MAKE:
	@echo "This should be done after compiling"

# ���� ������� ������� ���-��  �ݣ
mytag:
	@echo "my tag"
