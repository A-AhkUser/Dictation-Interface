Class Dictation {

	; ==========================================
	static ID := "" ; <<<< put here the ID of the extension
	; ==========================================

		, url := "https://dictation.io/speech"
		, iteratorPeriod := 400
		, hideChromeInstance := false

		recognitionLanguage := ""
		, recognizing := false
		, interimResultTimeout := 7
		, lastInterimResultElapsedTime := 0
		, lastInterimResult := ""
		, onInterimResultFunc := this.updateInterimResults
		, onResultFunc := this.saveToClipboard

		Init() {

		static __ := Dictation.Init()

			Dictation.LID :=
			(LTrim Join
			{
				"Afrikaans": 1,
				"Azərbaycan": 2,
				"Bahasa Indonesia": 3,
				"Bahasa Melayu": 4,
				"Basa Jawa": 5,
				"Basa Sunda": 6,
				"Català": 7,
				"Čeština": 8,
				"Dansk": 9,
				"Deutsch": 10,
				"English (Australia)": 11,
				"English (Canada)": 12,
				"English (Ghana)": 13,
				"English (India)": 14,
				"English (Ireland)": 15,
				"English (Kenya)": 16,
				"English (New Zealand)": 17,
				"English (Nigeria)": 18,
				"English (Philippines)": 19,
				"English (South Africa)": 20,
				"English (Tanzania)": 21,
				"English (United Kingdom)": 22,
				"English (United States)": 23,
				"Español": 24,
				"Español (Argentina)": 25,
				"Español (Bolivia)": 26,
				"Español (Chile)": 27,
				"Español (Colombia)": 28,
				"Español (Costa Rica)": 29,
				"Español (Ecuador)": 30,
				"Español (El Salvador)": 31,
				"Español (España)": 32,
				"Español (Estados Unidos)": 33,
				"Español (Guatemala)": 34,
				"Español (Honduras)": 35,
				"Español (Latinoamérica)": 36,
				"Español (México)": 37,
				"Español (Nicaragua)": 38,
				"Español (Panamá)": 39,
				"Español (Paraguay)": 40,
				"Español (Perú)": 41,
				"Español (Puerto Rico)": 42,
				"Español (República Dominicana)": 43,
				"Español (Uruguay)": 44,
				"Español (Venezuela)": 45,
				"Euskara": 46,
				"Filipino": 47,
				"Français": 48,
				"Galego": 49,
				"Hrvatski": 50,
				"Isizulu": 51,
				"Íslenska": 52,
				"Italiano": 53,
				"Italiano (Italia)": 54,
				"Italiano (Svizzera)": 55,
				"Kiswahili (Kenya)": 56,
				"Kiswahili (Tanzania)": 57,
				"Latviešu": 58,
				"Lietuvių": 59,
				"Magyar": 60,
				"Nederlands": 61,
				"Norsk (Bokmål)": 62,
				"Polski": 63,
				"Português (Brasil)": 64,
				"Português (Portugal)": 65,
				"Română": 66,
				"Slovenčina": 67,
				"Slovenščina": 68,
				"Suomi": 69,
				"Svenska": 70,
				"Tiếng Việt": 71,
				"Türkçe": 72,
				"Ελληνικά": 73,
				"Български": 74,
				"Русский": 75,
				"Српски": 76,
				"Українська": 77,
				"հայերեն": 78,
				"h1": 79,
				"ar1": 80,
				"ar2": 81,
				"ar3": 82,
				"ar4": 83,
				"ar5": 84,
				"ar6": 85,
				"ar7": 86,
				"ar8": 87,
				"ar9": 88,
				"ar10": 89,
				"ar11": 90,
				"ar12": 91,
				"ar13": 92,
				"ar14": 93,
				"ar15": 94,
				"ar16": 95,
				"ar17": 96,
				"ar18": 97,
				"नेपाली": 98,
				"मराठी": 99,
				"हिन्दी": 100,
				"বাংলা (বাংলাদেশ)": 101,
				"বাংলা (ভারত)": 102,
				"ગુજરાતી": 103,
				"தமிழ் (இந்தியா)": 104,
				"தமிழ் (இலங்கை)": 105,
				"தமிழ் (சிங்கப்பூர்)": 106,
				"தமிழ் (மலேஷியா)": 107,
				"తెలుగు": 108,
				"ಕನ್ನಡ": 109,
				"മലയാളം": 110,
				"සිංහල": 111,
				"ไทย": 112,
				"ລາວ": 113,
				"ქართულად": 114,
				"አማርኛ": 115,
				"ខ្មែរ": 116,
				"中文（中国）": 117,
				"中文（台灣）": 118,
				"中文（香港）": 119,
				"日本語": 120,
				"한국어": 121
			}
			)
			for __language, __LID in Dictation.LID, __languages := "", __i := 0
				__languages .= __language . "|", __i++
			Dictation.languages := RTrim(__languages, "|"), Dictation.LANGUAGES_MAXINDEX := __i

		}

	__New() {

		static __init := ""
		IfNotEqual, __init,, return __init
		__init := this

		if not (DllCall("Wininet.dll\InternetGetConnectedState", "Str", "0x40", "Int", 0)) ; INTERNET_CONNECTION_PROXY
			return !ErrorLevel:=-3

		RegRead, __regKey, HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\App Paths\Chrome.exe
		if (ErrorLevel)
			return !ErrorLevel:=-2

		__detectHiddenWindows := A_DetectHiddenWindows, __titleMatchMode := A_TitleMatchMode, __winDelay := A_WinDelay, __isCritical := A_IsCritical
		DetectHiddenWindows, Off
		SetTitleMatchMode, RegEx
		SetWinDelay, -1
		Critical

		run % """" . __regKey . """ --app=" . (__url:="chrome-extension://" . Dictation.ID . "/popup.html#progress"),, UseErrorLevel
		if (ErrorLevel)
			return !ErrorLevel:=-1

		WinWait % "^(" . __url . "|Dictation initializing...)$ ahk_exe chrome.exe",, 9
		if (ErrorLevel)
			return !ErrorLevel:=1
		this.AHKID := __AHKID := "ahk_id " . WinExist()

		WinSet, Style, +0x8C00000 ; WS_DISABLED
		WinGetPos,,, __w
		__w := (__w = 560) ? 561 : 560
		WinMove, % __AHKID,, % A_ScreenWidth//2-__w//2, % A_ScreenHeight//2-65//2, __w, 65
		WinWait % ".*%$ ahk_exe chrome.exe" . A_Space . __AHKID,, 2
		if (ErrorLevel)
			return !ErrorLevel:=1

		WinWait % ".*100%$" . A_Space . __AHKID
		if (Dictation.hideChromeInstance) {
			WinHide
			DetectHiddenWindows, On
		} else WinMove, % __AHKID,, % A_ScreenWidth-500,,, % A_ScreenHeight

		WinWait % Dictation.ID . A_Space . __AHKID,, 4
		if (ErrorLevel)
			return !ErrorLevel:=2

		Critical % __isCritical
		SetWinDelay % __winDelay
		SetTitleMatchMode % __titleMatchMode
		DetectHiddenWindows % __detectHiddenWindows

		sleep, 3000

	return this
	}

	__Delete() {
	__detectHiddenWindows := A_DetectHiddenWindows
	DetectHiddenWindows, On
		if (WinExist(this.AHKID))
			WinClose
	DetectHiddenWindows % __detectHiddenWindows
	}

	recognitionToogleState() {

	static __x := 0, __y := 1

		IfEqual, __x, %__y%, return
		__x := __y

		if (__f:=this.boundIterator) {

			SetTimer, % __f, off
			SetTimer, % __f, delete
			this.boundIterator := ""

		}

		__detectHiddenWindows := A_DetectHiddenWindows, __titleMatchMode := A_TitleMatchMode
		DetectHiddenWindows, On
		SetTitleMatchMode, 1

		WinMove, % this.AHKID,,,,, % A_ScreenHeight - __y
		WinWait % __y . A_Space . this.AHKID,, 2
		if (ErrorLevel) {
			if (WinExist(this.AHKID))
				WinClose
		return !ErrorLevel
		}
		DetectHiddenWindows % __detectHiddenWindows
		SetTitleMatchMode % __titleMatchMode

		if (this.recognizing:=__y) {
			__f := this.boundIterator := this.updateResult.bind(this)
			SetTimer, % __f, % Dictation.iteratorPeriod
		} else this.onResultFunc.call(this, this.lastInterimResult), this.lastInterimResultElapsedTime := 0, this.lastInterimResult := ""

	return true, __y := !__y
	}
	recognitionState() {
	return this.recognizing
	}
	setRecognitionLanguage(__language) {

		if not Dictation.LID.hasKey(__language)
			return !ErrorLevel:=-1

		__l := Dictation.LID[__language] + 1

		__detectHiddenWindows := A_DetectHiddenWindows
		DetectHiddenWindows, On

		WinGetPos,,, __w1,, % "ahk_id " . WinExist(this.AHKID)

			WinMove,,,,, % __w1 - (__l)
			WinGetPos,,, __w2
				sleep, 100
			WinMove,,,,, % __w1
			WinGetPos,,, __w1

		DetectHiddenWindows % __detectHiddenWindows

	return ErrorLevel:=!((__w1 - __w2 == __l) * 1), this.recognitionLanguage := __language
	}

	onInterimResult(__callback) {
		if (__callback.maxParams > 0 or (__callback:=Func(__callback)).maxParams > 0) {
			this.onInterimResultFunc := __callback
		return !ErrorLevel:=0
		}
			this.onInterimResultFunc := this.updateInterimResults
		return !ErrorLevel:=1
	}
	onResult(__callback) {
		if (__callback.maxParams > 0 or (__callback:=Func(__callback)).maxParams > 0) {
			this.onResultFunc := __callback
		return !ErrorLevel:=0
		}
			this.onResultFunc := this.saveToClipboard
		return !ErrorLevel:=1
	}

		interimResult {
			set {
			if (this.lastInterimResult == value)
				this.lastInterimResultElapsedTime += 0.5
			else this.lastInterimResult := value, this.lastInterimResultElapsedTime := 0
			this.waitForInterimResultTimeRemaining := this.interimResultTimeout - this.lastInterimResultElapsedTime
			this.onInterimResultFunc.call(this, this.lastInterimResult)
			}
		}
		updateResult() {
		__detectHiddenWindows := A_DetectHiddenWindows
		DetectHiddenWindows, On
			WinGetTitle, __winTitle, % this.AHKID
			this.interimResult := InStr(__winTitle, Dictation.url) ? "" : __winTitle
		DetectHiddenWindows % __detectHiddenWindows
		}

		updateInterimResults() {
		if (this.waitForInterimResultTimeRemaining) {
			TrayTip,, % this.lastInterimResult,, 0x1
		} else this.recognitionToogleState()
		}
		saveToClipboard(__result) {
		clipboard := __result
		}

}
