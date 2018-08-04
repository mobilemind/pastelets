// loader _MmVERSION_, _MmBUILDDATE_
// listener to dynamically position page for initial or return-trip
function showDesktopLink() {
  const b = document.getElementById('bmrk'),
    pal = document.getElementById('pal'),
    pl = document.getElementById('pl');
  // if not iPhone/iPad unhide 'Pastelet as link' and set anchor tag
  if (!(-1 !== navigator.userAgent.indexOf('Safari') && -1 !== navigator.userAgent.indexOf('Mobile'))) {
    if (pal && pl) {
      pl.href = b.textContent;
      pl.title = document.title;
      pl.replaceChild(document.createTextNode(document.title),
        pl.childNodes[0]);
      pal.style.display = pl.style.display = "inline";
    }
  }
  // scroll to show remaining steps & select bookmark text
  window.scrollTo(0, 78 + document.getElementById('pltMkr').scrollHeight);
  b.focus();
  b.select();
}

window.addEventListener('load', () => {
  if (location.hash) {
    // reload form UI from query string
    try {
      const q = decodeURIComponent(location.hash.substr(1));
      const m = q.match(/^javascript:\(\(\).*? \w="(.*?)"/);
      if (m) {
        const p = m[1];
        let skp = null;
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
      location.hash = "";
      location.replace('//' + location.host + location.port + location.pathname);
      location.reload(true);
    }
  }
}, true);
// reload page with new bookmarklet appended
function loadpg(p) {
  if (p) {
    document.getElementById('bmrk').textContent = 'javascript:' + encodeURI(p);
    history.pushState({}, 'Paste ' + document.getElementById('pStr').value,
      location.pathname + '#javascript:' + encodeURIComponent(p));
    document.title = 'Paste ' + document.getElementById('pStr').value;
    showDesktopLink();
  }
}
