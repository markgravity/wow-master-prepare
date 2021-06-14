# Master Prepare

```javascript
function copy(text) {
    var textArea = document.createElement("textarea");
    textArea.value = text;

    // Avoid scrolling to bottom
    textArea.style.top = "0";
    textArea.style.left = "0";
    textArea.style.position = "fixed";

    document.body.appendChild(textArea);
    textArea.focus();
    textArea.select();

    try {
        var successful = document.execCommand('copy');
        var msg = successful ? 'successful' : 'unsuccessful';
        console.log('Fallback: Copying text command was ' + msg);
    } catch (err) {
        console.error('Fallback: Oops, unable to copy', err);
    }

    document.body.removeChild(textArea);
}

output = Array.from($(".listview-row td:nth-child(3) a.q1").map((i, e) => {
    id = $(e).attr("href").split("/")[1].split("=")[1];
    name = $(e).text()
    return `${id}`
})).join(",")
copy(output)
```