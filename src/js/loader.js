
<!--
// listener to dynamically position page for initial or return-trip
window.addEventListener('load',
	function() {
		var q = location.search, p = '', skp;
		if ('' != q) {
				// reload form UI from query string
				try {
					p = decodeURIComponent(q.match(/^\?javascript:var( |%20)s(=|%3D)('|%27)(.*?)('|%27),f(=|%3D)/)[4]);
					document.title = 'Paste ' + p;
					document.getElementById('pStr').value = p;
					// if generic pastelet maker "Skip...?" exists, set 'skip confirm' accordingly
					skp = document.getElementById("skp");
					if (null != skp) {
						if (q.indexOf(';if(confirm(') < 0) skp.checked = 'on';
					}
					// put a more human-readable, but compatible, version of bookmarklet in textarea
					document.getElementById('bmrk').textContent = q.substring(1).replace(/\%27/g,"'");
					// if not iPhone/iPad unhide 'Pastelet as link' and set anchor tag
					if (!(-1 != navigator.userAgent.indexOf('Safari') && -1 != navigator.userAgent.indexOf('Mobile'))) {
						var pal = document.getElementById('pal'), pl = document.getElementById('pl');
						if (null != pal && null != pl) {
							pal.setAttribute("style", "display:inline;padding:7px;height:auto");
							pl.setAttribute('href', q.substring(1));
							pl.setAttribute('title', document.title);
							pl.innerHTML = document.title;
						}
					}
		 			// unhide remaining steps
					window.scrollTo(0,78+document.getElementById('pltMkr').scrollHeight)
				}
				catch (e) {
					alert("Unable to decode pastelet.\r\nForm will be reset.");
					location.href=location.href.substring(0,location.href.indexOf('?'));
					return
				}
		}
		// hide address bar
		else window.scrollTo(0,1);
	}
,true);
// reload page with new bookmarklet appended
function loadpg(p) {
	if ('' != p) {
	  document.getElementById('bmrk').textContent = p;
	  location.href = location.protocol + '//' + location.host + location.port + location.pathname + '?' + p
	}
}
// -->
