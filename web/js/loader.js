function showDesktopLink(){if(-1===navigator.userAgent.indexOf('Safari')||-1===navigator.userAgent.indexOf('Mobile')){const a=document.getElementById('pal'),b=document.getElementById('pl');a&&b&&(b.href=document.getElementById('bmrk').textContent,b.title=document.title,b.replaceChild(document.createTextNode(document.title),b.childNodes[0]),a.style.display=b.style.display='inline')}window.scrollTo(0,78+document.getElementById('pltMkr').scrollHeight)}window.addEventListener('load',function(){if(location.hash)try{const a=decodeURIComponent(location.hash.substr(1));var b=a.match(/^javascript:\(\(\).*? \w="(.*?)"/);if(!b)throw Error('No match in location.hash');const c=b[1];var d=null;if(!c)throw Error('Empty or invalid string to paste from location.hash');document.title='Paste '+c,document.getElementById('pStr').value=c,d=document.getElementById('skp'),d&&0>a.indexOf(';if(confirm(')&&(d.checked='on'),document.getElementById('bmrk').textContent=encodeURI(a),showDesktopLink()}catch(a){console.log('error: '+a),alert('Unable to decode pastelet.\nForm will be reset.'),location.replace('//'+location.host+location.port+location.pathname)}},!0);function loadpg(a){a&&(document.getElementById('bmrk').textContent='javascript:'+encodeURI(a),location.replace('//'+location.host+location.port+location.pathname+'#javascript:'+encodeURIComponent(a)),document.title='Paste '+document.getElementById('pStr').value,showDesktopLink())}