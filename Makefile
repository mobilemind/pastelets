#!/usr/bin/make -f

iphoneapp = iphone
product_copyright = '2008-2011'
product_date = `date`
product_name = pastelet
webapp = web
webappdir = iphone
typeemail = 'type="email"'
typetel = 'type="tel"'
typetext = 'type="text"'
iphonehtml = $(product_name).html email.html tel.html
htmlfiles = $(iphonehtml) index.html 
manifestfiles = $(product_name).manifest email.manifest tel.manifest
srcfiles = $(htmlfiles) $(product_name).manifest
htmlcompressor = java -jar ../lib/htmlcompressor-1.5.2.jar
compressoroptions = -t html -c utf-8 --remove-quotes --remove-intertag-spaces  --remove-surrounding-spaces min --compress-js --compress-css


default: clean build

src2tmp:
	@echo "   Create $(product_name) HTML and manifest from $(iphoneapp).html, $(iphoneapp).manifest and $(webapp).html"
	@[[ -d tmp ]] || mkdir -m 744 tmp
	@(cp -f src/$(webapp).html tmp/index.html )
	@(cp -f src/$(iphoneapp).html tmp/$(product_name).html )
	@(cp -f src/$(iphoneapp).manifest tmp/$(product_name).manifest )
	@(cp -f src/special.html tmp/email.html )
	@(cp -f src/special.html tmp/tel.html )
	
replace_common_tokens: src2tmp
	@echo '   Replace common tokens across sub-projects…'
	@(cd tmp; perl -p -i -e "s/(\@PRODUCT.VERSION\@)/`head -1 ../src/VERSION`/g;" $(srcfiles) )
	@(cd tmp; perl -p -i -e "s/(\@PRODUCT.DATE\@)/`date`/g;" $(srcfiles) )
	@(cd tmp; perl -p -i -e "s/(\@PRODUCT.COPYRIGHT\@)/$(product_copyright)/g;" $(srcfiles) )
	@(cd tmp; perl -p -i -e "s/$(iphoneapp)\.manifest/$(product_name).manifest/g;" $(htmlfiles) )
	@(cd tmp; perl -p -i -e 'BEGIN{open F,"../src/js/loader.js";@f=<F>}s#\@LOADERJS\@#@f#' $(htmlfiles) )
	
replace_generic_tokens: src2tmp replace_common_tokens
	@echo '   Replace tokens for GENERIC pastelet…'
	@(cd tmp; perl -p -i -e "s/pastelet\.manifest/___.manifest/g;" $(iphonehtml) )
	@(cd tmp; perl -p -i -e 'BEGIN{open F,"../src/js/paste.js";@f=<F>}s#\@PASTEJS\@#@f#' $(product_name).html index.html )

replace_email_tokens: src2tmp replace_common_tokens
	@echo '   Replace tokens from templates for EMAIL pastelet'
	@(cd tmp; perl -p -i -e "s/(\@SPECIAL\@)/Email\/Login/g;" email.html )
	@(cd tmp; perl -p -i -e "s/$(typetext)/$(typeemail)/g;" email.html )
	@(cd tmp; perl -p -i -e "s/(\@PLACEHOLDER\@)/email\@abc.com or userID/g;" email.html )
	@(cd tmp; perl -p -i -e 'BEGIN{open F,"../src/js/email.js";@f=<F>}s#\@PASTEJS\@#@f#' email.html )
	@(cd tmp; perl -p -i -e "s/(special_Pastelet)/Email\/Login Pastelet/g;" email.html )

replace_tel_tokens: src2tmp replace_common_tokens
	@echo '   Replace tokens from templates for TEL pastelet'
	@(cd tmp; perl -p -i -e "s/(\@SPECIAL\@)/Telephone Number/g;" tel.html )
	@(cd tmp; perl -p -i -e "s/$(typetext)/$(typetel)/g;" tel.html )
	@(cd tmp; perl -p -i -e "s/(\@PLACEHOLDER\@)/8005551212/g;" tel.html )
	@(cd tmp; perl -p -i -e 'BEGIN{open F,"../src/js/tel.js";@f=<F>}s#\@PASTEJS\@#@f#' tel.html )
	@(cd tmp; perl -p -i -e "s/(special_Pastelet)/Telephone Number Pastelet/g;" tel.html )

make_html: replace_generic_tokens replace_email_tokens replace_tel_tokens

minify_html: make_html
	@echo '   Apply htmlcompressor to files…'
	@(rm -f build/$(iphonehtml); cd tmp; $(htmlcompressor) $(compressoroptions) -o ../build $(iphonehtml) )

tmp2build: minify_html
	@echo '   Copy files to build directory…'
	@(cd build; mv -f $(product_name).html ___; mv -f email.html email; mv -f tel.html tel )
	@(mv -f tmp/index.html build; mv -f tmp/$(product_name).manifest build/___.manifest )
	@cp -f src/pastelet-history.txt build
	@(cp -Rf src/css build; cp -Rf src/img build; cp -Rf src/iphone build; cp -Rf src/js build )

build: tmp2build
	@(cd tmp; rm -f $(iphonehtml) )
	@echo 'Done.'

clean:
	@echo '   Removing temporary files and cleaning out build directory…'
	@(rm -rf tmp; cd build; rm -rf *)
