## Based on on:

## Copyright (c) 2001
## The gtkmm development team.

SUBDIRS = images reference manual

EXTRA_DIST = Makefile_web.am_fragment index.html

libsigc_doc_DATA = index.html

include $(top_srcdir)/docs/Makefile_web.am_fragment

# Post to the website.

post-html-recursive:
	list='$(SUBDIRS)'; for subdir in $$list; do \
	  test "$$subdir" = . || (cd $$subdir && $(MAKE) $(AM_MAKEFLAGS) post-html); \
	done

post-html-local: index.html
	scp $$SSH_OPT $^ $$USER@shell.sourceforge.net:$(web_path_docs)

post-html: post-html-recursive post-html-local

doc-clean-recursive:
	list='$(SUBDIRS)'; for subdir in $$list; do \
	  test "$$subdir" = . || (cd $$subdir && $(MAKE) $(AM_MAKEFLAGS) doc-clean); \
	done

doc-clean: doc-clean-recursive

doc-rebuild: doc-clean all

.PHONY: post-html post-html-recursive doc-clean doc-clean-recursive doc-rebuild

