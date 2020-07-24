//  use document.domain to implement cross-domain refs
document.domain = 'lgxzj.wiki'

// 计算页面的实际高度，iframe自适应会用到
function calcPageHeight(doc) {
    var cHeight = Math.max(doc.body.clientHeight, doc.documentElement.clientHeight)
    var sHeight = Math.max(doc.body.scrollHeight, doc.documentElement.scrollHeight)
    var height  = Math.max(cHeight, sHeight)
    return height
}
window.onload = function() {
    var height = calcPageHeight(document)
    // eslint-disable-next-line no-restricted-globals
    parent.document.getElementById('ifr').style.height = height + 'px'     
}

window.addEventListener('message', function (event) {

    // Need to check for safety as we are going to process only our messages
    // So Check whether event with data(which contains any object) contains our message here its "FrameHeight"
   if (event.data == "FrameHeight") {

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