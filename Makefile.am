#
# Copyright (c) 2014 Rick Salevsky <rsalevsky@suse.de>
#
MAKEFLAGS = --no-print-directory

AUTOMAKE_OPTIONS = 1.13 foreign dist-bzip2 no-dist-gzip

SUBDIRS = xml

CLEANFILES = *~

M4_FILES = m4/jh_path_xml_catalog.m4

EXTRA_DIST = $(M4_FILES) DC-release-notes LICENSE

ACLOCAL_AMFLAGS = -I m4

langs = en ar cs de el es fi fr hu it ja lt nb nl pl pt_BR ro ru zh_CN zh_TW
po_files = $(foreach l, $(langs), po/$(l).po)
xml_files = $(foreach l, $(langs), xml/release-notes.$(l).xml)

pot: release-notes.pot
release-notes.pot: xml/release-notes.ent xml/release-notes.xml
	$(XML2PO) --expand-all-entities -o release-notes.pot xml/release-notes.xml

po: $(po_files)
$(po_files): release-notes.pot
	po_file=`echo $@`; \
	if [ -r $${po_file} ]; then \
		$(MSGMERGE)  --no-wrap --update $${po_file} release-notes.pot; \
	else \
		$(MSGEN) -o $${po_file} release-notes.pot; \
	fi

xml: $(xml_files)
$(xml_files): po_files xml/release-notes.ent xml/release-notes.xml
	xml_file=`echo $@`; \
	lang=`echo xml_file | awk -F '.' '{print $2}'`; \
	$(XML2PO) -p po/$${lang}.po -o $${xml_file} xml/release-notes.xml; \

dist-hook:
	sed -i "s/\(RN_DATE, \).*/\1$$(date --iso))/" configure.ac \
	  && autoreconf \
	  && for file in configure configure.ac aclocal.m4 Makefile.in; do \
	       cp -p  $(srcdir)/$$file $(distdir)/$$file ; \
	     done
