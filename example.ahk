#NoEnv
#SingleInstance ignore
#KeyHistory 0
SetWorkingDir % A_ScriptDir
SendMode, Input
; #Warn
#Warn, ClassOverwrite, Off ; 1.1.27.00+


#Include %A_ScriptDir%\Class.Dictation.ahk

global Sr, Doc
if not (Sr:=new Dictation()) {
	MsgBox, 64,, Could not initialize Dictation.
ExitApp
} else Sr.onInterimResult("updateInterimResults"), Sr.onResult("saveToClipboard"), Sr.setRecognitionLanguage("Français")

Gui, 1:Margin, 10, 10
Gui, 1:Add, DropDownList, % "vdropDownListControl Section xm ym w150 R10 Sort gsetRecognitionLanguage", % Sr.languages
GuiControl, 1:ChooseString, dropDownListControl, % Sr.recognitionLanguage
Gui, 1:Add, Button, vbuttonControl ys w160 h20 grecognitionToogleState, Start/stop &recognition
Gui, 1:Add, ActiveX, vDoc xm y39 w710 h100, about:<!DOCTYPE html><meta http-equiv="X-UA-Compatible" content="IE=edge">
Doc.document.Open()
html =
(
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge"><meta charset="utf-8" />
<title>HTMLFile</title>
<style>
.s2 {
vertical-align: sub;
font-size: 9px;
color: #666;
}
</style>
</head>
<body><div class="C" style="padding: 15px;"></div></body>
</html>
)
Doc.document.Write(html), Doc.document.Close()
sleep, 100
Gui, 1:Add, Progress, vprogressControl xm wp h10 range0-100, 100
Gui, 1:Show, AutoSize, % A_ScriptName
OnExit, handleExit
return


setRecognitionLanguage:
GuiControl, 1:Enable0, % A_GuiControl
GuiControl, 1:Enable0, buttonControl
GuiControlGet, var,, % A_GuiControl
Sr.setRecognitionLanguage(var)
GuiControl, 1:Enable1, buttonControl
GuiControl, 1:Enable1, % A_GuiControl
return

recognitionToogleState:
GuiControl, 1:Enable0, % A_GuiControl
var := Sr.recognizing
Sr.recognitionToogleState()
if (ErrorLevel) {
	MsgBox, 64,, Could not interact with Dictation.`r`nThe program will exit.
ExitApp
}
GuiControl, 1:Enable%var%, dropDownListControl
GuiControl, 1:Enable1, % A_GuiControl
return

GuiClose:
ExitApp
handleExit:
Sr := ""
ExitApp


updateInterimResults(__dictation, __lastInterimResult) {

GuiControl, 1:, progressControl, % (__dictation.waitForInterimResultTimeRemaining*100)//__dictation.interimResultTimeout

	if (__dictation.waitForInterimResultTimeRemaining) {

		VarSetCapacity(__str, 110*(__interimResultsOutputArray:=StrSplit(__lastInterimResult, A_Space)).length())

			Loop % __interimResultsOutputArray.length()
				__str .= "<span class=""s1"">" . __interimResultsOutputArray[ a_index ] . "</span><span class=""s2""> " . a_index . " </span>"

				Doc.document.getElementsByClassName("C").0.innerHTML := __str

	} else {
		__dictation.recognitionToogleState()
		GuiControl, 1:Enable, dropDownListControl
	}

}
saveToClipboard(__dictation, __result) {
	clipboard := __result
	TrayTip, % A_ScriptName, Result has been copied to clipboard.
}