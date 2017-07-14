// TEL _MmVERSION_
// unique version of Pastelet Maker for NOT confirming and pasting into tel input field
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
  return u ? '(()=>{var a="' + u.trim() +
  '",f=document.getElementsByTagName("input"),l=f.length,p="tel";let b=-1,i=0,k=null,n="",t="",x=-1;for(;i<l;i++){k=f[i];t=k.type;if("hidden"===t)continue;n=k.id+k.name+k.title;if(t===p||n.indexOf(p)>-1||n.indexOf("hone")>0||n.indexOf("cell")>-1||n.indexOf("mobile")>-1){x=i;break}if(-1==b&&"text"==t&&n.indexOf("earch")<0)b=i}if(-1==x)x=b;if(-1!=x){f[x].focus();f[x].value=a;f[x].blur()}else{alert("Tel field not found")}return void"_MmVERSION_"})()' : null;
}

//
// annotated version of code for generated bookmark
//
// (() => {
//   var a = 'your text',
//     f = document.getElementsByTagName('input'),
//     l = f.length,
//     p = 'tel';
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
//     n = k.id + k.name + k.title;
//     // store index and break when type, id, name or title matches 'tel', 'hone' (for 'Phone' or 'phone'), 'cell' or 'mobile'
//     if (t === p || n.indexOf(p) > -1 || n.indexOf('hone') > 0 ||
//     n.indexOf("cell") > -1 || n.indexOf("mobile") > -1) {
//       x = i;
//       break;
//     }
//     // set fallback to first 'non-search' text input
//     if (-1 == b && 'text' == t && n.indexOf('earch') < 0) {
//       b = i;
//     }
//   }
//   // no match? use fallback
//   if (-1 == x) {
//     x = b;
//   }
//   if (-1 != x) {
//     // set focus and value to match
//     f[x].focus();
//     f[x].value = a;
//     // blur to trigger a change event (helps some frameworks)
//     f[x].blur();
//   } else {
//     alert('Tel field not found');
//   }
//   return void so bookmark doesn't navigate, BUT embed version info, too.
//   return void "_MmVERSION_";
// })();
//
