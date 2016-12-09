#
# Copyright (c) 2014 Rick Salevsky <rsalevsky@suse.de>
# Copyright (c) 2016 Stefan Knorr <sknorr@suse.de>
#

# How to use this makefile:
# * After updating the XML: $ make po
# * When creating output:   $ make linguas; make all
# * To clean up:            $ make clean

.PHONY: clean po pot pdf text single-html yast-html translatedxml profile

ifndef LANGS
  LANGS := $(shell cat po/LINGUAS)
endif
LANGSEN := $(LANGS) en
ifndef STYLEROOT
  STYLEROOT := /usr/share/xml/docbook/stylesheet/opensuse2013-ns
endif
ifndef SCHEMA
  SCHEMA := file:///usr/share/xml/docbook/schema/rng/5.1/docbookxi.rnc
endif
ifndef VERSION
  VERSION := unreleased
endif

# Allows for DocBook profiling (hiding/showing some text).
LIFECYCLE_VALID := beta pre maintained unmaintained
ifndef LIFECYCLE
  LIFECYCLE := maintained
endif
ifneq "$(LIFECYCLE)" "$(filter $(LIFECYCLE),$(LIFECYCLE_VALID))"
  override LIFECYCLE := maintained
endif


# Update all PO files
PO_FILES := $(wildcard po/*.po)

# For output, use only those files that have at least 60% translations
XML_FILES := $(foreach l, $(LANGS), xml/release-notes.$(l).xml)
PDF_FILES := $(foreach l, $(LANGSEN), build/release-notes.$(l)/release-notes.$(l)_color_$(l).pdf)
SINGLE_HTML_FILES := $(foreach l, $(LANGSEN), build/release-notes.$(l)/single-html/release-notes.$(l)/index.html)
YAST_PROFILED_FILES := $(foreach l, $(LANGSEN), build/.profiled/general_$(LIFECYCLE)/release-notes.$(l).xml)
YAST_HTML_FILES := $(foreach l, $(LANGSEN), build/release-notes.$(l)/yast-html/release-notes.$(l).html)
TXT_FILES := $(foreach l, $(LANGSEN), build/release-notes.$(l)/release-notes.$(l).txt)
DIRS := $(foreach l, $(LANGSEN), build/release-notes.$(l)/yast-html/)

# Gets the language code: release-notes.en.xml => en
LANG_COMMAND = `echo $@ | awk -F '.' '{gsub("/.*","",$$2); print($$2)}'`
LANG_COMMAND_PROFILE = `echo $@ | awk -F '.' '{gsub("/.*","",$$3); print($$3)}'`
DAPS_COMMAND_BASIC = daps -vv --styleroot $(STYLEROOT) --schema=$(SCHEMA)
DAPS_COMMAND = $(DAPS_COMMAND_BASIC) -m xml/release-notes.$${lang}.xml

XSLTPROC_COMMAND = xsltproc \
--stringparam generate.toc "book toc" \
--stringparam generate.section.toc.level 0 \
--stringparam section.autolabel 1 \
--stringparam section.label.includes.component.label 2 \
--stringparam variablelist.as.blocks 1 \
--stringparam toc.max.depth 3 \
--stringparam show.comments 0 \
--xinclude --nonet

all: single-html yast-html pdf text

linguas: po/LINGUAS

po/LINGUAS: po/*.po po/po-selector
	po/po-selector

pot: release-notes.pot
release-notes.pot: xml/release-notes.xml xml/release-notes.ent
	$(DAPS_COMMAND_BASIC) -m $< validate
	xml2po --expand-all-entities -o $@ $<

po: $(PO_FILES)
po/%.po: release-notes.pot
	if [ -r $@ ]; then \
       msgmerge  --previous --update $@ $<; \
   else \
       msgen -o $@ $<; \
   fi

# FIXME: Unfortunately, xml2po has some issues with namespaces. We can avoid
# those using sed. However, that is more like a last resort here. What we really
# need is a docbook5 mode for xml2po. Issues are:
# * need to use xml:lang (instead of lang)
# * need to use link xlink:href (link href, occasionally also ulink url and
#   mixtures because of old translations)
# * need to handle dm: tags (right they are just removed)
# Finally:
# * fix translations of @VERSION@ (would be nice to exclude that too, though)
# * Remove trailing spaces in the translated files (because they are ugly and
#   unpredictable)
xml/release-notes.%.xml: po/%.po xml/release-notes.ent xml/release-notes.xml
	xml2po --expand-all-entities -p $< -o $@ xml/release-notes.xml;
	sed -i -r \
	  -e 's_(<article [^>]*)xml:lang="en"_\1_' \
	  -e 's_(<article [^>]*)lang=_\1xml:lang=_' \
	  -e 's_<(ulink|link) (xlink:)?(href|url)=_<link xlink:href=_g' \
	  -e '/^ *<dm:docmanager.*$$/,/^ *<\/dm:docmanager>.*$$/d' \
	  -e "s_<releaseinfo>[^>]+>_<releaseinfo>$(VERSION)</releaseinfo>_" \
	  -e 's_\s+$$__' \
	  $@;
	$(DAPS_COMMAND_BASIC) -m $@ validate

translatedxml: xml/release-notes.xml xml/release-notes.ent $(XML_FILES)
	cp $< xml/release-notes.en.xml
	sed -i -r -e "s_<releaseinfo>[^>]+>_<releaseinfo>$(VERSION)</releaseinfo>_" \
	  xml/release-notes.en.xml

pdf: $(PDF_FILES)
$(PDF_FILES): po/LINGUAS translatedxml
	lang=$(LANG_COMMAND) ; \
	$(DAPS_COMMAND) pdf PROFCONDITION="general\;$(LIFECYCLE)"

single-html: $(SINGLE_HTML_FILES)
$(SINGLE_HTML_FILES): po/LINGUAS translatedxml
	lang=$(LANG_COMMAND) ; \
	$(DAPS_COMMAND) html --single \
	--stringparam "homepage='https://www.opensuse.org'" \
	PROFCONDITION="general\;$(LIFECYCLE)"

yast-html: | $(DIRS) $(YAST_HTML_FILES)
$(YAST_HTML_FILES): po/LINGUAS $(YAST_PROFILED_FILES)
	lang=$(LANG_COMMAND) ; \
	  $(XSLTPROC_COMMAND) /usr/share/daps/daps-xslt/relnotes/yast.xsl build/.profiled/general_$(LIFECYCLE)/release-notes.$${lang}.xml > $@

# xsltproc by itself does not support profiling, so we need to do this
# beforehand for YaST HTML
profile: $(YAST_PROFILED_FILES)
$(YAST_PROFILED_FILES): po/LINGUAS translatedxml
	lang=$(LANG_COMMAND_PROFILE) ; \
	$(DAPS_COMMAND) profile \
	PROFCONDITION="general\;$(LIFECYCLE)"

text: $(TXT_FILES)
$(TXT_FILES): po/LINGUAS translatedxml
	lang=$(LANG_COMMAND) ; \
	LANG=$${lang} $(DAPS_COMMAND) text \
	PROFCONDITION="general\;$(LIFECYCLE)"

$(DIRS):
	mkdir -p $@

clean:
	rm -rf po/*~ po/LINGUAS build/ xml/release-notes.*.xml release-notes.pot
