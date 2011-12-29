#!/usr/bin/make -f

projname := pastelets
iphonehtml := pastelet.html email.html tel.html
htmlfiles = $(iphonehtml) index.html
jsfiles = js/email.js js/loader.js js/paste.js js/tel.js
srcfiles = $(htmlfiles) pastelet.manifest $(jsfiles)
htmlcompressor := java -jar ../lib/htmlcompressor-1.5.2.jar
compressoroptions := -t html -c utf-8 --remove-quotes --remove-intertag-spaces --remove-surrounding-spaces min --compress-js --compress-css
growl := $(shell ! hash growlnotify &>- && echo 'true\c' || (echo 'growlnotify \c' && [[ 'darwin11' == $$OSTYPE ]] && echo "-t $(projname) -m\c" || ([[ 'cygwin' == $$OSTYPE ]] && echo "/t:$(projname)\c" || echo '\c')) )
version := $(shell head -1 src/VERSION)
builddate := $(shell date)
copyright := 2008-2011


default: clean build

src2tmp:
	@$(growl) "Make started"
	@echo '   Copy pastelet HTML and manifest from source to tmp working directory…'
	@[[ -d tmp ]] || mkdir -m 744 tmp
	@(cp -fp src/*.html tmp; cp -fp src/email.html tmp/tel.html; cp -Rfp src/js tmp; cp -fp src/mm.css tmp; cp -fp src/pastelet.manifest tmp)
	@echo '   Setting version and build date…'
	@(cd tmp; perl -p -i -e "s/\@VERSION\@/$(version)/g;" $(srcfiles) )
	@(cd tmp; perl -p -i -e "s/\@BUILDDATE\@/$(builddate)/g;" $(srcfiles) )
	@(cd tmp; perl -p -i -e "s/\@COPYRIGHT\@/$(copyright)/g;" $(srcfiles) )

replace_common_tokens: src2tmp
	@$(growl) "Replaces started"
	@echo '   Replace common tokens across sub-projects…'
	@(cd tmp; perl -p -i -e 'BEGIN{open F,"js/loader.js";@f=<F>}s# src=\"js/loader.js\"\>#\>@f#' $(htmlfiles) )

replace_generic_tokens: src2tmp replace_common_tokens
	@echo '   Replace tokens for GENERIC pastelet…'
	@(cd tmp; perl -p -i -e "s/pastelet\.manifest/___.manifest/g;" pastelet.html )
	@(cd tmp; perl -p -i -e "s/(link rel=canonical href=\"http:\/\/mmind.me\/)pastelet/\\1___/g;" pastelet.html )
	@(cd tmp; perl -p -i -e 'BEGIN{open F,"js/paste.js";@f=<F>}s# src=\"js/paste.js\"\>#\>@f#' pastelet.html index.html )

replace_email_tokens: src2tmp replace_common_tokens
	@echo '   Replace tokens from templates for EMAIL pastelet…'
	@(cd tmp; perl -p -i -e "s/\@SPECIAL\@/Email\/Login/g;" email.html )
	@(cd tmp; perl -p -i -e 'BEGIN{open F,"js/email.js";@f=<F>}s# src=\"js/email.js\"\>#\>@f#' email.html )
	@(cd tmp; perl -p -i -e "s/special_Pastelet/Email\/Login Pastelet/g;" email.html )

replace_tel_tokens: src2tmp replace_common_tokens
	@echo '   Replace tokens from templates for TEL pastelet…'
	@(cd tmp; perl -p -i -e "s/email.manifest/tel.manifest/g;" tel.html )
	@(cd tmp; perl -p -i -e "s/(link rel=canonical href=\"http:\/\/mmind.me\/)email/\\1tel/g;" tel.html )
	@(cd tmp; perl -p -i -e "s/(\@SPECIAL\@)/Telephone Number/g;" tel.html )
	@(cd tmp; perl -p -i -e "s/type=\"email/type=\"tel/g;" tel.html )
	@(cd tmp; perl -p -i -e "s/email\@abc\.com/8005551212/g;" tel.html )
	@(cd tmp; perl -p -i -e 'BEGIN{open F,"js/tel.js";@f=<F>}s# src=\"js/email.js\"\>#\>@f#' tel.html )
	@(cd tmp; perl -p -i -e "s/special_Pastelet/Telephone Number Pastelet/g;" tel.html )

make_html: replace_generic_tokens replace_email_tokens replace_tel_tokens
	@$(growl) "Validation started"
	@echo "   Validating HTML…\n"
	@(hash tidy && cd tmp && ($(foreach html,$(htmlfiles), echo "$(html)"; tidy -eq $(html); [[ $$? -lt 2 ]] && echo;)))
	@echo "   Validating JavaScript…\n"
	@(hash jsl && cd tmp && ($(foreach html,$(iphonehtml), echo "$(html)"; jsl -process $(html) -nologo -nofilelisting -nosummary && echo ' OK';)) && echo)

minify_html: make_html
	@$(growl) "Compression started"
	@echo '   Apply htmlcompressor to files…'
	@[[ -d build ]] || mkdir -m 744 build
	@(rm -f build/$(iphonehtml); cd tmp && $(htmlcompressor) $(compressoroptions) -o ../build $(iphonehtml) )
	@echo '   gzip minified files…'
	@(cd build && gzip -f9 $(iphonehtml) && mv -f pastelet.html.gz ___; mv -f email.html.gz email; mv -f tel.html.gz tel)

tmp2build: minify_html
	@echo '   Copy files to build directory…'
	@cp -Rfp src/img build
	@(cd build && mv -f ../tmp/pastelet.manifest ___.manifest && cp -fp ___.manifest email.manifest && cp -fp ___.manifest tel.manifest )
	@[[ -d build/desktop ]] || mkdir -m 744 build/desktop
	@(mv -f tmp/index.html build/desktop; cp -Rfp src/css build/desktop; cp -Rfp src/js build/desktop; cp -fp src/*.txt build/desktop )
	@chmod -R 744 build

build: tmp2build
	@(cd tmp; rm -f $(iphonehtml) )
	@echo "Done.\n"
	@$(growl) "Done."

clean:
	@echo '   Removing temporary files and cleaning out build directory…'
	@(rm -rf tmp; [[ -d build ]] && rm -rf build/* ||  true)
