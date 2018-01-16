document.addEventListener("DOMContentLoaded", function () {

    var __url = chrome.extension.getURL("popup.html#progress");

    if (window.location.href === __url) {

        document.title = "Dictation  initializing...";

        window.addEventListener("resize", function () {

            var __e = document.createElement("progress");
            __e.value = 0, __e.max = 100, document.body.appendChild(__e);

            document.title = "Dictation loading... " + __e.value + "%";

                window.setInterval(function (__progressControl) {
                    if (__progressControl.value == 100) clearInterval();
                    else __progressControl.value = __progressControl.value + 1, document.title = "Dictation loading... " + __e.value + "%";
                }, 25, __e);

                window.setTimeout(function () {
                    window.location.href = "https://dictation.io/speech";
                }, 3500);

        }, {"once": true});

    }

});