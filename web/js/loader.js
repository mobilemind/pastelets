function showDesktopLink(){const a=document.getElementById('bmrk'),b=document.getElementById('pal'),c=document.getElementById('pl');-1!==navigator.userAgent.indexOf('Safari')&&-1!==navigator.userAgent.indexOf('Mobile')||b&&c&&(c.href=a.textContent,c.title=document.title,c.replaceChild(document.createTextNode(document.title),c.childNodes[0]),b.style.display=c.style.display='inline'),window.scrollTo(0,78+document.getElementById('pltMkr').scrollHeight),a.focus(),a.select()}window.addEventListener('load',function(){if(location.hash)try{const a=decodeURIComponent(location.hash.substr(1));var b=a.match(/^javascript:\(\(\).*? \w="(.*?)"/);if(!b)throw Error('No match in location.hash');const c=b[1];var d=null;if(!c)throw Error('Empty or invalid string to paste from location.hash');document.title='Paste '+c,document.getElementById('pStr').value=c,d=document.getElementById('skp'),d&&0>a.indexOf(';if(confirm(')&&(d.checked='on'),document.getElementById('bmrk').textContent=encodeURI(a),showDesktopLink()}catch(a){console.log('error: '+a),alert('Unable to decode pastelet.\nForm will be reset.'),location.hash='',location.replace('//'+location.host+location.port+location.pathname),location.reload(!0)}},!0);function loadpg(a){a&&(document.getElementById('bmrk').textContent='javascript:'+encodeURI(a),history.pushState({},'Paste '+document.getElementById('pStr').value,location.pathname+'#javascript:'+encodeURIComponent(a)),document.title='Paste '+document.getElementById('pStr').value,showDesktopLink())}