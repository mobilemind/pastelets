
<!--
// EMAIL
// unique version of pastelet for pasting into email/login input field WITHOUT confirmation
//

//	pastelet- create bookmarklet for Mobile Safari to 'paste' provided text into HTML form text field
//
//	Copyright (c) 2008-2010 Tom King. All rights reserved.
//
// Comments- Generated bookmarklet is carefully constructed.
// *	The 'paste string' variable ('n') is defined first to make it more visible and ease editing the bookmark itself.
// *	The text entry types for HTML5 are checked, except search. Search is skipped as a convenience (fixed text for a search is rare)
// *	Bookmarklet code is optimized for size (ie, string length of all the code), given goal above.
// **	it wasn't written as an anonymous function, because the 'function(){..}' declaration adds characters
// * void(0) is included for cross-browser compatibility, a non-null return value causes some browsers to navigate
//

function pastelet(u) {
	return '' == u ? u : "javascript:var%20s%3D'" + encodeURIComponent(u) + "',f%3Ddocument.getElementsByTagName('input'),x%3D-1,b%3Dx,j%3D0,l%3Df.length,k,n,t;for(;j%3cl;j%2b%2b){k%3Df[j];n%3Dk.id%2bk.name%2bk.title;t%3Dk.type;if(t%20in{email:1,login:1}||(t!%3D'hidden'%26%26(n.indexOf('email')%3e-1||n.indexOf('ogin')%3e0||n.indexOf('user')%3e-1))){x%3Dj;break}if(-1%3D%3Db%26%26'text'%3D%3Dt%26%26n.indexOf('earch')%3c0)b%3Dj}" + "if(-1%3D%3Dx)x%3Db;if(-1!%3Dx){f[x].focus();f[x].value%3Ds;f[x].blur()};void(0)"
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
//	k, n, t;
//	// loop through all inputs
//	for (; j < l; j++) {
//		k = f[j];
//		n = k.id + k.name + k.title; // join id, name, & title to easily check all at once
//		t = k.type;
//		// store index and break when type, id or name matches 'email' or 'ogin' (login/Login) or 'user' (user/userid/username)
//		if (t in {email:1,login:1} || (t != 'hidden' && (n.indexOf('email') > -1 || n.indexOf('ogin') > 0 || n.indexOf('user') >-1))) {
//			x = j;
//			break
//		}
//		// set fallback to first 'non-search' text input (uses 'earch' to test for Search or search)
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
//	else alert('Email field not found');
//	void(0) // return void so browser doesn't navigate, etc.
// 
// -->
