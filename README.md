# Pastelets

Pastelets are web pages that generate Javascript bookmarklets primarily
intended for Mobile Safari on iOS (iPhone/iPad/iPod Touch). Each generated
bookmarklet pastes its specified string into a text field.

The purpose is to make it quick and easy to complete web forms on iOS with
Mobile Safari, without reliance on autocomplete.

The bookmarklet generators are available as:

+ `web/desktop/index.html` - desktop version that pastes into 1st field
  (or asks successively).
+ `web/___` - iOS optimized (with brief name) that pastes into
  1st field (or asks successively). NOTE: This file is `gzip` compressed.
+ `web/email` - iOS optimized to paste an email into the first
  Email/Login field on a page. NOTE: This file is `gzip` compressed.
+ `web/tel` - iOS optimized to paste a phone number into the first
  telephone field on a page NOTE: This file is `gzip` compressed.

## Install

Copy the appropriate bookmarklet generator(s) to a web server.

## Usage

Each page includes usage instructions. Visit the appropriate bookmarklet
generator page.

The easiest way to use them is visiting the hosted versions

+ Web/Desktop version
  [http://mmind.me/iphone/](http://mmind.me/iphone/ "Pastelet Maker - Desktop")
+ iOS General purpose version
  [http://mmind.me/\_\_\_](http://mmind.me/___ "Pastelet Maker - iOS")
+ iOS Email\/Login optimized version
  [http://mmind.me/email](http://mmind.me/email "Email/Login Pastelet Maker - iOS")
+ iOS Telephone field optimized version
  [http://mmind.me/tel](http://mmind.me/tel "Telephone Pastelet Maker - iOS")

## Requirements

Web browser or Mobile Safari from iOS 3.3 or higher

## License

MIT License - <http://opensource.org/licenses/mit-license.php>

Pastelets

Copyright (c) 2008-2017 Tom King  <mobilemind@pobox.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

## Repository Notes

The `/web` directory has the final, optimized HTML/CSS/JavaScript and their
shared HTML5 manifest file. The HTML, CSS, and manifest files are `deflate`
compressed. The JavaScript is "uglified", but not compressed.

## Deployment Notes

For deployment "pastelets" likely requires web server configuration (e.g.,
`.htaccess` on Apache servers).

Required configuration items include:

1. The MIME type for the HTML 5 manifest file. For Apache that looks like:

    ````apache
    AddType text/cache-manifest cache manifest
    ````

2. With files named '\_\_\_' or 'email' or 'tel':

    a. Force to be MIME type `text/html`

    b. Set encoding to zip

    c. Set cache options to enable caching for a few minutes at least.

    For Apache this looks like:

    ````apache
    <FilesMatch "^(___|email|tel)$">
    ForceType "text/html; charset=utf-8"
    Header set Content-Encoding "deflate"
    Header set Cache-Control "max-age=361, public, proxy-revalidate"
    </FilesMatch>
    ````

### Tips

1. The file name `___` is used to clarify editing of the bookmarklet and
   serve as a short filename
2. Ideally, the files will be in a subdirectory of the web server root with a
   short name.

Finally, note that the app will work fine with the manifest directive
removed, and/or the HTML file renamed. If the manifest is used the file
should be served via HTTPS for best results. If the HTML file is renamed,
the instructions in the HTML should probably be changed.

## Build Notes

The project builds with `node`, `npm` and `grunt`. It should build on
most platforms that support node. To clone and build the project:

   ````bash
   git clone https://github.com/mobilemind/pastelets
   cd pastelets
   npm install
   grunt
   ````

The project has been built successfully on macOS 10.7-10.12.
