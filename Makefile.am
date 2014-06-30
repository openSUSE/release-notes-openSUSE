fname = RELEASE-NOTES-openSUSE
langs = en
langs += ar cs de el es fi fr hu it ja lt nb nl pl pt_BR ro ru zh_CN zh_TW
remove_temp = 
broken_pdf = ar
wanted_langs = $(filter-out $(remove_temp),$(langs))
wanted_pdf_langs = $(filter-out $(broken_pdf),$(langs))

files = $(foreach l, $(langs), $(fname).$(l).xml)
ifiles = $(foreach l, $(wanted_langs), $(fname).$(l).xml)
out = $(files:.xml=.out)
txt = $(files:.xml=.txt)
fo = $(files:.xml=.fo)
# pdf = $(files:.xml=.pdf)
pdf = $(foreach l, $(wanted_pdf_langs), $(fname).$(l).pdf)
ipdf = $(ifiles:.xml=.pdf)
#rtf = $(subst -openSUSE,,$(files:.xml=.rtf))
#irtf = $(subst -openSUSE,,$(ifiles:.xml=.rtf))
rtf = $(files:.xml=.rtf)
#irtf = $(ifiles:.xml=.rtf)
itxt = $(ifiles:.xml=.txt)
html = $(files:.xml=.html)
ihtml = $(ifiles:.xml=.html)
if ENABLE_GENERATE_PDF
iall = $(ihtml) $(itxt) $(ipdf)
else
iall = $(ihtml) $(itxt)
endif
valid = $(files:.xml=.valid)
# missing = $(files:.xml=.missing)
# pofiles = $(files:.xml=.po)
# po files are in the po/ directory
pofiles = $(foreach l, $(langs), po/$(l).po)
missing = $(pofiles:.po=.missing)
dsssl_styles = rel.dsl
xsl_styles = docbook-utf-8.xsl yast.xsl html.xsl profile.xsl
styles = $(dsssl_styles) $(xsl_styles)
spec = release-notes-openSUSE.spec
specs = $(spec) $(spec).in

AUTOMAKE_OPTIONS = foreign dist-bzip2 no-dist-gzip
# .SUFFIXES:
# .SUFFIXES: .po .gmo .mo .sed .sin .nop .po-update
SUFFIXES = .xml .out .rtf .html .valid .po .txt .pdf .fo

EXTRA_DIST = $(fname).xml $(pofiles) $(styles) $(specs) fdl.txt	\
release-notes.ent.in
CLEANFILES = $(fo) $(out) $(pdf) $(rtf) $(txt) $(html) $(valid) $(spec) $(missing)
DISTCLEANFILES = release-notes.ent

arch = @arch@
prod = slprof
SUSE_PROD = @SUSE_PROD@

XSLTPROC = @XSLTPROC@
XMLLINT = @XMLLINT@
NSGMLS = @NSGMLS@
XML2PO = @XML2PO@

BROWSER = @W3M@ -cols 76 -I UTF-8 -O UTF-8 -T text/html -dump

MSGMERGE_UPDATE = @MSGMERGE@ --no-wrap --update
MSGMERGE = @MSGMERGE@ --no-wrap
MSGCAT = @MSGCAT@
XSLT_COMPLEX_COMMAND = $(XSLTPROC) --nonet --output $@ \
--stringparam profile.arch "$(arch)" \
--stringparam profile.os "$(prod)"

#rndir=$(DESTDIR)$(datadir)/doc/$(PACKAGE_NAME)/$(SUSE_PROD)
rndir=$(DESTDIR)$(datadir)/doc/release-notes/$(SUSE_PROD)

all: validate html txt

%.out: %.xml $(missing)
	if [ -f $(subst out,missing,$@) ]; then \
	  $(XSLT_COMPLEX_COMMAND) \
	  --stringparam profile.role "transwarn" \
	  profile.xsl $< ; \
	else $(XSLT_COMPLEX_COMMAND) \
	  --stringparam profile.role "nowarn" \
	  profile.xsl $< ; \
	fi
#	$(XMLLINT) --noout --nonet --valid $@
# yast.xsl does not support xref elements
# %.rtf: %.out yast.xsl
# 	$(XSLTPROC) --nonet --output $@ yast.xsl $<
# https://bugzilla.novell.com/show_bug.cgi?id=849449 : "odd characters"
# &cir;  == &#9675;
# &bull; == &#8226;
%.txt: %.html
	$(BROWSER) $< \
	  | sed 's|[“”]|"|g;s|•|o|g;s|━|-|g' \
	  | sed 's|&#9675;|-|g;s|&#8226;|+|g;s|&#822[01];|"|g;s|&#8212;|--|g' \
	    > $@
# %.html: %.out yast.xsl html.xsl
# 	$(XSLTPROC) --xinclude --nonet --output $@ html.xsl $<
# 	SP_ENCODING=UTF-8 SP_CHARSET_FIXED=YES $(NSGMLS) -s $@
%.html: %.out
	$(XSLTPROC) --stringparam generate.toc "article toc" \
	  --stringparam menuchoice.separator ">" \
	  --stringparam section.autolabel 1 \
	  --stringparam section.label.includes.component.label 2 \
	  --stringparam toc.max.depth 3 \
	  --stringparam show.comments 0 \
	  --xinclude --nonet \
	  docbook-utf-8.xsl $< > $@
#%.xhtml:
#	$(XMLLINT) --noout --nonet --valid $@
%.fo: %.out
	$(XSLTPROC) --stringparam generate.toc "article toc" \
	  --stringparam menuchoice.separator ">" \
	  --stringparam section.autolabel 1 \
	  --stringparam section.label.includes.component.label 2 \
	  --stringparam toc.max.depth 3 \
	  --stringparam show.comments 0 \
	  --xinclude --nonet \
	  http://docbook.sourceforge.net/release/xsl/current/fo/profile-docbook.xsl $< > $@

%.pdf: %.fo
if ENABLE_GENERATE_PDF
	$(FO2PDF) $< $@
else
	echo "No fo2pdf processor installed, skip PDF generation"
endif

%.valid: %.xml
	$(XMLLINT) --nonet --valid --noout $< && touch $@

out: $(out)
# rtf: $(rtf)
txt: $(txt)
html: $(html)
# xml: $(files)
fo: $(fo)
pdf: $(pdf)

validate: $(valid)

$(fname).xml.valid: $(fname).xml
	$(XMLLINT) --nonet --valid --noout $< && touch $@
pot: $(fname).pot
$(fname).pot: $(fname).xml.valid
	$(XML2PO) --expand-all-entities -o $@ $(fname).xml

# $(fname).en.po:
# 	msgen -o $@ $(fname).pot

# xml2po --reuse RELEASE-NOTES.pl.xml RELEASE-NOTES.en.xml

po: $(pofiles) 
$(pofiles): $(fname).pot
#	@lang=`echo $@ | sed -e 's,.*/,,' -e 's/\.po$$//'`; 
#	echo "$(MSGMERGE_UPDATE) $${lang}.po $(fname).pot"; \
#	if [ $${lang} = $(fname).en ]; then \
#	  msgen -o $${lang}.po.new $(fname).pot ; \
#	  if [ -r $${lang}.po ]; then \
#	    $(MSGCAT) -o $${lang}.po.old --use-first $${lang}.po $${lang}.po.new ; \
#	    $(MSGMERGE) -o $${lang}.po $${lang}.po.old $(fname).pot ; \
#	  else mv $${lang}.po.new $${lang}.po ; fi ; \
#	else $(MSGMERGE_UPDATE) $${lang}.po $(fname).pot ; fi
	@lang=`echo $@`; \
	echo "$(MSGMERGE_UPDATE) $${lang} $(fname).pot"; \
	if [ $${lang} = po/en.po ]; then \
	  msgen -o $${lang}.new $(fname).pot ; \
	  if [ -r $${lang} ]; then \
	    $(MSGCAT) -o $${lang}.old --use-first $${lang} $${lang}.new ; \
	    $(MSGMERGE) -o $${lang} $${lang}.old $(fname).pot ; \
	  else mv $${lang}.new $${lang} ; fi ; \
	else $(MSGMERGE_UPDATE) $${lang} $(fname).pot ; fi
# /usr/bin/xml2po -u LANG.po book.xml

missing: $(missing)
#$(fname).xml.missing: 
%.missing: %.po
	rm -f $@
	if $$(msgfmt --stat --output /dev/null  $< 2>&1| grep -q -e "\(fuzzy\|untrans\)" ); then touch $@ && echo missing ; fi

xml: $(files) release-notes.ent
$(files): $(pofiles)
	@lang=`echo $@ | sed -e 's,.*/,,' -e 's/\.xml$$//'`; \
	echo "$(XML2PO) -p po/$${lang/$(fname).}.po -o $${lang}.xml $(fname).xml"; \
	$(XML2PO) -p po/$${lang/$(fname).}.po -o $${lang}.xml $(fname).xml

# de:
#	xml2po -p RELEASE-NOTES.de.po -o RELEASE-NOTES.de.xml RELEASE-NOTES.pot

install-data-local:
	$(mkinstalldirs) $(rndir)
	for file in $(iall) fdl.txt; do \
	  $(INSTALL_DATA) $$file $(rndir)/$${file/-openSUSE} ; \
	done

# Check whether it is possible to generate all wanted files
# 	make all
dist-hook:
	sed -i "s/\(RN_DATE, \).*/\1$$(date --iso))/" configure.ac \
	  && autoreconf \
	  && for file in configure configure.ac aclocal.m4 Makefile.in; do \
	       cp -p  $(srcdir)/$$file $(distdir)/$$file ; \
	     done

echo:
	echo files: $(files)
	echo pofiles: $(pofiles)
	echo missing: $(missing)

profile-test:
	xsltproc --nonet --output p-test.xml \
	  --stringparam profile.arch "i386" profile.xsl test.xml
	xsltproc --nonet --output test.rtf \
	  rn.xsl p-test.xml
	xsltproc --xinclude --nonet --output test.html \
	  html.xsl p-test.xml
