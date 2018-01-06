Class Dictation {

	; ==========================================
	static ID := "" ; <<<< put here the ID of the extension
	; ==========================================

		, url := "https://dictation.io"

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
				"Bahasa Indonesia": 2,
				"Bahasa Melayu": 3,
				"Català": 4,
				"Čeština": 5,
				"Dansk": 6,
				"Deutsch": 7,
				"Australia": 8,
				"Canada": 9,
				"India": 10,
				"New Zealand": 11,
				"South Africa": 12,
				"English": 13,
				"United States": 14,
				"Argentina": 15,
				"Bolivia": 16,
				"Chile": 17,
				"Colombia": 18,
				"Costa Rica": 19,
				"Ecuador": 20,
				"El Salvador": 21,
				"Español": 22,
				"Estados Unidos": 23,
				"Guatemala": 24,
				"Honduras": 25,
				"México": 26,
				"Nicaragua": 27,
				"Panamá": 28,
				"Paraguay": 29,
				"Perú": 30,
				"Puerto Rico": 31,
				"República Dominicana": 32,
				"Uruguay": 33,
				"Venezuela": 34,
				"Euskara": 35,
				"Filipino": 36,
				"Français": 37,
				"Galego": 38,
				"हिन्दी": 39,
				"Hrvatski": 40,
				"IsiZulu": 41,
				"Íslenska": 42,
				"Italiano": 43,
				"Svizzera": 44,
				"Lietuvių": 45,
				"Magyar": 46,
				"Nederlands": 47,
				"Norsk bokmål": 48,
				"Polski": 49,
				"Brasil": 50,
				"Portugal": 51,
				"Română": 52,
				"Slovenščina": 53,
				"Slovenčina": 54,
				"Suomi": 55,
				"Svenska": 56,
				"Tiếng Việt": 57,
				"ภาษาไทย": 58,
				"Türkçe": 59,
				"Ελληνικά": 60,
				"български": 61,
				"Русский": 62,
				"Српски": 63,
				"Українська": 64,
				"한국어": 65,
				"普通话 (中国大陆)": 66,
				"普通话 (香港)": 67,
				"中文 (台灣)": 68,
				"粵語 (香港)": 69,
				"日本語": 70
			}
			)
			for __language, __LID in Dictation.LID, __languages := "", __i := 0
				__languages .= __language . "|", __i++
			Dictation.languages := RTrim(__languages, "|"), Dictation.LANGUAGES_MAXINDEX := __i

			Dictation.iteratorPeriod := 400

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

		__titleMatchMode := A_TitleMatchMode, __detectHiddenWindows := A_DetectHiddenWindows, __winDelay := A_WinDelay, __isCritical := A_IsCritical
		SetTitleMatchMode, RegEx
		DetectHiddenWindows, Off
		SetWinDelay, -1
		Critical

		run % """" . __regKey . """ --app=" . (__url:="chrome-extension://" . Dictation.ID . "/popup.html#progress"),, UseErrorLevel
		if (ErrorLevel)
			return !ErrorLevel:=-1

		WinWait % "^(" . __url . "|Dictation initializing...)$ ahk_exe chrome.exe"
		this.AHKID := __AHKID := "ahk_id " . WinExist()

		WinSet, Style, +0x8C00000 ; WS_DISABLED
		WinGetPos,,, __w
		__w := (__w = 560) ? 561 : 560
		WinMove, % __AHKID,, % A_ScreenWidth//2-__w//2, % A_ScreenHeight//2-65//2, __w, 65
		WinWait % ".*%$ ahk_exe chrome.exe" . A_Space . __AHKID,, 2
		if (ErrorLevel)
			return !ErrorLevel:=1

		WinWait % ".*100%$" . A_Space . __AHKID
		WinMove, % __AHKID,, % A_ScreenWidth-1,,, % A_ScreenHeight
		WinHide
		DetectHiddenWindows, On

		WinWait % Dictation.ID . A_Space . __AHKID,, 4
		if (ErrorLevel)
			return !ErrorLevel:=2

		Critical % __isCritical
		SetWinDelay % __winDelay
		DetectHiddenWindows % __detectHiddenWindows
		SetTitleMatchMode % __titleMatchMode

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

		__detectHiddenWindows := A_DetectHiddenWindows
		DetectHiddenWindows, On

		WinMove, % this.AHKID,,,,, % A_ScreenHeight - __y
		WinWait % __y . A_Space . this.AHKID,, 2
		if (ErrorLevel) {
			if (WinExist(this.AHKID))
				WinClose
		return !ErrorLevel
		}
		DetectHiddenWindows % __detectHiddenWindows

		if (this.recognizing:=__y) {
			__f := this.boundIterator := this.updateResult.bind(this)
			SetTimer, % __f, % Dictation.iteratorPeriod
		} else this.onResultFunc.bind(this, this.lastInterimResult).call(), this.lastInterimResultElapsedTime := 0, this.lastInterimResult := ""

	return true, __y := !__y
	}
	recognitionState() {
	return this.recognizing
	}
	setRecognitionLanguage(__language) {

		; if not (((__language:=abs(__language)) >= 1) and __language <= Dictation.LANGUAGES_MAXINDEX)
			; return !ErrorLevel:=3

		if not Dictation.LID.hasKey(__language)
			return !ErrorLevel:=3

		__l := Dictation.LID[__language]

		__detectHiddenWindows := A_DetectHiddenWindows
		DetectHiddenWindows, On

		WinGetPos,,, __w1,, % "ahk_id " . WinExist(this.AHKID)

			WinMove,,,,, % __w1 - (__l)
			WinGetPos,,, __w2
				sleep, 100
			WinMove,,,,, % __w1
			WinGetPos,,, __w1

		DetectHiddenWindows % __detectHiddenWindows

	return ErrorLevel:=!((__w1 - __w2 == __l) * 4), this.recognitionLanguage := __language
	}

	onInterimResult(__callback) {
		if (__callback.maxParams > 0 or (__callback:=Func(__callback)).maxParams > 0) {
			this.onInterimResultFunc := __callback
		return !ErrorLevel:=0
		}
			this.onInterimResultFunc := this.updateInterimResults
		return !ErrorLevel:=6
	}
	onResult(__callback) {
		if (__callback.maxParams > 0 or (__callback:=Func(__callback)).maxParams > 0) {
			this.onResultFunc := __callback
		return !ErrorLevel:=0
		}
			this.onResultFunc := this.saveToClipboard
		return !ErrorLevel:=7
	}


		iteratorPeriod {
			set {
				if (value < 250)
			return Dictation._iteratorPeriod := 250
			return Dictation._iteratorPeriod := value
			}
			get {
			return Dictation._iteratorPeriod
			}
		}
		interimResult {
			set {
			if (this.lastInterimResult == value)
				this.lastInterimResultElapsedTime += 0.5
			else this.lastInterimResult := value, this.lastInterimResultElapsedTime := 0
			this.waitForInterimResultTimeRemaining := this.interimResultTimeout - this.lastInterimResultElapsedTime
			this.onInterimResultFunc.bind(this, this.lastInterimResult).call()
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
