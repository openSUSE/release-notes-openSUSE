#
# Copyright (c) 2014 Rick Salevsky <rsalevsky@suse.de>
#
MAKEFLAGS = --no-print-directory

EXTRA_DIST = release-notes.ent.in release-notes.xml yast.xsl

W3M_OPTS = -cols 76 -O ascii -T text/html -dump
W3M_COMMAND = $(W3M) $(W3M_OPTS)
COMMENTS = 0

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

all: release-notes.txt release-notes.html release-notes-static	\
release-notes.rtf release-notes.pdf

release-notes.pdf: release-notes.ent release-notes.en.xml
	PDF=$$(daps -d ../DC-release-notes pdf-name); \
	daps -v -d ../DC-release-notes pdf; \
	mv $$PDF $@

release-notes.txt: release-notes.html
	sed 's|&#9675;|-|g;s|&#8226;|+|g;s|&#822[01];|"|g;s|&#8212;|--|g' $< \
	  | $(W3M_COMMAND) > $@

release-notes.html: release-notes.ent release-notes.en.xml
	$(XSLTPROC_COMPLEX_COMMAND) ./yast.xsl $< > $@
	recode latin1..ascii $@

release-notes-static: release-notes.ent release-notes.en.xml
	WEB=$$(daps -d ../DC-release-notes html-dir-name --single); \
	daps -v -d ../DC-release-notes html --single --static; \
	rm -fr $@; mv $$WEB $@

release-notes.rtf: release-notes.html
	ln -f release-notes.html release-notes.rtf

clean-local:
	rm -rf release-notes.fo release-notes.html release-notes.pdf \
	release-notes.txt release-notes.rtf release-notes.ent \
	release-notes-static *~
