doxygen_configfile = Doxyfile
doxygen_configfile_source = $(srcdir)/Doxyfile.in
beautify_docs = $(srcdir)/beautify_docs.pl

include $(top_srcdir)/docs/Makefile_web.am_fragment
web_path_reference = $(web_path_docs)reference

EXTRA_DIST = README Doxyfile.in \
             libsigc_header.html_fragment libsigc_footer.html_fragment \
             beautify_docs.pl \
             html libsigc_doxygen_tags

html: $(srcdir)/html/index.html
html/index.html: $(doxygen_configfile_source) $(beautify_docs)
	-rm -rf html
	SRCDIR=$(srcdir) TOP_SRCDIR=$(top_srcdir) doxygen $(doxygen_configfile)
	$(PERL_PATH) $(beautify_docs) html


libsigc-reference-html.tar.gz: $(srcdir)/html/index.html
	tar cf - html | gzip -c --best >$@

libsigc-reference-html.tar.bz2: $(srcdir)/html/index.html
	tar cf - html | bzip2 -c >$@

post-html: $(srcdir)/html/index.html
	rsync $(rsync_args) -r html/ $$USER@shell.sourceforge.net:$(web_path_reference)/html/

doc-clean:
	-rm -rf $(srcdir)/html
	-rm -f $(srcdir)/libsigc_doxygen_tags
	-rm -f $(srcdir)/libsigc-reference-html.tar.gz $(srcdir)/libsigc-reference-html.tar.bz2

referencedir = $(libsigc_docdir)/reference/html

install-reference: $(srcdir)/html/index.html
	@$(NORMAL_INSTALL)
	$(mkinstalldirs) $(DESTDIR)$(referencedir)
	@dir='$(<D)'; for p in $$dir/*.html $$dir/*.css $$dir/*.png $$dir/*.dot ; do \
	  f="`echo $$p | sed -e 's|^.*/||'`"; \
	  echo " $(INSTALL_DATA) $$p $(DESTDIR)$(referencedir)/$$f"; \
	  $(INSTALL_DATA) $$p $(DESTDIR)$(referencedir)/$$f; \
	done

uninstall-reference: $(srcdir)/html/index.html
	@$(NORMAL_UNINSTALL)
	@dir='$(<D)'; for p in $$dir/*.html $$dir/*.css $$dir/*.png $$dir/*.dot ; do \
	  f="`echo $$p | sed -e 's|^.*/||'`"; \
	  echo " rm -f $(DESTDIR)$(referencedir)/$$f"; \
	  rm -f $(DESTDIR)$(referencedir)/$$f; \
	done


all-local: html/index.html

install-data-local: install-reference

uninstall-local: uninstall-reference

maintainer-clean-local: doc-clean

.PHONY: post-html doc-clean install-reference uninstall-reference

