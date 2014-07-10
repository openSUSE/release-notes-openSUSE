#
# Copyright (c) 2014 Rick Salevsky <rsalevsky@suse.de>
#
MAKEFLAGS = --no-print-directory

CLEANFILES = *~

M4_FILES = m4/jh_path_xml_catalog.m4

EXTRA_DIST = $(M4_FILES) DC-release-notes LICENSE xml/release-notes.ent.in \
			 xml/release-notes.xml xml/yast.xsl

ACLOCAL_AMFLAGS = -I m4

.PHONY: clean po pot pdf txt single-html yast-html

XSLTPROC_COMMAND = xsltproc \
--stringparam generate.toc "book toc" \
--stringparam generate.section.toc.level 0 \
--stringparam section.autolabel 1 \
--stringparam section.label.includes.component.label 2 \
--stringparam variablelist.as.blocks 1 \
--stringparam toc.max.depth 3 \
--stringparam show.comments 0 \
--xinclude --nonet \
--stringparam profile.arch "$(arch)" \
--stringparam profile.os "$(prod)"

ifndef
  LANGS := en ar cs de el es fi fr hu it ja lt nb nl pl pt_br ro ru zh_cn zh_tw
endif
ifndef
  STYLEROOT := /usr/share/xml/docbook/stylesheet/opensuse2013
endif
PO_FILES := $(foreach l, $(LANGS), po/$(l).po)
XML_FILES := $(foreach l, $(LANGS), xml/release-notes.$(l).xml)
PDF_FILES := $(foreach l, $(LANGS), build/release-notes.$(l)/release-notes.$(l)_color_$(l).pdf)
SINGLE_HTML_FILES := $(foreach l, $(LANGS), build/release-notes.$(l)/single-html/release-notes.$(l)/index.html)
YAST_HTML_FILES := $(foreach l, $(LANGS), build/release-notes.$(l)/yast-html/release-notes.$(l).html)
TXT_FILES := $(foreach l, $(LANGS), build/release-notes.$(l)/release-notes.$(l).txt)
DIRS := $(foreach l, $(LANGS), build/release-notes.$(l)/yast-html/)

all: single-html yast-html pdf txt

pot: release-notes.pot
release-notes.pot: xml/release-notes.ent xml/release-notes.xml
	xml2po --expand-all-entities -o release-notes.pot xml/release-notes.xml

po: $(PO_FILES)
po/%.po: release-notes.pot
	if [ -r $@ ]; then \
        msgmerge  --no-wrap --update $@ release-notes.pot; \
    else \
        msgen -o $@ release-notes.pot; \
    fi

xml/release-notes.%.xml: po/%.po xml/release-notes.ent xml/release-notes.xml
	xml2po -p $< -o $@ xml/release-notes.xml;

pdf: $(PDF_FILES)
$(PDF_FILES): $(XML_FILES)
	lang=`echo $@ | awk -F '.' '{print $$2}' | awk -F '/' '{print $$1}'`; \
	daps -m xml/release-notes.$${lang}.xml --styleroot $(STYLEROOT) pdf

single-html: $(SINGLE_HTML_FILES)
$(SINGLE_HTML_FILES): $(XML_FILES)
	lang=`echo $@ | awk -F '.' '{print $$2}' | awk -F '/' '{print $$1}'`; \
	daps -m xml/release-notes.$${lang}.xml --styleroot "$(STYLEROOT)" html --single \
	--static --xsltparam="'--stringparam homepage=http://www.opensuse.com'"

yast-html: | $(DIRS) $(YAST_HTML_FILES)
$(YAST_HTML_FILES): xml/release-notes.ent xml/release-notes.xml
	$(XSLTPROC_COMMAND) ./yast.xsl xml/release-notes.xml > $@; \
	recode latin1..ascii $@

txt: $(TXT_FILES)
$(TXT_FILES): $(XML_FILES)
	lang=`echo $@ | awk -F '.' '{print $$2}' | awk -F '/' '{print $$1}'`; \
	daps -m xml/release-notes.$${lang}.xml --styleroot $(STYLEROOT) text

$(DIRS):
	mkdir -p $@

clean:
	rm -rf po/*~ build/ $(XML_FILES) release-notes.pot

dist-hook:
	sed -i "s/\(RN_DATE, \).*/\1$$(date --iso))/" configure.ac \
	&& autoreconf \
    && for file in configure configure.ac aclocal.m4 Makefile.in; do \
		cp -p  $(srcdir)/$$file $(distdir)/$$file ; \
    done
