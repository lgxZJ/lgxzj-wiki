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
function calcPageHeight(doc) {
    console.log("body scroll height:", doc.body.scrollHeight);
    console.log("doc ele scroll height:", doc.documentElement.scrollHeight);
    console.log("body client height:", doc.body.clientHeight);
    console.log("doc ele client height:", doc.documentElement.clientHeight);
    console.log("body offset height:", doc.body.offsetHeight);
    console.log("doc ele offset height:", doc.documentElement.offsetHeight);

    var height = Math.max(doc.body.scrollHeight, doc.documentElement.scrollHeight);
    return height;
}

function iframeChangedHandler() {
    if (!inIFrame()) {
        console.log("not inside iframe, no need to change iframe size");
        return;
    }

    var height = calcPageHeight(document)
    
    // eslint-disable-next-line no-restricted-globals
    var parentIFrameNode = parent.document.getElementById('ifr');
    if (parentIFrameNode !== null) {
        console.log("changing parent iframe('ifr') to size:", height);
        parentIFrameNode.style.height = height + 'px';
    }
}

window.onload = iframeChangedHandler;

//  TODO: remove this
window.addEventListener('message', function (event) {

    // Need to check for safety as we are going to process only our messages
    // So Check whether event with data(which contains any object) contains our message here its "FrameHeight"
   if (event.data === "FrameHeight") {

        //event.source contains parent page window object 
        //which we are going to use to send message back to main page here "abc.com/page"

        //parentSourceWindow = event.source;

        //Calculate the maximum height of the page
        var body = document.body;
        var html = document.documentElement;
        var height = Math.max(body.scrollHeight, body.offsetHeight, html.clientHeight, html.scrollHeight, html.offsetHeight);

       // Send height back to parent page "abc.com/page"
        event.source.postMessage({ "FrameHeight": height }, "*");       
    }
});

export default iframeChangedHandler;