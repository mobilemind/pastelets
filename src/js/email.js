// EMAIL _MmVERSION_
// unique version of pastelet for pasting into email/login input field WITHOUT confirmation
//

//  pastelet- create bookmarklet for Mobile Safari to 'paste' provided text into HTML form text field
//
//  Copyright (c) _MmCOPYRIGHT_ Tom King. All rights reserved.
//
// Comments- Generated bookmarklet is carefully constructed.
// *  The 'paste string' variable ('n') is defined first to make it more visible and ease editing the bookmark itself.
// *  The text entry types for HTML5 are checked, except search. Search is skipped as a convenience (fixed text for a search is rare)
// *  Bookmarklet code is optimized for size (ie, string length of all the code), given goal above.
// ** it wasn't written as an anonymous function, because the 'function(){..}' declaration adds characters
// * void(0) is included for cross-browser compatibility, a non-null return value causes some browsers to navigate
//

function pastelet(u) {
  // strip leading/trailing spaces to help w/iOS 5 shortcut text & pastelet
  return u ? `(() => {const a="${u.trim()}",f=document.getElementsByTagName("input"),l=f.length;let b=-1,i=0,k=null,n="",t="",x=-1;for(;i<l;i++){k=f[i];t=k.type;if("hidden"===t)continue;n=k.id+k.name+k.title;if(t in{email:1,login:1}||n.indexOf("email")>-1||n.indexOf("ogin")>0||n.indexOf("user")>-1){x=i;break}if(-1==b&&"text"==t&&n.indexOf("earch")<0)b=i}if(-1===x)x=b;if(-1===x)alert("Email field not found");else{f[x].focus();f[x].value=a;f[x].blur()}return void"_MmVERSION_"})()` : null;
}

//
// annotated version of code for generated bookmark
//
// (() => {
//   // a = string to 'paste'
//   const a = "email@domain.co",
//     f = document.getElementsByTagName("input"),
//     l = f.length;
//   let b = -1,
//     i = 0,
//     k = null,
//     n = "",
//     t = "",
//     x = -1;
//   // loop through all inputs
//   for (; i < l; i++) {
//     k = f[i];
//     t = k.type;
//     if ("hidden" === t) {
//       continue;
//     }
//     // join id, name, & title to easily check all at once
//     n = k.id + k.name + k.title;
//     if (t in {"email": 1, "login": 1} || n.indexOf("email") > -1 || n.indexOf("ogin") > 0 || n.indexOf("user") > -1) {
//       x = i;
//       break;
//     }
//     // set fallback to first 'non-search' text input (uses 'earch' to test for Search or search)
//     if (-1 == b && "text" == t && n.indexOf("earch") < 0) {
//       b = i;
//     }
//   }
//   // no match? use fallback
//   if (-1 === x) {
//     x = b;
//   }
//   if (-1 === x) {
//     alert("Email field not found");
//   } else {
//     // set focus and value to match
//     f[x].focus();
//     f[x].value = a;
//     // blur to trigger a change event (helps some frameworks)
//     f[x].blur();
//   }
//   return void "_MmVERSION_";
// })()
