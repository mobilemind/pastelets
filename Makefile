#!/usr/bin/make -f

product_copyright = '2008-2011'
iphonehtml = pastelet.html email.html tel.html
htmlfiles = $(iphonehtml) index.html 
srcfiles = $(htmlfiles) pastelet.manifest
htmlcompressor = java -jar ../lib/htmlcompressor-1.5.2.jar
compressoroptions = -t html -c utf-8 --remove-quotes --remove-intertag-spaces  --remove-surrounding-spaces min --compress-js --compress-css

default: clean build

src2tmp:
	@echo "   Copy pastelet HTML and manifest from source to tmp working directory…"
	@[[ -d tmp ]] || mkdir -m 744 tmp
	@(cp -fp src/*.html tmp; cp -fp src/email.html tmp/tel.html; cp -fp src/pastelet.manifest tmp )
	
replace_common_tokens: src2tmp
	@echo '   Replace common tokens across sub-projects…'
	@(cd tmp; perl -p -i -e "s/\@PRODUCT.VERSION\@/`head -1 ../src/VERSION`/g;" $(srcfiles) )
	@(cd tmp; perl -p -i -e "s/\@PRODUCT.DATE\@/`date`/g;" $(srcfiles) )
	@(cd tmp; perl -p -i -e "s/\@PRODUCT.COPYRIGHT\@/$(product_copyright)/g;" $(srcfiles) )
	@(cd tmp; perl -p -i -e 'BEGIN{open F,"../src/js/loader.js";@f=<F>}s# src=\"js/loader.js\"\>#\>@f#' $(htmlfiles) )
	
replace_generic_tokens: src2tmp replace_common_tokens
	@echo '   Replace tokens for GENERIC pastelet…'
	@(cd tmp; perl -p -i -e "s/pastelet\.manifest/___.manifest/g;" pastelet.html )
	@(cd tmp; perl -p -i -e "s/(link rel=canonical href=\"http:\/\/mmmind.me\/)pastelet/\\1___/g;" pastelet.html )
	@(cd tmp; perl -p -i -e 'BEGIN{open F,"../src/js/paste.js";@f=<F>}s# src=\"js/paste.js\"\>#\>@f#' pastelet.html index.html )

replace_email_tokens: src2tmp replace_common_tokens
	@echo '   Replace tokens from templates for EMAIL pastelet…'
	@(cd tmp; perl -p -i -e "s/\@SPECIAL\@/Email\/Login/g;" email.html )
	@(cd tmp; perl -p -i -e 'BEGIN{open F,"../src/js/email.js";@f=<F>}s# src=\"js/email.js\"\>#\>@f#' email.html )
	@(cd tmp; perl -p -i -e "s/special_Pastelet/Email\/Login Pastelet/g;" email.html )

replace_tel_tokens: src2tmp replace_common_tokens
	@echo '   Replace tokens from templates for TEL pastelet…'
	@(cd tmp; perl -p -i -e "s/email.manifest/tel.manifest/g;" tel.html )
	@(cd tmp; perl -p -i -e "s/(link rel=canonical href=\"http:\/\/mmmind.me\/)email/\\1tel/g;" tel.html )
	@(cd tmp; perl -p -i -e "s/(\@SPECIAL\@)/Telephone Number/g;" tel.html )
	@(cd tmp; perl -p -i -e "s/type=\"email/type=\"tel/g;" tel.html )
	@(cd tmp; perl -p -i -e "s/email\@abc\.com/8005551212/g;" tel.html )
	@(cd tmp; perl -p -i -e 'BEGIN{open F,"../src/js/tel.js";@f=<F>}s# src=\"js/email.js\"\>#\>@f#' tel.html )
	@(cd tmp; perl -p -i -e "s/special_Pastelet/Telephone Number Pastelet/g;" tel.html )

make_html: replace_generic_tokens replace_email_tokens replace_tel_tokens

minify_html: make_html
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
# 	@(cd tmp; rm -f $(iphonehtml) )
	@echo 'Done.' 

clean:
	@echo '   Removing temporary files and cleaning out build directory…'
	@(rm -rf tmp; [[ -d build ]] && rm -rf build/* ||  true)
