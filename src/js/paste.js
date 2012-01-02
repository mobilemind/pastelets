
<!--
// actually creates bookmarklet given 'u'=user string and 's'=skip confirm true/false

//	pastelet- create bookmarklet for Mobile Safari to 'paste' provided text into HTML form text field
//  _MmVERSION_
//
//	Copyright (c) _MmCOPYRIGHT_ Tom King. All rights reserved.
//
// Comments- Generated bookmarklet is carefully constructed.
// *	The 'paste string' variable ('n') is defined first to make it more visible and ease editing the bookmark itself.
// *	The text entry types for HTML5 are checked, except search. Search is skipped as a convenience (fixed text for a search is rare)
// *	Bookmarklet code is optimized for size (ie, string length of all the code), given goal above.
// **	all vars are global, but could be scoped
// **	the skip ('skp') option is provided for usability of common use case- sign-in forms (no confirmation needed)
// **	skip option also generates a smaller bookmarklet (old value not saved, var 'o' not defined, confirmation 'if' statement removed
//	spaces and optional ';' are removed-- eg, spaces between keywords and symbols, or the ';' before a '}'
// **	it wasn't written as an anonymous function, because the 'function(){..}' declaration adds characters (to resulting bookmarklet)
// * void(0) is included for cross-browser compatibility, a non-null return value causes some browsers to navigate
// * 'pastex.js' is a 'minified' version of makePastelet with spaces, etc condensed AND assignment/return done in one swoop
//

function pastelet(u,s) {
	return !u ? '' : "var s='" + u + "',f=document.getElementsByTagName('input'),i=0" + (s ? ";" : ",o;") + "for(;i<f.length;i++)if(f[i].type in{text:1,email:1,login:1,tel:1,url:1,password:1}&&(f[i].id+f[i].name+f[i].title).indexOf('earch')<0){" + (s ? "" : "o=f[i].value;")  + "f[i].focus();f[i].value=s;" + (s ? "f[i].blur();break" : "if(confirm('Paste Here? (field '+(i+1)+')')){f[i].blur();break}else f[i].value=o") + "}void('_MmVERSION_')";
}

// Examples below provide samples of the resulting bookmarklet and expanded/commented code of the bookmarklet
// All examples assume the text to be pasted is 'your text'. Note examples below are slightly out-of-date & missing check to skip "search" fields.
//

// *	SAMPLE ENCODED BOOKMARKLET from pastelet('your text', true)  (short 'skip confirm' version)
// javascript:var%20s='your%20text',f=document.getElementsByTagName('input'),i=0;for(;i%3cf.length;i%2b%2b)\
// if(f[i].type%20in{text:1,email:1,login:1,tel:1,url:1,password:1}&&(f[i].id%2bf[i].name%2bf[i].title).indexOf('earch')%3c0){\
// f[i].focus();f[i].value=s;f[i].blur();break}void(0)

// *	SAMPLE ENCODED BOOKMARKLET from pastelet('your text', false)  [longer 'do not skip, confirm field' version]
// javascript:var%20s='your%20text',f=document.getElementsByTagName('input'),i=0,o;for(;i%3cf.length;i%2b%2b)\
// if(f[i].type%20in{text:1,email:1,login:1,tel:1,url:1,password:1}&&(f[i].id%2bf[i].name%2bf[i].title).indexOf('earch')%3c0){\
// o=f[i].value;f[i].focus();f[i].value=s;f[(i==0?1:0)].focus();f[i].focus();\
// if(confirm('Paste%20Here?%20(field%20'%2b(i%2b1)%2b')')){f[i].blur();break}else%20f[i].value=o}void(0)

// *	ANNOTATED JAVASCRIPT OF A BOOKMARKLET (short 'skip confirm' version)
// 	javascript:
//		// new string to 'paste'
//		var s = 'your text',
//		// get array of all input elements
//		f = document.getElementsByTagName('input'),
//		i; // loop index
//		// loop through inputs and process if a text entry type
//		// use property array of HTML 5 input types to check for text entry (or related types)
//		for (; i < f.length; i++) if (f[i].type in {text:1, email:1, login:1, tel:1, url:1, password:1}
//			// match text fields above, but skip 'search' fields
//			&& (f[i].id + f[i].name + f[i].title).indexOf('earch') < 0) {
//				f[i].focus();	// set focus
//				f[i].value = s;	// set field to new value
//				f[i].blur();	// move focus (helps some frameworks)
//				break
//		}
//		// return void so browser doesn't navigate, etc.
//		void(0)

// *	ANNOTATED JAVASCRIPT OF A BOOKMARKLET (longer 'confirm field' version)
//	javascript:
//		// new string to 'paste'
//		var s = 'your text',
//		// get array of all input elements
//		f = document.getElementsByTagName('input'),
//		i = 0,	// loop index
//		o;		// old string to save/restore
//		// loop through inputs and process if a text entry type
//		// use property array of HTML 5 input types to check for text entry (or related types)
//		for (; i < f.length; i++) if (f[i].type in {text:1, email:1, login:1, tel:1, url:1, password:1}
//			// match text fields above, but skip 'search' fields
//			&& (f[i].id + f[i].name + f[i].title).indexOf('earch') < 0) {
//				o = f[i].value;	// get value currently in field
//				f[i].focus();	// set focus
//				f[i].value = s;	// set field to new value
//				// confirm & exit or restore old value and try again
//				if (confirm('Paste Here? (field ' + (i+1) +')')) {
//					f[i].blur();	// move focus (helps some frameworks)
//					break
//				}
//				else f[i].value = o
//		}
//		void(0) // return void so browser doesn't navigate, etc.
// -->
