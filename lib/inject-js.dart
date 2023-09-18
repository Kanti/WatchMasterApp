var javaScriptClick = """
(() => {
    const evt = document.createEvent('MouseEvents');
    evt.initMouseEvent('click', true, true, window,
        1, 1, 1, 1, 1, false, false, false, false, 0, null);
    const cb = document.querySelector(".hoster-player");
    return cb.dispatchEvent(evt);
})()
""";
