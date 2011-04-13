// TEL
// unique version of Pastelet Maker for NOT confirming and pasting into tel input field
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
	return ''==u ? u :"javascript:var%20s='"+encodeURIComponent(u)+"',f=document.getElementsByTagName('input'),x=-1,b=x,j=0,l=f.length,p='tel',k,n,t;for(;j%3cl;j%2b%2b){k=f[j];n=k.id%2bk.name%2bk.title;t=k.type;if(t==p||(t!='hidden'&&(n.indexOf(p)%3e-1||n.indexOf('hone')%3e0))){x=j;break}if(-1==b&&'text'==t&&n.indexOf('earch')%3c0)b=j}" + "if(-1==x)x=b;if(-1!=x){f[x].focus();f[x].value=s;f[x].blur()}else%20alert('Tel%20field%20not%20found');void(0)"
};

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