#
# Copyright (c) 2014 Rick Salevsky <rsalevsky@suse.de>
#
MAKEFLAGS = --no-print-directory

AUTOMAKE_OPTIONS = 1.13 foreign dist-bzip2 no-dist-gzip

CLEANFILES = *~

M4_FILES = m4/jh_path_xml_catalog.m4

EXTRA_DIST = $(M4_FILES) DC-release-notes LICENSE xml/release-notes.ent.in \
			 xml/release-notes.xml xml/yast.xsl

ACLOCAL_AMFLAGS = -I m4

.PHONY: po pdf

XML2PO := /usr/bin/xml2po
MSGMERGE := /usr/bin/msgmerge
MSGEN := /usr/bin/msgen

W3M_OPTS := -cols 76 -O ascii -T text/html -dump
W3M_COMMAND := $(W3M) $(W3M_OPTS)
COMMENTS := 0

XSLTPROC_COMPLEX_COMMAND = $(XSLTPROC) \
--stringparam generate.toc "book toc" \
--stringparam generate.section.toc.level 0 \
--stringparam section.autolabel 1 \
--stringparam section.label.includes.component.label 2 \
--stringparam variablelist.as.blocks 1 \
--stringparam toc.max.depth 3 \
--stringparam show.comments $(COMMENTS) \
--xinclude --nonet \
--stringparam profile.arch "$(arch)" \
--stringparam profile.os "$(prod)"

LANGS ?= en ar cs de el es fi fr hu it ja lt nb nl pl pt_BR ro ru zh_CN zh_TW
STYLEROOT ?= /home/rsalevsky/doku/daps-svn/daps/suse/opensuse2013/
PO_FILES := $(foreach l, $(LANGS), po/$(l).po)
XML_FILES := $(foreach l, $(LANGS), xml/release-notes.$(l).xml)
#PDF_FILES := $(foreach l, $(LANGS), foo/release-notes.$(l)_color_$(l).pdf)
PDF_FILES := $(foreach l, $(LANGS), build/release-notes.$(l)/release-notes.$(l)_color_$(l).pdf)

pot: release-notes.pot
release-notes.pot: xml/release-notes.ent xml/release-notes.xml
	$(XML2PO) --expand-all-entities -o release-notes.pot xml/release-notes.xml

po/%.po: release-notes.pot
	if [ -r $@ ]; then \
        $(MSGMERGE)  --no-wrap --update $@ release-notes.pot; \
    else \
        $(MSGEN) -o $@ release-notes.pot; \
    fi

xml/release-notes.%.xml: po xml/release-notes.ent xml/release-notes.xml
	$(XML2PO) -p $< -o $@ xml/release-notes.xml;

#build/release-notes.%/release-notes.%_color_%.pdf: xml/release-notes.%.xml
build/release-notes.%.pdf: xml/release-notes.%.xml
	daps -m  $< --styleroot $(STYLEROOT) --builddir foo pdf;

po: $(PO_FILES)

pdf: $(PDF_FILES)

clean-local:
	rm -rf po/*~ $(XML_FILES) release-notes.pot

dist-hook:
	sed -i "s/\(RN_DATE, \).*/\1$$(date --iso))/" configure.ac \
	&& autoreconf \
    && for file in configure configure.ac aclocal.m4 Makefile.in; do \
		cp -p  $(srcdir)/$$file $(distdir)/$$file ; \
    done
