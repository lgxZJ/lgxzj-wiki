<script type="text/javascript">
        document.domain = 'lgxzj.wiki'
</script>

<script>
    // 计算页面的实际高度，iframe自适应会用到
    function calcPageHeight(doc) {
        var cHeight = Math.max(doc.body.clientHeight, doc.documentElement.clientHeight)
        var sHeight = Math.max(doc.body.scrollHeight, doc.documentElement.scrollHeight)
        var height  = Math.max(cHeight, sHeight)
        return height
    }
    window.onload = function() {
        var height = calcPageHeight(document)
        parent.document.getElementById('ifr').style.height = height + 'px'     
    }
</script>