function inIFrame() { 
    if ( window.location !== window.parent.location ) { 
        return true;
    } else { 
        return false;
    } 
}

//  use document.domain to implement cross-domain refs
// eslint-disable-next-line no-restricted-globals
if(inIFrame()) {
    document.domain = 'lgxzj.wiki'
}

// 计算页面的实际高度，iframe自适应会用到
function calcPageHeight(ele) {
    var height = ele.scrollHeight;
    return height;
}

function iframeChangedHandler() {
    if (!inIFrame()) {
        console.log("not inside iframe, no need to change iframe size");
        return;
    }

    var height = calcPageHeight(document.getElementById('root'));
    
    // eslint-disable-next-line no-restricted-globals
    var parentIFrameNode = parent.document.getElementById('ifr');
    if (parentIFrameNode !== null) {
        console.log("changing parent iframe('ifr') to size:", height);
        parentIFrameNode.style.height = height + 'px';
    }
}

window.onload = iframeChangedHandler;