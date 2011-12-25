Pastelets
==========

Pastelets are web pages that generate Javascript bookmarklets primarily intended for Mobile Safari on iOS (iPhone/iPad/iPod Touch).
Each generated bookmarklet pastes its specified string into a text field.

The purpose is to make it quick and easy to complete web forms on iOS with Mobile Safari, without reliance on autocomplete.

The bookmarklet generators are available as:

+ **build/web/iphone/index.html** - desktop version that pastes into 1st field (or asks successively)
+ **build/iphone/___** - iOS optimized (with brief name) that pastes into 1st field (or asks successively)
+ **build/iphone/email** - iOS optimized to paste into the first Email/Login field on a page.
+ **build/iphone/tel** - iOS optimized to paste into the first telephone field on a page

Install
----------

Copy the appropriate generator(s) to a web server.

Usage
----------

The page includes usage instructions. Visit the appropriate bookmarklet generator page.

The easiest way to use them is visiting the hosted versions

+ Web/Desktop version [http://mobilemind.net/iphone/](http://mobilemind.net/iphone/ "Pastelet Maker - Desktop")
+ iOS General purpose version [http://mobilemind.net/___](http://mobilemind.net/___ "Pastelet Maker - iOS")
+ iOS Email/Login optimized version [http://mobilemind.net/email](http://mobilemind.net/email "Email/Login Pastelet Maker - iOS")
+ iOS Telephone field optimized version [http://mobilemind.net/tel](http://mobilemind.net/tel "Telephone Pastelet Maker - iOS")

Requirements
----------

Web browser or Mobile Safari from iOS 3.3 or higher

License
----------

MIT License - [http://www.opensource.org/licenses/mit-license.php](http://www.opensource.org/licenses/mit-license.php)

Pastelets
Copyright (c) 2008-2011 Tom King <mobilemind@pobox.com>

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

Repository Notes
----------

The /build directory has the final, optimized HTML/JavaScript and their HTML4 manifest files.

After an ANT build-update the /src directory will have uncompressed 'easier-to-read' HTML files


Deployment Notes
----------

For deployment "pastelets" likely needs .htaccess on Apache servers.
The .htaccess file may not be visible by default, but it is in /src and /build.

The .htaccess file does the following:

1. Adds the MIME type for the HTML 5 manifest file
2. Sets a cache directive for manifest files
3. Forces files named '\_\_\_' or 'email' or 'tel' to be of MIME type 'text/html; charset=UTF-8'
4. Sets a cache directive for said files

**Notes**

1. Use CAUTION when copying .htaccess to your server. If the file exists, DO NOT over write it.
   Instead, add the needed parts of .htaccess to your existing .htaccess file.
2. The file name '\_\_\_' is used to clarify editing of the bookmarklet and serve as a short filename
3. For best results .htaccess should be in the same directory as '\_\_\_', '\_\_\_.manifest' and '/img'
4. Ideally, the files will be in a subdirectory of the web server root with a short name.

I didn't do the ideal, but I'm both cautious and rogue.
Finally, note that the app will work fine with the manifest directive removed, and/or the HTML file renamed.
If you rename the HTML file, the instructions in the HTML should probably be changed.
Likewise, the .htaccess file may need to be edited, or may not even be needed.

Build Notes
----------

To use the included ant build files, you'll likely want:
	Eclipse
	ANT
	yuicompressor
	htmlcompressor
You'll need to modify ant.properties with the proper paths to the jar files for the compressors/compilers on your system.

Tom King, January 19, 2010
