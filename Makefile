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
VERSIONFILE := VERSION.txt
WEBDESKFILES := $(DESKTOPDIR)/index.html $(DESKTOPDIR)/pastelet-history.txt $(DESKTOPDIR)/$(VERSIONFILE)
IPHONEHTML := pastelet.html email.html tel.html
HTMLFILES = $(IPHONEHTML) index.html
JSFILES := js/email.js js/loader.js js/paste.js js/tel.js
SRCFILES = $(HTMLFILES) pastelet.manifest $(JSFILES)

# macros/utils
VERSION := $(shell head -1 src/$(VERSIONFILE))
COPYRIGHT := 2008, 2009, 2010, 2011, 2012
HTMLCOMPRESSORJAR := htmlcompressor-1.5.3.jar
HTMLCOMPRESSORPATH := $(shell [ 'cygwin' = "$$OSTYPE" ] &&  echo "`cygpath -w $(COMMONLIB)`\\" || echo "$(COMMONLIB)/")
HTMLCOMPRESSOR := java -jar '$(HTMLCOMPRESSORPATH)$(HTMLCOMPRESSORJAR)'
COMPRESSOPTIONS := -t html -c utf-8 --remove-quotes --remove-intertag-spaces --remove-surrounding-spaces min --compress-js --compress-css
TIDY := $(shell hash tidy-html5 2>/dev/null && echo 'tidy-html5' || (hash tidy 2>/dev/null && echo 'tidy' || exit 1))
JSL := $(shell hash jsl 2>/dev/null && echo 'jsl' || exit 1)
ECHOE := $(shell [ 'cygwin' = "$$OSTYPE" ] && echo -e 'echo -e' || echo 'echo\c')
GROWL := $(shell ! hash growlnotify &>/dev/null && $(ECHOE) 'true\c' || ([ 'darwin11' = "$$OSTYPE" ] && echo "growlnotify -t $(PROJ) -m\c" || ([ 'cygwin' = "$$OSTYPE" ] && echo -e "growlnotify /t:$(PROJ)\c" || $(ECHOE) '\c')) )
REPLACETOKENS = perl -pi -e 's/_MmVERSION_/$(VERSION)/g;s/_MmBUILDDATE_/$(shell date)/g;s/_MmCOPYRIGHT_/$(COPYRIGHT)/g;' $@
GRECHO = $(shell hash grecho &> /dev/null && echo 'grecho' || echo 'printf')
STATFMT := $(shell [ 'cygwin' = $$OSTYPE ] && echo '-c %s' || echo '-f%z' )

.PHONY: deploy $(BUILDDIR) $(WEBDIR) $(DESKTOPDIR) $(IMGDIR) $(TMPDIR) clean

default: mkweb
	@rm -rf $(TMPDIR)
	@$(GRECHO) 'make $(PROJ):' "Done.\n"

mkweb: minify | $(DESKTOPDIR) $(IMGDIR)
	@echo '   Copy files to $(WEBDIR) directory...'
	@cp -fp $(TMPDIR)/pastelet.manifest $(WEBDIR)/___.manifest
	@cp -fp $(TMPDIR)/pastelet.manifest $(WEBDIR)/email.manifest
	@cp -fp $(TMPDIR)/pastelet.manifest $(WEBDIR)/tel.manifest
	@cp -fp $(BUILDDIR)/___ $(BUILDDIR)/email $(BUILDDIR)/tel $(WEBDIR)
	@cp -Rfp $(BUILDDIR)/$(IMGDIR) $(BUILDDIR)/desktop $(SRCDIR)/$(IMGDIR) $(WEBDIR)
	@cp -Rfp $(TMPDIR)/index.html $(SRCDIR)/js $(SRCDIR)/*.txt $(WEBDIR)/$(DESKTOPDIR)
	@cp -fp $(SRCDIR)/mm.css $(WEBDIR)/$(DESKTOPDIR)/css
	@chmod -R 755 $(WEBDIR)

minify: validatehtml | $(BUILDDIR)
	@$(GRECHO) 'make:' "Apply htmlcompressor to files and gzip...\n"
	@cd $(BUILDDIR) && rm -f $(IPHONEHTML)
	@cd $(TMPDIR) && $(HTMLCOMPRESSOR) $(COMPRESSOPTIONS) -o ../$(BUILDDIR) $(IPHONEHTML)
	@(cd $(BUILDDIR) && echo "   $(IPHONEHTML) (size in bytes): $$(stat $(STATFMT) $(IPHONEHTML) | tr '\n' ' ')")
	@(cd $(BUILDDIR) && gzip -f9 $(IPHONEHTML) )
	@mv -f $(BUILDDIR)/pastelet.html.gz $(BUILDDIR)/___
	@mv -f $(BUILDDIR)/email.html.gz $(BUILDDIR)/email
	@mv -f $(BUILDDIR)/tel.html.gz $(BUILDDIR)/tel
	@echo "   [renamed files] ___ email tel (size in bytes): $$(stat $(STATFMT) $(BUILDDIR)/___ $(BUILDDIR)/email $(BUILDDIR)/tel | tr '\n' ' ')"

validatehtml: makehtml
	@$(GRECHO) 'make:' "Validation started with $(TIDY) and $(JSL)\n"
	@(	cd $(TMPDIR); \
		$(foreach html,$(HTMLFILES),\
			echo "$(html)";\
			$(TIDY) -eq "$(html)" || [ $$? -lt 2 ];\
			[ "$(html)" != "index.html" ]\
				&& ($(JSL) -process "$(html)" -nologo -nofilelisting -nosummary && echo ' JavaScript: OK')\
				|| echo ' JavaScript: NOT CHECKED- contains hosted script(s).';\
			echo;\
		) \
	)

makehtml: src2tmp | $(TMPDIR)
	@echo '   Replace tokens...'
	@(cd $(TMPDIR) && perl -p -i -e 'BEGIN{open F,"js/loader.js";@f=<F>}s# src=\"js/loader.js\"\>#\>@f#' $(HTMLFILES) )
	@perl -p -i -e 's/pastelet\.manifest/___.manifest/g;s/(link rel=canonical href=\"http:\/\/mmind.me\/)pastelet/\\1___/g;' $(TMPDIR)/pastelet.html
	@perl -p -i -e 'BEGIN{open F,"$(TMPDIR)/js/paste.js";@f=<F>}s# src=\"$(TMPDIR)/js/paste.js\"\>#\>@f#' $(TMPDIR)/pastelet.html $(TMPDIR)/index.html
	@perl -p -i -e 's/_MmSPECIAL_/Email\/Login/g;s/special_Pastelet/Email\/Login Pastelet/g;' $(TMPDIR)/email.html
	@perl -p -i -e 'BEGIN{open F,"$(TMPDIR)/js/email.js";@f=<F>}s# src=\"$(TMPDIR)/js/email.js\"\>#\>@f#' $(TMPDIR)/email.html
	@perl -p -i -e 's/email.manifest/tel.manifest/g;s/(link rel=canonical href=\"http:\/\/mmind.me\/)email/\\1tel/g;' $(TMPDIR)/tel.html
	@perl -p -i -e 's/_MmSPECIAL_/Telephone Number/g;s/type=\"email/type=\"tel/g;s/email\@abc\.com/8005551212/g;s/special_Pastelet/Telephone Number Pastelet/g;' $(TMPDIR)/tel.html
	@perl -p -i -e 'BEGIN{open F,"$(TMPDIR)/js/tel.js";@f=<F>}s# src=\"$(TMPDIR)/js/email.js\"\>#\>@f#' $(TMPDIR)/tel.html

src2tmp:	| $(TMPDIR) $(IMGDIR)
	@$(GRECHO) 'make:' "Copy files from source to tmp directory...\n"
	@cp -Rfp $(SRCDIR)/*.html $(SRCDIR)/js $(SRCDIR)/mm.css $(SRCDIR)/pastelet.manifest $(TMPDIR)
	@cp -fp $(SRCDIR)/email.html $(TMPDIR)/tel.html
	@(cd $(TMPDIR) && perl -pi -e 's/_MmVERSION_/$(VERSION)/g;s/_MmBUILDDATE_/$(shell date)/g;s/_MmCOPYRIGHT_/$(COPYRIGHT)/g;' $(SRCFILES) )

# deploy
deploy: mkweb
	@$(GRECHO) 'make:' "Deploy to servers.\n"
	@printf "\n\tDeploy to: $$MYSERVER/me\n"
	@rsync -ptuv --executability $(WEBDIR)/*.manifest $(WEBDIR)/___ $(WEBDIR)/email $(WEBDIR)/tel "$$MYUSER@$$MYSERVER:$$MYSERVERHOME/me"
	@rsync -ptu $(WEBDIR)/img/*.* "$$MYUSER@$$MYSERVER:$$MYSERVERHOME/me/img"
	@printf "\n\tDeploy to: $$MYSERVER\n"
	@rsync -ptuv --executability $(WEBDIR)/desktop/*.* "$$MYUSER@$$MYSERVER:$$MYSERVERHOME/iphone"
	@rsync -ptu web/desktop/css web/desktop/js "$$MYUSER@$$MYSERVER:$$MYSERVERHOME/iphone"
	@rsync -ptu $(WEBDIR)/img/*.* "$$MYUSER@$$MYSERVER:$$MYSERVERHOME/iphone/img"
	@echo
	@$(GRECHO) 'make:' "Done. Deployed $(PROJ) to $$MYSERVER/me, $$MYSERVER/iphone\n"

$(BUILDDIR) $(WEBDIR):
	@[ -d "$@" ] || mkdir -m 755 "$@"

$(DESKTOPDIR):	| $(BUILDDIR) $(WEBDIR)
	@[ -d "$(BUILDDIR)/$(DESKTOPDIR)" ] || mkdir -m 744 $(BUILDDIR)/$(DESKTOPDIR)
	@[ -d "$(BUILDDIR)/$(DESKTOPDIR)/css" ] || mkdir -m 744 $(BUILDDIR)/$(DESKTOPDIR)/css
	@[ -d "$(WEBDIR)/$(DESKTOPDIR)" ] || mkdir -m 744 $(WEBDIR)/$(DESKTOPDIR)
	@[ -d "$(WEBDIR)/$(DESKTOPDIR)/css" ] || mkdir -m 744 $(WEBDIR)/$(DESKTOPDIR)/css

$(IMGDIR):	| $(BUILDDIR) $(TMPDIR)
	@cp -Rfp $(SRCDIR)/$(IMGDIR) $(BUILDDIR)
	@cp -Rfp $(SRCDIR)/$(IMGDIR) $(TMPDIR)

$(TMPDIR):
	@[ -d "$(TMPDIR)" ] || mkdir -m 744 "$(TMPDIR)"

clean:
	@rm -rf $(TMPDIR) $(BUILDDIR) $(WEBDIR)
	@echo 'make $(PROJ): Removed temporary files and cleaned out $(BUILDDIR)/ and $(WEBDIR)/'
