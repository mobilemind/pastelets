
<!--
// TEL @VERSION@
// unique version of Pastelet Maker for NOT confirming and pasting into tel input field
//

//	pastelet- create bookmarklet for Mobile Safari to 'paste' provided text into HTML form text field
//
//	Copyright (c) 2008-2011 Tom King. All rights reserved.
//
// Comments- Generated bookmarklet is carefully constructed.
// *	The 'paste string' variable ('n') is defined first to make it more visible and ease editing the bookmark itself.
// *	The text entry types for HTML5 are checked, except search. Search is skipped as a convenience (fixed text for a search is rare)
// *	Bookmarklet code is optimized for size (ie, string length of all the code), given goal above.
// **	it wasn't written as an anonymous function, because the 'function(){..}' declaration adds characters
// * void(0) is included for cross-browser compatibility, a non-null return value causes some browsers to navigate
//

function pastelet(u) {
	return !u ? '' :"javascript:var%20s%3D'"+encodeURIComponent(u)+"',f%3Ddocument.getElementsByTagName('input'),x%3D-1,b%3Dx,j%3D0,l%3Df.length,p%3D'tel',k,n,t;for(;j%3cl;j%2b%2b){k%3Df[j];n%3Dk.id%2bk.name%2bk.title;t%3Dk.type;if(t%3D%3Dp||(t!%3D'hidden'%26%26(n.indexOf(p)%3e-1||n.indexOf('hone')%3e0))){x%3Dj;break}if(-1%3D%3Db%26%26'text'%3D%3Dt%26%26n.indexOf('earch')%3c0)b%3Dj}if(-1%3D%3Dx)x%3Db;if(-1!%3Dx){f[x].focus();f[x].value%3Ds;f[x].blur()};void('@VERSION@')";
}

//
// annotated version of code for generated bookmark
//
// var s = 'your text', // string to 'paste'
//	// all potential input fields
//	f = document.getElementsByTagName('input'),
//	x = -1,
//	b = x,
//	j = 0,
//	l = f.length,
//	p='tel',
//	k, n, t;
//	// loop through all inputs
//	for (; j < l; j++) {
//		k = f[j];
//		n = k.id + k.name + k.title;
//		t = k.type;
//		// store index and break when type, id, name or title matches 'tel' or 'hone' (for 'Phone' or 'phone')
//		if (t==p || (t != 'hidden' && (n.indexOf(p) > -1 || n.indexOf('hone') > 0))) {
//			x = j;
//			break
//		}
//		// set fallback to first 'non-search' text input
//		if (-1 == b && 'text' == t && n.indexOf('earch') < 0) b = j;
//	}
//	// no match? use fallback
//	if(-1 == x) x = b;
//	if (-1 != x) {
//		// set focus and value to match
//		f[x].focus();
//		f[x].value = s;
//		// blur to trigger a change event (helps some frameworks)
//		f[x].blur()
//	}
//	else alert('Tel field not found');
//	void(0) // return void so browser doesn't navigate, etc.
//
// -->
