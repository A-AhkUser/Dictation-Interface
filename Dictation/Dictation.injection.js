var A_LastWidth = window.outerWidth, A_LastHeight = window.outerHeight;

(Dictation = new function() {

	document.getElementById("lang").setAttribute("onclick", "dictation('lang');javascript:updateLang(this);return false;");

	return {

		Init: function() {
			window.addEventListener("resize", function() {
			var __width = window.outerWidth - A_LastWidth;
				Dictation.winResizeEventMonitor(__width, !__width);
			});
		},
		recognitionState: 0,
		set recognitionLanguage(__LID) {

			if (__LID < 1) return;
			console.info((document.getElementById("lang")[document.getElementById("lang").selectedIndex=__LID - 1]).value);
			document.getElementById("lang").click();

		},
		start: function() {

		this.recognitionState = 1, document.getElementsByClassName("ql-editor")[0].innerText = "", document.getElementsByClassName("btn-mic btn btn--primary-1")[0].click(), document.title = this.recognitionState;

		console.log(arguments.callee.name);

			this.titleUpdater = window.setInterval(function() {
				document.title = document.getElementsByClassName("ql-editor")[0].innerText;
			}, 700);

		},
		stop: function() {

		this.recognitionState = -1, document.getElementsByClassName("btn-mic btn bg--pinterest")[0].click(), clearInterval(this.titleUpdater), document.title = this.recognitionState;

		console.log(arguments.callee.name);

			window.setTimeout(function(__Dictation) {
				document.title = (__Dictation.recognitionState=0);
			}, 700, this);

		},
		setRecognitionLanguage: function(__language) {
		if (this.recognitionState) {
			console.warn(arguments[0]);
		return;
		}
			this.recognitionLanguage = __language;
		},

			winResizeEventMonitor: function(__width, __height) {

				if (__height)
				{
					switch(this.recognitionState) {
						case 1:
							this.stop();
						break;
						case 0:
							this.start();
						break;
						case -1:
						break;
					}
					A_LastHeight = window.outerHeight;

				}
				else if (__width)
				{
					this.setRecognitionLanguage(__width);
				A_LastWidth = window.outerWidth;
				}

			}

	}

}).Init();
console.log(document.title=chrome.runtime.id);