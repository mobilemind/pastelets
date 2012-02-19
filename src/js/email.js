
<!--
// EMAIL _MmVERSION_
// unique version of pastelet for pasting into email/login input field WITHOUT confirmation
//

//	pastelet- create bookmarklet for Mobile Safari to 'paste' provided text into HTML form text field
//
//	Copyright (c) _MmCOPYRIGHT_ Tom King. All rights reserved.
//
// Comments- Generated bookmarklet is carefully constructed.
// *	The 'paste string' variable ('n') is defined first to make it more visible and ease editing the bookmark itself.
// *	The text entry types for HTML5 are checked, except search. Search is skipped as a convenience (fixed text for a search is rare)
// *	Bookmarklet code is optimized for size (ie, string length of all the code), given goal above.
// **	it wasn't written as an anonymous function, because the 'function(){..}' declaration adds characters
// * void(0) is included for cross-browser compatibility, a non-null return value causes some browsers to navigate
//

function pastelet(u) {
	u = u.match(/^ *(.*?) *$/)[1]; // strip leading/trailing spaces to help w/iOS 5 shortcut text
	return !u ? '' : "var s='" + u + "',f=document.getElementsByTagName('input'),x=-1,b=x,j=0,l=f.length,k,n,t;for(;j<l;j++){k=f[j];n=k.id+k.name+k.title;t=k.type;if(t in{email:1,login:1}||(t!='hidden'&&(n.indexOf('email')>-1||n.indexOf('ogin')>0||n.indexOf('user')>-1))){x=j;break}if(-1==b&&'text'==t&&n.indexOf('earch')<0)b=j}if(-1==x)x=b;if(-1!=x){f[x].focus();f[x].value=s;f[x].blur()};void('_MmVERSION_')";
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
