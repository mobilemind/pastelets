#!/usr/bin/make -f

##
# PASTELETS PROJECT
##
PROJ := pastelets
# directories/paths
SRCDIR := src
BUILDDIR := build
TMPDIR := tmp
COMMONLIB := $$HOME/common/lib
WEBDIR := web
IMGDIR := img
VPATH := $(WEBDIR):$(BUILDDIR)
# files
IPHONEHTML := pastelet.html email.html tel.html
HTMLFILES = $(IPHONEHTML) index.html
JSFILES := js/email.js js/loader.js js/paste.js js/tel.js
SRCFILES = $(HTMLFILES) pastelet.manifest $(JSFILES)
VERSIONTXT := $(SRCDIR)/VERSION.txt
# macros/utils
MMBUILDDATE := _MmBUILDDATE_
BUILDDATE := $(shell date)
MMVERSION := _MmVERSION_
VERSION := $(shell head -1 $(VERSIONTXT))
MMCOPYRIGHT := _MmCOPYRIGHT_
COPYRIGHT := 2008, 2009, 2010, 2011, 2012
MMSPECIAL := _MmSPECIAL_
HTMLCOMPRESSOR := java -jar $(COMMONLIB)/htmlcompressor-1.5.2.jar
COMPRESSOPTIONS := -t html -c utf-8 --remove-quotes --remove-intertag-spaces --remove-surrounding-spaces min --compress-js --compress-css
ECHOE := $(shell [[ 'cygwin' == $$OSTYPE ]] && echo -e 'echo -e' || echo 'echo\c')
GROWL := $(shell ! hash growlnotify &>/dev/null && $(ECHOE) 'true\c' || ([[ 'darwin11' == $$OSTYPE ]] && echo "growlnotify -t $(PROJ) -m\c" || ([[ 'cygwin' == $$OSTYPE ]] && echo -e "growlnotify /t:$(PROJ)\c" || $(ECHOE) '\c')) )


build: minify
	@(echo '   Copy files to build directory…'; \
		cp -Rfp $(SRCDIR)/img build; \
		cd $(BUILDDIR); \
		mv -f ../$(TMPDIR)/pastelet.manifest ___.manifest; \
		cp -fp ___.manifest email.manifest; \
		cp -fp ___.manifest tel.manifest; \
		[[ -d desktop ]] || mkdir -m 744 desktop; \
		mv -f ../$(TMPDIR)/index.html desktop; \
		cp -fp ../$(SRCDIR)/mm.css desktop; \
		cp -Rfp ../$(SRCDIR)/js desktop; \
		cp -fp ../$(SRCDIR)/*.txt desktop; \
		chmod -R 744 ../$(BUILDDIR); \
		rm -rf ../$(TMPDIR) \
	)
	@$(ECHOE) "Done.\n"; $(GROWL) "Done."

minify: validate
	@$(GROWL) "Compression started"
	@(echo '   Apply HTMLCOMPRESSOR to files…'; \
		[[ -d $(BUILDDIR) ]] || mkdir -m 744 $(BUILDDIR); \
		rm -f $(BUILDDIR)/$(IPHONEHTML); \
		cd $(TMPDIR); \
		$(HTMLCOMPRESSOR) $(COMPRESSOPTIONS) -o ../build $(IPHONEHTML) \
	)
	@(echo '   gzip minified files…'; \
		cd $(BUILDDIR); \
		gzip -f9 $(IPHONEHTML); \
		mv -f pastelet.html.gz ___; \
		mv -f email.html.gz email; \
		mv -f tel.html.gz tel \
	)

validate: html
	@$(GROWL) "Validation started";
	@($(ECHOE) "   Validating HTML…\n"; \
		hash tidy && cd $(TMPDIR) && ($(foreach html,$(HTMLFILES), \
			echo "$(html)"; \
			tidy -eq $(html); [[ $$? -lt 2 ]] && echo;)) \
	)
	@($(ECHOE) "   Validating JavaScript…\n"; \
		hash jsl && cd $(TMPDIR) && ($(foreach html,$(IPHONEHTML), \
			echo "$(html)"; \
			jsl -process $(html) -nologo -nofilelisting -nosummary && echo ' OK';)) && echo \
	)

html: src2tmp
# build src to tmp
	@$(GROWL) "Replaces started"
	@(echo '   Replace common tokens across sub-projects…'; \
		cd $(TMPDIR); \
		perl -p -i -e 'BEGIN{open F,"js/loader.js";@f=<F>}s# src=\"js/loader.js\"\>#\>@f#' $(HTMLFILES) ;\
		echo '   Replace tokens for GENERIC pastelet…'; \
		perl -p -i -e "s/pastelet\.manifest/___.manifest/g;" pastelet.html; \
		perl -p -i -e "s/(link rel=canonical href=\"http:\/\/mmind.me\/)pastelet/\\1___/g;" pastelet.html; \
		perl -p -i -e 'BEGIN{open F,"js/paste.js";@f=<F>}s# src=\"js/paste.js\"\>#\>@f#' pastelet.html index.html \
	)
	@(echo '   Replace tokens from templates for EMAIL pastelet…'; \
		cd $(TMPDIR); \
		perl -p -i -e "s/$(MMSPECIAL)/Email\/Login/g;" email.html; \
		perl -p -i -e 'BEGIN{open F,"js/email.js";@f=<F>}s# src=\"js/email.js\"\>#\>@f#' email.html; \
		perl -p -i -e "s/special_Pastelet/Email\/Login Pastelet/g;" email.html \
	)
	@(echo '   Replace tokens from templates for TEL pastelet…'; \
		cd $(TMPDIR); \
		perl -p -i -e "s/email.manifest/tel.manifest/g;" tel.html; \
		perl -p -i -e "s/(link rel=canonical href=\"http:\/\/mmind.me\/)email/\\1tel/g;" tel.html; \
		perl -p -i -e "s/$(MMSPECIAL)/Telephone Number/g;" tel.html; \
		perl -p -i -e "s/type=\"email/type=\"tel/g;" tel.html; \
		perl -p -i -e "s/email\@abc\.com/8005551212/g;" tel.html; \
		perl -p -i -e 'BEGIN{open F,"js/tel.js";@f=<F>}s# src=\"js/email.js\"\>#\>@f#' tel.html; \
		perl -p -i -e "s/special_Pastelet/Telephone Number Pastelet/g;" tel.html \
	)

src2tmp:
	@$(GROWL) "Make started"
	(echo '   Copy pastelet HTML and manifest from source to tmp working directory…'; \
		[[ -d $(TMPDIR) ]] || mkdir -m 744 $(TMPDIR); \
		cp -fp $(SRCDIR)/*.html $(TMPDIR); \
		cp -fp $(SRCDIR)/email.html $(TMPDIR)/tel.html; \
		cp -Rfp $(SRCDIR)/js $(TMPDIR); \
		cp -Rfp $(SRCDIR)/img $(TMPDIR); \
		cp -fp $(SRCDIR)/mm.css $(TMPDIR); \
		cp -fp $(SRCDIR)/pastelet.manifest $(TMPDIR); \
		echo '   Setting VERSION and build date…' ;\
		cd $(TMPDIR); \
		perl -p -i -e "s/$(MMVERSION)/$(VERSION)/g;" $(SRCFILES); \
		perl -p -i -e "s/$(MMBUILDDATE)/$(BUILDDATE)/g;" $(SRCFILES); \
		perl -p -i -e "s/$(MMCOPYRIGHT)/$(COPYRIGHT)/g;" $(SRCFILES) \
	)

.PHONY: clean
clean:
	@echo '   Removing temporary files and cleaning out build directory…'
	@rm -rf $(TMPDIR) $(BUILDDIR)/*
