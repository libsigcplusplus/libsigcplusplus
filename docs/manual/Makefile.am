
docbook_docs	= libsigc_manual.xml

include $(top_srcdir)/docs/Makefile_web.am_fragment
libsigc_manual  = $(web_path_docs)manual

EXTRA_DIST	= README $(docbook_docs)

DOCBOOK_STYLESHEET ?= http://docbook.sourceforge.net/release/xsl/current/html/chunk.xsl

html: libsigc_manual.xml
	xsltproc -o html/ --catalogs $(DOCBOOK_STYLESHEET) libsigc_manual.xml

libsigc_manual-html.tar.gz: html
	tar -cf - $< | gzip > $@

%.dvi: %.xml
	db2dvi $<

%.ps: %.xml
	db2ps $<

%.pdf: %.xml
	db2pdf $<


post-lumps: libsigc_manual.dvi libsigc_manual.ps libsigc_manual.pdf libsigc_manual-html.tar.gz
	tar -cf - $^ | ssh $$SSH_OPT $$USER@libsigc.sourceforge.net "cd $(libsigc_manual) ; tar -xvf - ; chmod a+r,g+w * ; chgrp gtkmm *"

post-html: html
	(cd html && tar -cf - *.html | gzip -3 | \
	 ssh $$SSH_OPT $$USER@libsigc.sourceforge.net "cd $(libsigc_manual)/html ; gunzip | tar -xvf - ; chmod a+r,g+w * ; chgrp gtkmm *")


all-local: html

clean-local:
	-rm -rf html
	-rm -f libsigc_manual.dvi libsigc_manual.ps libsigc_manual.pdf libsigc_manual-html.tar.gz

