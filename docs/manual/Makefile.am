
docbook_docs = $(srcdir)/libsigc_manual.xml

include $(top_srcdir)/docs/Makefile_web.am_fragment
libsigc_manual = $(web_path_docs)manual

EXTRA_DIST = README $(docbook_docs)

DOCBOOK_STYLESHEET ?= http://docbook.sourceforge.net/release/xsl/current/html/chunk.xsl

html: $(srcdir)/libsigc_manual.xml
	xsltproc -o html/ --catalogs $(DOCBOOK_STYLESHEET) $(srcdir)/libsigc_manual.xml

libsigc_manual-html.tar.gz: $(srcdir)/html
	tar -cf - $< | gzip > $@

%.dvi: $(srcdir)/%.xml
	db2dvi $<

%.ps: $(srcdir)/%.xml
	db2ps $<

%.pdf: $(srcdir)/%.xml
	db2pdf $<


post-lumps: $(srcdir)/libsigc_manual.dvi $(srcdir)/libsigc_manual.ps $(srcdir)/libsigc_manual.pdf $(srcdir)/libsigc_manual-html.tar.gz
	tar -cf - $^ | ssh $$SSH_OPT $$USER@libsigc.sourceforge.net "cd $(libsigc_manual) ; tar -xvf - ; chmod a+r,g+w * ; chgrp gtkmm *"

post-html: $(srcdir)/html
	(cd html && tar -cf - *.html | gzip -3 | \
	 ssh $$SSH_OPT $$USER@libsigc.sourceforge.net "cd $(libsigc_manual)/html ; gunzip | tar -xvf - ; chmod a+r,g+w * ; chgrp gtkmm *")


all-local: $(srcdir)/html

clean-local:
	-rm -rf $(srcdir)/html
	-rm -f $(srcdir)/libsigc_manual.dvi $(srcdir)/libsigc_manual.ps $(srcdir)/libsigc_manual.pdf $(srcdir)/libsigc_manual-html.tar.gz

