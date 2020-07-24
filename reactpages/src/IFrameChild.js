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
    // console.log("body scroll height:", doc.body.scrollHeight);
    // console.log("doc ele scroll height:", doc.documentElement.scrollHeight);
    // console.log("body client height:", doc.body.clientHeight);
    // console.log("doc ele client height:", doc.documentElement.clientHeight);
    // console.log("body offset height:", doc.body.offsetHeight);
    // console.log("doc ele offset height:", doc.documentElement.offsetHeight);

    var height = Math.max(ele.scrollHeight, ele.scrollHeight);
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

export default iframeChangedHandler;