#
# Copyright (c) 2014 Rick Salevsky <rsalevsky@suse.de>
#
MAKEFLAGS = --no-print-directory

AUTOMAKE_OPTIONS = 1.3 foreign dist-bzip2 no-dist-gzip

SUBDIRS = xml

CLEANFILES = *~

M4_FILES = m4/jh_path_xml_catalog.m4

EXTRA_DIST = $(M4_FILES) DC-release-notes LICENSE

ACLOCAL_AMFLAGS = -I m4

dist-hook:
	sed -i "s/\(RN_DATE, \).*/\1$$(date --iso))/" configure.ac \
	  && autoreconf \
	  && for file in configure configure.ac aclocal.m4 Makefile.in; do \
	       cp -p  $(srcdir)/$$file $(distdir)/$$file ; \
	     done
