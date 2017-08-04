// actually creates bookmarklet given 'u'=user string and 's'=skip confirm true/false

//  pastelet- create bookmarklet for Mobile Safari to 'paste' provided text into HTML form text field
//  3.7.0
//
//  Copyright (c) 2008-2017 Tom King. All rights reserved.
//
// Comments- Generated bookmarklet is carefully constructed.
// *  The 'paste string' variable ('n') is defined first to make it more visible and ease editing the bookmark itself.
// *  The text entry types for HTML5 are checked, except search. Search is skipped as a convenience (fixed text for a search is rare)
// *  Bookmarklet code is optimized for size (ie, string length of all the code), given goal above.
// ** all vars are global, but could be scoped
// ** the skip ('skp') option is provided for usability of common use case- sign-in forms (no confirmation needed)
// ** skip option also generates a smaller bookmarklet (old value not saved, var 'o' not defined, confirmation 'if' statement removed
//  spaces and optional ';' are removed-- eg, spaces between keywords and symbols, or the ';' before a '}'
// ** it wasn't written as an anonymous function, because the 'function(){..}' declaration adds characters (to resulting bookmarklet)
// * void(0) is included for cross-browser compatibility, a non-null return value causes some browsers to navigate
// * 'pastex.js' is a 'minified' version of makePastelet with spaces, etc condensed AND assignment/return done in one swoop
//

function pastelet(u,s) {
  // strip leading/trailing spaces to help w/iOS 5 shortcut text & pastelet
  return u ? '(()=>{const a="' + u.trim() +
  '",f=document.getElementsByTagName("input");let i=0' + (s ? '' : ',o=""') +
  ';for(;i<f.length;i++){if("hidden"===f[i].type)continue;if(f[i].type in{email:1,login:1,password:1,tel:1,text:1,url:1}&&(f[i].id+f[i].name+f[i].title).indexOf("earch")<0){' +
  (s ? '' : 'o=f[i].value;') + 'f[i].focus();f[i].value=a;' +
  (s ? '' : 'if(confirm("Paste Here? (field "+(i+1)+")")){') +
  'f[i].blur();break' + (s ? '' : '}else{f[i].value=o}') +
  '}}return void"3.7.0"})()' : null;
}


// *  ANNOTATED JAVASCRIPT OF A BOOKMARKLET (short 'skip confirm' version)
// (() => {
//   const a = "your text",
//     f = document.getElementsByTagName("input");
//   let i = 0;
//   for (; i < f.length; i++) {
//     if ("hidden" === f[i].type) {
//       continue;
//     }
//     if (f[i].type in {
//       "email": 1,
//       "login": 1,
//       "password": 1,
//       "tel": 1,
//       "text": 1,
//       "url": 1
//     } && (f[i].id + f[i].name + f[i].title).indexOf("earch") < 0) {
//       f[i].focus();
//       f[i].value = a;
//       f[i].blur();
//       break;
//     }
//   }
//   return void '3.7.0';
// })();

// *  ANNOTATED JAVASCRIPT OF A BOOKMARKLET (longer 'confirm field' version)
// (() => {
//   const a = "your text",
//     f = document.getElementsByTagName("input");
//   let i = 0,
//     o = "";
//   for (; i < f.length; i++) {
//     if ("hidden" === f[i].type) {
//       continue;
//     }
//     if (f[i].type in {
//       "email": 1,
//       "login": 1,
//       "password": 1,
//       "tel": 1,
//       "text": 1,
//       "url": 1
//     } && (f[i].id + f[i].name + f[i].title).indexOf("earch") < 0) {
//       o = f[i].value;
//       f[i].focus();
//       f[i].value = a;
//       if (confirm("Paste Here? (field " + (i + 1) + ")")) {
//         f[i].blur();
//         break;
//       } else {
//         f[i].value = o;
//       }
//     }
//   }
//   return void '3.7.0';
// })();
