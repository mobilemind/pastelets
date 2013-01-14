# Pastelets
Pastelets are web pages that generate Javascript bookmarklets primarily intended for Mobile Safari on iOS (iPhone/iPad/iPod Touch).
Each generated bookmarklet pastes its specified string into a text field.

The purpose is to make it quick and easy to complete web forms on iOS with Mobile Safari, without reliance on autocomplete.

The bookmarklet generators are available as:

+ **build/web/iphone/index.html** - desktop version that pastes into 1st field (or asks successively)
+ <b>build/iphone/\_\_\_</b> - iOS optimized (with brief name) that pastes into 1st field (or asks successively)
+ **build/iphone/email** - iOS optimized to paste an email into the first Email/Login field on a page.
+ **build/iphone/tel** - iOS optimized to paste a phone number into the first telephone field on a page

## Install
Copy the appropriate bookmarklet generator(s) to a web server.

## Usage
Each page includes usage instructions. Visit the appropriate bookmarklet generator page.

The easiest way to use them is visiting the hosted versions

+ Web/Desktop version [http://mmind.me/iphone/](http://mmind.me/iphone/ "Pastelet Maker - Desktop")
+ iOS General purpose version [http://mmind.me/\_\_\_](http://mmind.me/___ "Pastelet Maker - iOS")
+ iOS Email\/Login optimized version [http://mmind.me/email](http://mmind.me/email "Email/Login Pastelet Maker - iOS")
+ iOS Telephone field optimized version [http://mmind.me/tel](http://mmind.me/tel "Telephone Pastelet Maker - iOS")

## Requirements
Web browser or Mobile Safari from iOS 3.3 or higher

## License
MIT License - <http://www.opensource.org/licenses/mit-license.php>

Pastelets
Copyright (c) 2008-2013 Tom King  <mobilemind@pobox.com>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## Repository Notes
The `/build` directory has the final, optimized HTML/JavaScript and their shared HTML5 manifest file.

## Deployment Notes
For deployment "pastelets" likely requires web server configuration (e.g., `.htaccess` on Apache servers).
Required configuration items include:

1. The MIME type for the HTML 5 manifest file. For Apache that looks like:
````apache
AddType text/cache-manifest cache manifest
````

2. With files named '\_\_\_' or 'email' or 'tel':
    a) Force to be MIME type `text/html`
    b) Set encoding to zip
    c) Set cache options to enable caching for a few minutes at least
For Apache that looks like:
````apache
<FilesMatch "^(___|email|tel)$">
ForceType "text/html; charset=utf-8"
Header set Content-Encoding "gzip"
Header set Cache-Control "max-age=361, public, proxy-revalidate"
</FilesMatch>
````

### Tips
1. The file name '\_\_\_' is used to clarify editing of the bookmarklet and serve as a short filename
2. Ideally, the files will be in a subdirectory of the web server root with a short name.

Finally, note that the app will work fine with the manifest directive removed, and/or the HTML file renamed.
If you rename the HTML file, the instructions in the HTML should probably be changed.

## Build Notes
The make file requires the Java-based htmlcompressor and yuicompressor included in the lib
folder. It also requires the bash shell, `make`, `perl`, `tidy` (or tidy-html5), `jsl`,
`gzip` and optionally uses `growlnotify`.

The W3C tidy-html5 is available here: <http://w3c.github.com/tidy-html5/>

The project has been built successfully on Mac OS X 10.7 and Windows 7 (w/ cygwin 1.79)
with GNU Make 3.8, perl 5, tidy (tidy-html5), JavaScript Lint 0.3.0, and growlnotify 1.3.
