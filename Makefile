#!/usr/bin/make -f

##
# PASTELETS PROJECT
##
PROJ := pastelets
# directories/paths
SRCDIR := src
BUILDDIR := build
TMPDIR := tmp
WEBDIR := web
DESKTOPDIR :=  desktop
IMGDIR := img
COMMONLIB := $$HOME/common/lib
VPATH := $(WEBDIR):$(BUILDDIR):$(WEBDIR)/$(DESKTOPDIR):$(BUILDDIR)/$(DESKTOPDIR):
# files
COMPRESSEDFILES := pastelet.html.gz email.html.gz tel.html.gz
MANIFESTFILES= pastelet.manifest email.manifest tel.manifest
WEBDESKFILES := $(DESKTOPDIR)/index.html $(DESKTOPDIR)/pastelet-history.txt $(DESKTOPDIR)/$(VERSIONFILE)
IPHONEHTML := pastelet.html email.html tel.html
HTMLFILES = $(IPHONEHTML) index.html
JSFILES := js/email.js js/loader.js js/paste.js js/tel.js
SRCFILES = $(HTMLFILES) pastelet.manifest $(JSFILES)
VERSIONFILE := VERSION.txt
VERSIONTXT := $(SRCDIR)/$(VERSIONFILE)
# macros/utils
MMBUILDDATE := _MmBUILDDATE_
BUILDDATE := $(shell date)
MMVERSION := _MmVERSION_
VERSION := $(shell head -1 $(VERSIONTXT))
MMCOPYRIGHT := _MmCOPYRIGHT_
COPYRIGHT := 2008, 2009, 2010, 2011, 2012
MMSPECIAL := _MmSPECIAL_
HTMLCOMPRESSORJAR := htmlcompressor-1.5.2.jar
HTMLCOMPRESSORPATH := $(shell [[ 'cygwin' == $$OSTYPE ]] &&  echo "`cygpath -w $(COMMONLIB)`\\" || echo "$(COMMONLIB)/")
HTMLCOMPRESSOR := java -jar '$(HTMLCOMPRESSORPATH)$(HTMLCOMPRESSORJAR)'
COMPRESSOPTIONS := -t html -c utf-8 --remove-quotes --remove-intertag-spaces --remove-surrounding-spaces min --compress-js --compress-css
ECHOE := $(shell [[ 'cygwin' == $$OSTYPE ]] && echo -e 'echo -e' || echo 'echo\c')
GROWL := $(shell ! hash growlnotify &>/dev/null && $(ECHOE) 'true\c' || ([[ 'darwin11' == $$OSTYPE ]] && echo "growlnotify -t $(PROJ) -m\c" || ([[ 'cygwin' == $$OSTYPE ]] && echo -e "growlnotify /t:$(PROJ)\c" || $(ECHOE) '\c')) )
REPLACETOKENS = (perl -p -i -e 's/$(MMVERSION)/$(VERSION)/g;' $@; \
		perl -p -i -e 's/$(MMBUILDDATE)/$(BUILDDATE)/g;' $@; \
		perl -p -i -e 's/$(MMCOPYRIGHT)/$(COPYRIGHT)/g;' $@ )


default: minify | $(DESKTOPDIR) $(IMGDIR)
	@(echo '   Copy files to $(WEBDIR) directory...'; \
		cp -Rfp $(SRCDIR)/$(IMGDIR) $(WEBDIR); \
		cp -f $(TMPDIR)/pastelet.manifest $(WEBDIR)/___.manifest; \
		cp -fp $(TMPDIR)/pastelet.manifest $(WEBDIR)/email.manifest; \
		cp -fp $(TMPDIR)/pastelet.manifest $(WEBDIR)/tel.manifest; \
		mv -f $(TMPDIR)/index.html $(WEBDIR)/$(DESKTOPDIR); \
		cp -fp $(SRCDIR)/mm.css $(WEBDIR)/$(DESKTOPDIR); \
		cp -Rfp $(SRCDIR)/js $(WEBDIR)/$(DESKTOPDIR); \
		cp -fp $(SRCDIR)/*.txt $(WEBDIR)/$(DESKTOPDIR); \
		chmod -R 744 $(WEBDIR); \
		rm -rf $(TMPDIR) \
	)
	@$(ECHOE) "Done.\n"; $(GROWL) "Done."

minify: validatehtml | $(BUILDDIR)
	@$(GROWL) "Compression started"
	@(echo '   Compress files with htmlcompressor + gzip...'; \
		cd $(BUILDDIR); rm -f $(IPHONEHTML); \
		cd ../$(TMPDIR); \
		$(HTMLCOMPRESSOR) $(COMPRESSOPTIONS) -o ../$(BUILDDIR) $(IPHONEHTML); \
		cd ../$(BUILDDIR); \
		gzip -f9 $(IPHONEHTML); \
		mv -f pastelet.html.gz ___; \
		mv -f email.html.gz email; \
		mv -f tel.html.gz tel \
	)

validatehtml: makehtml
	@$(GROWL) "Validation started";
	@($(ECHOE) "   Validate HTML & JavaScript...\n"; \
		cd $(TMPDIR); \
		$(foreach html,$(HTMLFILES), \
			echo "$(html)"; \
			tidy -eq $(html); [[ $$? -lt 2 ]] && true; \
			[[ $(html) != "index.html" ]] && ( \
				jsl -process $(html) -nologo -nofilelisting -nosummary && echo ' JavaScript: OK') \
			|| echo ' JavaScript: NOT CHECKED- contains hosted script(s).'; \
			echo ; \
		) \
	)

makehtml: src2tmp | $(TMPDIR)
	@$(GROWL) 'Replaces started'
	@echo '   Replace tokens...'
	@(cd $(TMPDIR); \
		perl -p -i -e 'BEGIN{open F,"js/loader.js";@f=<F>}s# src=\"js/loader.js\"\>#\>@f#' $(HTMLFILES) ;\
		perl -p -i -e 's/pastelet\.manifest/___.manifest/g;' pastelet.html; \
		perl -p -i -e 's/(link rel=canonical href=\"http:\/\/mmind.me\/)pastelet/\\1___/g;' pastelet.html; \
		perl -p -i -e 'BEGIN{open F,"js/paste.js";@f=<F>}s# src=\"js/paste.js\"\>#\>@f#' pastelet.html index.html ;\
		perl -p -i -e 's/$(MMSPECIAL)/Email\/Login/g;' email.html; \
		perl -p -i -e 'BEGIN{open F,"js/email.js";@f=<F>}s# src=\"js/email.js\"\>#\>@f#' email.html; \
		perl -p -i -e 's/special_Pastelet/Email\/Login Pastelet/g;' email.html ;\
		perl -p -i -e 's/email.manifest/tel.manifest/g;' tel.html; \
		perl -p -i -e 's/(link rel=canonical href=\"http:\/\/mmind.me\/)email/\\1tel/g;' tel.html; \
		perl -p -i -e 's/$(MMSPECIAL)/Telephone Number/g;' tel.html; \
		perl -p -i -e 's/type=\"email/type=\"tel/g;' tel.html; \
		perl -p -i -e 's/email\@abc\.com/8005551212/g;' tel.html; \
		perl -p -i -e 'BEGIN{open F,"js/tel.js";@f=<F>}s# src=\"js/email.js\"\>#\>@f#' tel.html; \
		perl -p -i -e 's/special_Pastelet/Telephone Number Pastelet/g;' tel.html \
	)

src2tmp:	| $(TMPDIR) $(IMGDIR)
	@$(GROWL) "Make started"
	@(echo '   Copy files from source to tmp directory...'; \
		cp -fp $(SRCDIR)/*.html $(TMPDIR); \
		cp -fp $(SRCDIR)/email.html $(TMPDIR)/tel.html; \
		cp -Rfp $(SRCDIR)/js $(TMPDIR); \
		cp -fp $(SRCDIR)/mm.css $(TMPDIR); \
		cp -fp $(SRCDIR)/pastelet.manifest $(TMPDIR); \
		cd $(TMPDIR); \
		perl -p -i -e 's/$(MMVERSION)/$(VERSION)/g;' $(SRCFILES); \
		perl -p -i -e 's/$(MMBUILDDATE)/$(BUILDDATE)/g;' $(SRCFILES); \
		perl -p -i -e 's/$(MMCOPYRIGHT)/$(COPYRIGHT)/g;' $(SRCFILES) \
	)

.PHONY: $(BUILDDIR)
$(BUILDDIR):
	@[[ -d $(BUILDDIR) ]] || mkdir -m 744 $(BUILDDIR)

.PHONY: $(DESKTOPDIR)
$(DESKTOPDIR):	| $(BUILDDIR) $(WEBDIR)
	@[[ -d $(BUILDDIR)/$(DESKTOPDIR) ]] || mkdir -m 744 $(BUILDDIR)/$(DESKTOPDIR)
	@[[ -d $(WEBDIR)/$(DESKTOPDIR) ]] || mkdir -m 744 $(WEBDIR)/$(DESKTOPDIR)

.PHONY: $(WEBDIR)
$(WEBDIR):
	@[[ -d $(WEBDIR) ]] || mkdir -m 744 $(WEBDIR)

.PHONY: $(IMGDIR)
$(IMGDIR):	| $(BUILDDIR) $(TMPDIR)
	@cp -Rfp $(SRCDIR)/$(IMGDIR) $(BUILDDIR)
	@cp -Rfp $(SRCDIR)/$(IMGDIR) $(TMPDIR)

.PHONY: $(TMPDIR)
$(TMPDIR):
	@[[ -d $(TMPDIR) ]] || mkdir -m 744 $(TMPDIR)

.PHONY: clean
clean:
	@rm -rf $(TMPDIR) $(BUILDDIR)/* $(WEBDIR)/*
	@echo '   Removed temporary files and cleaned out $(BUILDDIR)/ and $(WEBDIR)/'
