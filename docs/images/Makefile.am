
EXTRA_DIST = libsigc_logo.gif top.gif

# Post to the website.
include $(top_srcdir)/docs/Makefile_web.am_fragment

imagesdir   = $(libsigc_docdir)/images
images_DATA = libsigc_logo.gif top.gif

post-html: libsigc_logo.gif top.gif
	rsync $(rsync_args) $^ $$USER@shell.sourceforge.net:$(web_path_docs)images/

doc-clean:

.PHONY: post-html doc-clean

