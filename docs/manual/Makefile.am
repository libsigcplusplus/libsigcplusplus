
docbook_docs = $(srcdir)/libsigc_manual.xml

include $(top_srcdir)/docs/Makefile_web.am_fragment
libsigc_manual = $(web_path_docs)manual

EXTRA_DIST = README $(docbook_docs) html

DOCBOOK_STYLESHEET ?= http://docbook.sourceforge.net/release/xsl/current/html/chunk.xsl

html/index.html: $(srcdir)/libsigc_manual.xml
	-rm -rf html
	$(mkinstalldirs) html
	xsltproc -o html/ --catalogs $(DOCBOOK_STYLESHEET) $<

libsigc_manual-html.tar.gz: $(srcdir)/html
	tar -cf - $< | gzip > $@

%.dvi: $(srcdir)/%.xml
	db2dvi $<

%.ps: $(srcdir)/%.xml
	db2ps $<

%.pdf: $(srcdir)/%.xml
	db2pdf $<


post-lumps: $(srcdir)/libsigc_manual.dvi $(srcdir)/libsigc_manual.ps $(srcdir)/libsigc_manual.pdf $(srcdir)/libsigc_manual-html.tar.gz
	tar -cf - $^ | ssh $$SSH_OPT $$USER@libsigc.sourceforge.net "cd $(libsigc_manual) ; tar -xvf - ; chmod a+r,g+w * ; chgrp libsigc *"

post-html: $(srcdir)/html/index.html
	(cd html && tar -cf - *.html | gzip -3 | \
	 ssh $$SSH_OPT $$USER@libsigc.sourceforge.net "cd $(libsigc_manual)/html ; gunzip | tar -xvf - ; chmod a+r,g+w * ; chgrp libsigc *")

tutorialdir = $(libsigc_docdir)/tutorial/html

install-tutorial: $(srcdir)/html/index.html
	@$(NORMAL_INSTALL)
	$(mkinstalldirs) $(DESTDIR)$(tutorialdir)
	@dir='$(<D)'; for p in $$dir/*.html ; do \
	  f="`echo $$p | sed -e 's|^.*/||'`"; \
	  echo " $(INSTALL_DATA) $$p $(DESTDIR)$(tutorialdir)/$$f"; \
	  $(INSTALL_DATA) $$p $(DESTDIR)$(tutorialdir)/$$f; \
	done

uninstall-tutorial: $(srcdir)/html/index.html
	@$(NORMAL_UNINSTALL)
	@dir='$(<D)'; for p in $$dir/*.html ; do \
	  f="`echo $$p | sed -e 's|^.*/||'`"; \
	  echo " rm -f $(DESTDIR)$(tutorialdir)/$$f"; \
	  rm -f $(DESTDIR)$(tutorialdir)/$$f; \
	done

install-data-local: install-tutorial

uninstall-local: uninstall-tutorial

all-local: $(srcdir)/html/index.html

clean-local:
	-rm -rf $(srcdir)/html
	-rm -f $(srcdir)/libsigc_manual.dvi $(srcdir)/libsigc_manual.ps $(srcdir)/libsigc_manual.pdf $(srcdir)/libsigc_manual-html.tar.gz

