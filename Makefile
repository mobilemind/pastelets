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
TIDY := $(shell hash tidy-html5 2>/dev/null && echo 'tidy-html5' || (hash tidy 2>/dev/null && echo 'tidy' || exit 1))
JSL := $(shell hash jsl 2>/dev/null && echo 'jsl' || exit 1)
ECHOE := $(shell [[ 'cygwin' == $$OSTYPE ]] && echo -e 'echo -e' || echo 'echo\c')
GROWL := $(shell ! hash growlnotify &>/dev/null && $(ECHOE) 'true\c' || ([[ 'darwin11' == $$OSTYPE ]] && echo "growlnotify -t $(PROJ) -m\c" || ([[ 'cygwin' == $$OSTYPE ]] && echo -e "growlnotify /t:$(PROJ)\c" || $(ECHOE) '\c')) )
REPLACETOKENS = (perl -p -i -e 's/$(MMVERSION)/$(VERSION)/g;' $@; \
		perl -p -i -e 's/$(MMBUILDDATE)/$(BUILDDATE)/g;' $@; \
		perl -p -i -e 's/$(MMCOPYRIGHT)/$(COPYRIGHT)/g;' $@ )
GRECHO = $(shell hash grecho &> /dev/null && echo 'grecho' || echo 'printf')


default: mkweb
	@rm -rf $(TMPDIR)
	@$(GRECHO) 'make:' "Done.\n"

mkweb: minify | $(DESKTOPDIR) $(IMGDIR)
	@(echo '   Copy files to $(WEBDIR) directory...'; \
		cp -fp $(TMPDIR)/pastelet.manifest $(WEBDIR)/___.manifest; \
		cp -fp $(TMPDIR)/pastelet.manifest $(WEBDIR)/email.manifest; \
		cp -fp $(TMPDIR)/pastelet.manifest $(WEBDIR)/tel.manifest; \
		cp -fp $(BUILDDIR)/___ $(WEBDIR); \
		cp -fp $(BUILDDIR)/email $(WEBDIR); \
		cp -fp $(BUILDDIR)/tel $(WEBDIR); \
		cp -Rfp $(BUILDDIR)/$(IMGDIR) $(WEBDIR); \
		cp -Rfp $(BUILDDIR)/desktop $(WEBDIR); \
		cp -Rfp $(SRCDIR)/$(IMGDIR) $(WEBDIR); \
		cp -fp $(TMPDIR)/index.html $(WEBDIR)/$(DESKTOPDIR); \
		cp -fp $(SRCDIR)/mm.css $(WEBDIR)/$(DESKTOPDIR)/css; \
		cp -Rfp $(SRCDIR)/js $(WEBDIR)/$(DESKTOPDIR); \
		cp -fp $(SRCDIR)/*.txt $(WEBDIR)/$(DESKTOPDIR); \
		chmod -R 755 $(WEBDIR) \
	)


minify: validatehtml | $(BUILDDIR)
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
	@($(GRECHO) 'make:' "Validation started with $(TIDY) and $(JSL)"; \
		cd $(TMPDIR); \
		$(foreach html,$(HTMLFILES), \
			echo "$(html)"; \
			$(TIDY) -eq $(html); [[ $$? -lt 2 ]] && true; \
			[[ $(html) != "index.html" ]] && ( \
				$(JSL) -process $(html) -nologo -nofilelisting -nosummary && echo ' JavaScript: OK') \
			|| echo ' JavaScript: NOT CHECKED- contains hosted script(s).'; \
			echo ; \
		) \
	)

makehtml: src2tmp | $(TMPDIR)
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
	@($(GRECHO) 'make:' "Copy files from source to tmp directory..."; \
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

# deploy
.PHONY: deploy
deploy: mkweb
	@printf "\n\tDeploy to: $$MYSERVER/me\n"
	@scp -p $(WEBDIR)/*.manifest $(WEBDIR)/___ $(WEBDIR)/email $(WEBDIR)/tel \
		"$$MYUSER@$$MYSERVER:$$MYSERVERHOME/me"
	@scp -p $(WEBDIR)/img/*.* "$$MYUSER@$$MYSERVER:$$MYSERVERHOME/me/img"
	@printf "\n\tDeploy to: $$MYSERVER\n"
	@scp -p $(WEBDIR)/desktop/*.* "$$MYUSER@$$MYSERVER:$$MYSERVERHOME/iphone"
	@scp -pr web/desktop/css web/desktop/js "$$MYUSER@$$MYSERVER:$$MYSERVERHOME/iphone"
	@scp -p $(WEBDIR)/img/*.* "$$MYUSER@$$MYSERVER:$$MYSERVERHOME/iphone/img"
	@echo
	@$(GRECHO) 'make:' "Done. Deployed $(PROJ) to $$MYSERVER/me, $$MYSERVER/iphone\n"

.PHONY: $(BUILDDIR)
$(BUILDDIR):
	@[[ -d $(BUILDDIR) ]] || mkdir -m 755 $(BUILDDIR)

.PHONY: $(DESKTOPDIR)
$(DESKTOPDIR):	| $(BUILDDIR) $(WEBDIR)
	@[[ -d $(BUILDDIR)/$(DESKTOPDIR) ]] || mkdir -m 744 $(BUILDDIR)/$(DESKTOPDIR)
	@[[ -d $(BUILDDIR)/$(DESKTOPDIR)/css ]] || mkdir -m 744 $(BUILDDIR)/$(DESKTOPDIR)/css
	@[[ -d $(WEBDIR)/$(DESKTOPDIR) ]] || mkdir -m 744 $(WEBDIR)/$(DESKTOPDIR)
	@[[ -d $(WEBDIR)/$(DESKTOPDIR)/css ]] || mkdir -m 744 $(WEBDIR)/$(DESKTOPDIR)/css

.PHONY: $(WEBDIR)
$(WEBDIR):
	@[[ -d $(WEBDIR) ]] || mkdir -m 755 $(WEBDIR)

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
