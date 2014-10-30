#
# Copyright (c) 2014 Rick Salevsky <rsalevsky@suse.de>
#

.PHONY: clean po pot pdf txt single-html yast-html

ifndef LANGS
  LANGS := en ar cs de el es fi fr it ja lt nb nl pt_BR ru uk zh_CN zh_TW
endif
ifndef STYLEROOT
  STYLEROOT := /usr/share/xml/docbook/stylesheet/opensuse2013
endif
PO_FILES := $(foreach l, $(LANGS), po/$(l).po)
XML_FILES := $(foreach l, $(LANGS), xml/release-notes.$(l).xml)
PDF_FILES := $(foreach l, $(LANGS), build/release-notes.$(l)/release-notes.$(l)_color_$(l).pdf)
SINGLE_HTML_FILES := $(foreach l, $(LANGS), build/release-notes.$(l)/single-html/release-notes.$(l)/index.html)
YAST_HTML_FILES := $(foreach l, $(LANGS), build/release-notes.$(l)/yast-html/release-notes.$(l).html)
TXT_FILES := $(foreach l, $(LANGS), build/release-notes.$(l)/release-notes.$(l).txt)
DIRS := $(foreach l, $(LANGS), build/release-notes.$(l)/yast-html/)

LANG_COMMAND = `echo $@ | awk -F '.' '{print $$2}' | awk -F '/' '{print $$1}'`
DAPS_COMMAND = daps -m xml/release-notes.$${lang}.xml --styleroot $(STYLEROOT)
XSLTPROC_COMMAND = xsltproc \
--stringparam generate.toc "book toc" \
--stringparam generate.section.toc.level 0 \
--stringparam section.autolabel 1 \
--stringparam section.label.includes.component.label 2 \
--stringparam variablelist.as.blocks 1 \
--stringparam toc.max.depth 3 \
--stringparam show.comments 0 \
--xinclude --nonet

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
	lang=$(LANG_COMMAND) ; \
	$(DAPS_COMMAND) pdf

single-html: $(SINGLE_HTML_FILES)
$(SINGLE_HTML_FILES): $(XML_FILES)
	lang=$(LANG_COMMAND) ; \
	$(DAPS_COMMAND) html --single \
	--static --xsltparam="'--stringparam homepage=http://www.opensuse.com'"

yast-html: | $(DIRS) $(YAST_HTML_FILES)
$(YAST_HTML_FILES): xml/release-notes.ent xml/release-notes.xml
	$(XSLTPROC_COMMAND) /usr/share/daps/daps-xslt/relnotes/yast.xsl xml/release-notes.xml > $@; \
	recode latin1..ascii $@

txt: $(TXT_FILES)
$(TXT_FILES): $(XML_FILES)
	lang=$(LANG_COMMAND) ; \
	$(DAPS_COMMAND) text

$(DIRS):
	mkdir -p $@

clean:
	rm -rf po/*~ build/ $(XML_FILES) release-notes.pot
