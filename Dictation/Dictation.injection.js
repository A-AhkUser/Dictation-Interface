var A_LastWidth = window.outerWidth, A_LastHeight = window.outerHeight;

Dictation = new function() {

	document.getElementById("lang").setAttribute("onclick", "javascript:updateLang(this);return false;");
	// document.getElementById("btnClear").setAttribute("onclick", "javascript:clearSlate();return false;");
	// document.getElementById("btn").setAttribute("onclick", "javascript:action();return false;");
	window.addEventListener("resize", function() {
	var __width = window.outerWidth - A_LastWidth;
		Dictation.winResizeEventMonitor(__width, !__width);
	});

	return {
		
		recognitionState: 0,
		set recognitionLanguage(__LID) {
		
			if (__LID < 1) return; 
			console.info((document.getElementById("lang")[document.getElementById("lang").selectedIndex=__LID - 1]).value);
			document.getElementById("lang").click();

		},
		start: function() {

		this.recognitionState = 1, document.getElementById("btnClear").click(), document.getElementById("btn").click(), document.title = this.recognitionState;
		
		console.log(arguments.callee.name);
		
			this.titleUpdater = window.setInterval(function() {
				document.title = document.getElementById("labnol").innerText + document.getElementById("notfinal").innerText;
			}, 700);
		
		},
		stop: function() {
	
		this.recognitionState = -1, document.getElementById("btn").click(), clearInterval(this.titleUpdater), document.title = this.recognitionState;
		
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

};
console.log(document.title=chrome.runtime.id);