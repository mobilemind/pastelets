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
HTMLCOMPRESSOR := java -jar $(COMMONLIB)/htmlcompressor-1.5.2.jar
COMPRESSOPTIONS := -t html -c utf-8 --remove-quotes --remove-intertag-spaces --remove-surrounding-spaces min --compress-js --compress-css
ECHOE := $(shell [[ 'cygwin' == $$OSTYPE ]] && echo -e 'echo -e' || echo 'echo\c')
GROWL := $(shell ! hash growlnotify &>/dev/null && $(ECHOE) 'true\c' || ([[ 'darwin11' == $$OSTYPE ]] && echo "growlnotify -t $(PROJ) -m\c" || ([[ 'cygwin' == $$OSTYPE ]] && echo -e "growlnotify /t:$(PROJ)\c" || $(ECHOE) '\c')) )
REPLACETOKENS = (perl -p -i -e "s/$(MMVERSION)/$(VERSION)/g;" $@; \
		perl -p -i -e "s/$(MMBUILDDATE)/$(BUILDDATE)/g;" $@; \
		perl -p -i -e "s/$(MMCOPYRIGHT)/$(COPYRIGHT)/g;" $@ )


default: minify | $(DESKTOPDIR) $(IMGDIR)
	@(echo '   Copy files to build directory…'; \
		cp -Rfp $(SRCDIR)/img build; \
		cd $(BUILDDIR); \
		mv -f ../$(TMPDIR)/pastelet.manifest ___.manifest; \
		cp -fp ___.manifest email.manifest; \
		cp -fp ___.manifest tel.manifest; \
		mv -f ../$(TMPDIR)/index.html desktop; \
		cp -fp ../$(SRCDIR)/mm.css desktop; \
		cp -Rfp ../$(SRCDIR)/js desktop; \
		cp -fp ../$(SRCDIR)/*.txt desktop; \
		chmod -R 744 .; \
		rm -rf ../$(TMPDIR) \
	)
	@$(ECHOE) "Done.\n"; $(GROWL) "Done."

# default: $(MANIFESTS) $(COMPRESSEDFILES)
# default: $(WEBIPHONE) $(WEBDESK) $(BUILDDIR) $(DESKTOPDIR) $(WEBDIR) $(IMGDIR)
# 	@(chmod -R 744 $(WEBDIR); \
# 		$(GROWL) "Done. See $(PROJ)/$(WEBDIR) directory."; echo; \
# 		echo "Done. See $(PROJ)/$(WEBDIR) directory"; echo )

# copy manifest to $(BUILDDIR) and replace tokens
# %.manifest: $(SRCDIR)/%.manifest $(VERSIONTXT) | $(BUILDDIR)
# 	@(echo; echo $@; \
# 		cp -fp $(SRCDIR)/$@ $(BUILDDIR); \
# 		cd $(BUILDDIR); \
# 		$(REPLACETOKENS) )

# $(DESKTOPDIR)/%.txt: | $(DESKTOPDIR)
#	cp something $@

# Example of a Conditional
#
# The following example of a conditional tells make to use one set of libraries if the CC variable is ‘gcc’, and a different set of libraries otherwise. It works by controlling which of two recipe lines will be used for the rule. The result is that ‘CC=gcc’ as an argument to make changes not only which compiler is used but also which libraries are linked.
#
#      libs_for_gcc = -lgnu
#      normal_libs =
#
#      foo: $(objects)
#      ifeq ($(CC),gcc)
#              $(CC) -o foo $(objects) $(libs_for_gcc)
#      else
#              $(CC) -o foo $(objects) $(normal_libs)
#      endif


# run JSLINT then prepend with 'javascript:' and encodeURI (preserving Firefox '%s' token)
# $(WEB)/%.js: $(BUILD)/%.js | $(BUILD) $(WEB)
# 	@echo "   $@"
# 	@$(JSLINT) -process $< $(JSLINTOPTIONS) > /dev/null ; [ $$? -lt 2 ] || ( \
# 		echo "*** ERROR: $^"; $(JSLINT) -process $< $(JSLINTOPTIONS); \
# 		exit 1)
# 	@[[ "$(@F)" == "fyi-firefox.com.js" ]] && ( \
# 		perl -pe "s/\%s\"\)/_PERCENT_S_\"\)/g;" < $^ > $^.tmp; \
# 		$(NODEJS) $(MAKEBOOKMARK) $^.tmp | perl -pe "s/_PERCENT_S_/\%s/g;" > $@ && \
# 		rm -f $^.tmp ) \
# 	|| $(NODEJS) $(MAKEBOOKMARK) $^ > $@



minify: validate | $(BUILDDIR)
	@$(GROWL) "Compression started"
	@(echo '   Apply HTMLCOMPRESSOR to files…'; \
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

html: src2tmp | $(TMPDIR)
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

src2tmp:	| $(TMPDIR) $(IMGDIR)
	@$(GROWL) "Make started"
	@(echo '   Copy pastelet HTML and manifest from source to tmp working directory…'; \
		cp -fp $(SRCDIR)/*.html $(TMPDIR); \
		cp -fp $(SRCDIR)/email.html $(TMPDIR)/tel.html; \
		cp -Rfp $(SRCDIR)/js $(TMPDIR); \
		cp -fp $(SRCDIR)/mm.css $(TMPDIR); \
		cp -fp $(SRCDIR)/pastelet.manifest $(TMPDIR); \
		echo '   Setting VERSION and build date…' ;\
		cd $(TMPDIR); \
		perl -p -i -e "s/$(MMVERSION)/$(VERSION)/g;" $(SRCFILES); \
		perl -p -i -e "s/$(MMBUILDDATE)/$(BUILDDATE)/g;" $(SRCFILES); \
		perl -p -i -e "s/$(MMCOPYRIGHT)/$(COPYRIGHT)/g;" $(SRCFILES) \
	)

.PHONY: $(BUILDDIR)
$(BUILDDIR):
	@[[ -d $(BUILDDIR) ]] || mkdir -m 744 $(BUILDDIR)

.PHONY: $(DESKTOPDIR)
$(DESKTOPDIR):	| $(BUILDDIR)
	@[[ -d $(BUILDDIR)/$(DESKTOPDIR) ]] || mkdir -m 744 $(BUILDDIR)/$(DESKTOPDIR)

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
	@echo '   Removing temporary files and cleaning out build directory…'
	@rm -rf $(TMPDIR) $(BUILDDIR)/*
