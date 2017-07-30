// loader _MmVERSION_, _MmBUILDDATE_
// listener to dynamically position page for initial or return-trip
function showDesktopLink() {
  // if not iPhone/iPad unhide 'Pastelet as link' and set anchor tag
  if (!(-1 !== navigator.userAgent.indexOf('Safari') && -1 !== navigator.userAgent.indexOf('Mobile'))) {
    const pal = document.getElementById('pal'),
      pl = document.getElementById('pl');
    if (pal && pl) {
      pl.href = document.getElementById('bmrk').textContent;
      pl.title = document.title;
      pl.replaceChild(document.createTextNode(document.title),
        pl.childNodes[0]);
      pal.style.display = pl.style.display = "inline";
    }
  }
  // scroll to show remaining steps
  window.scrollTo(0, 78 + document.getElementById('pltMkr').scrollHeight);
}

window.addEventListener('load', function() {
  if (location.hash) {
    // reload form UI from query string
    try {
      const q = decodeURIComponent(location.hash.substr(1));
      var m = q.match(/^javascript:\(\(\).*? \w="(.*?)"/);
      if (m) {
        const p = m[1];
        var skp = null;
        if (!p) {
          throw new Error('Empty or invalid string to paste from location.hash');
        }
        document.title = 'Paste ' + p;
        document.getElementById('pStr').value = p;
        // if generic pastelet maker "Skip...?" exists, set 'skip confirm' accordingly
        skp = document.getElementById("skp");
        if (skp && q.indexOf(';if(confirm(') < 0) {
          skp.checked = 'on';
        }
        // put a more human-readable, but URI encoded, version of bookmarklet in textarea
        document.getElementById('bmrk').textContent = encodeURI(q);
        // show link if desktop AND scroll page
        showDesktopLink();
      } else {
        throw new Error('No match in location.hash');
      }
    } catch (e) {
      console.log('error: ' + e);
      alert("Unable to decode pastelet.\nForm will be reset.");
      location.replace('//' + location.host + location.port + location.pathname);
    }
  }
}, true);
// reload page with new bookmarklet appended
function loadpg(p) {
  if (p) {
    document.getElementById('bmrk').textContent = 'javascript:' + encodeURI(p);
    location.replace('//' + location.host + location.port + location.pathname + '#javascript:' + encodeURIComponent(p));
    document.title = 'Paste ' + document.getElementById('pStr').value;
    showDesktopLink();
  }
}
