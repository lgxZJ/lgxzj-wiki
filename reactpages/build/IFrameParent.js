function inIFrame() { 
    if ( window.location !== window.parent.location ) { 
        return true;
    } else { 
        return false;
    } 
}

//  use document.domain to implement cross-domain refs
// eslint-disable-next-line no-restricted-globals
if(inIFrame()) { //  if inside iframe
    document.domain = 'lgxzj.wiki'
}
