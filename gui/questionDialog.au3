#include-once
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Sound.au3>
#include "utilities.au3"
#include "DisplayNotification.au3"
#include <array.au3>


Func __questionDialog($question, $ans, $soundPath)
   $question = $question = Default ? "ĐIỀN CÂU HỎI HỘ ĐI" : $question

   $breakedQuestion = __breakText($question, 50)
   $breakedAnswer = __breakText($ans, 50)

   $nLine = $breakedQuestion[0] > $breakedAnswer[0] ? $breakedQuestion[0] : $breakedAnswer[0]

   $W_ALIGN = 80
   $H_ALIGN = 10

   $H_TITLE = 70

   $H_LINE = 40

   $H_TEXT = $nLine * $H_LINE

   $W_OK = 120
   $H_OK = 50

   $PX_OK = 50
   $PY_OK = $H_TITLE + $H_TEXT + $H_ALIGN

   $W_CANCEL = $W_OK
   $H_CANCEL = $H_OK
   $PX_CANCEL = 250
   $PY_CANCEL = $PY_OK

   $W_SWITCH = $W_OK
   $H_SWITCH = $H_OK
   $PX_SWITCH = 450
   $PY_SWITCH = $PY_OK

   $W_SOUND = $W_OK
   $H_SOUND = $H_OK
   $PX_SOUND = 650
   $PY_SOUND = $PY_OK

   $W_WINDOW = $W_ALIGN + $W_OK + $W_ALIGN + $W_CANCEL + $W_ALIGN + $W_SWITCH + $W_ALIGN + $W_SOUND + $W_ALIGN
   $H_WINDOW = $H_TITLE + $H_TEXT + $H_ALIGN + $W_OK + $H_ALIGN
   $W_LINE = $W_WINDOW

   $PX_WINDOW = ($SCREEN[2] - $W_WINDOW) / 2
   $PY_WINDOW = ($SCREEN[3] - $H_WINDOW) / 2


   Local $COLOR_BUTTON = 0xDDDDDD

   Local $COLOR_WINDOW = 0xEEEEEE

   $dialog = GUICreate("dialog", $W_WINDOW, $H_WINDOW, $PX_WINDOW, $PY_WINDOW, BitOr($WS_POPUP, $WS_BORDER))
   GUISetBkColor($COLOR_WINDOW)
   GUISetFont(9, 300, 0, "Consolas")

   #Region ### Create Title and Button
   $Title = GUICtrlCreateLabel("CÂU HỎI", 0, 0, $W_WINDOW, $H_TITLE, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetFont(-1, 22, 400, 0, "Arial Bold")
   GUICtrlSetColor(-1, 0x000000)
   GUICtrlSetBkColor(-1, $COLOR_WINDOW)

   Local $message[$nLine]
   For $i = 0 To $nLine - 1
	  $message[$i] = GUICtrlCreateLabel("", 0, $H_TITLE + $i * $H_LINE, $W_LINE, $H_LINE, BitOR($SS_CENTER,$SS_CENTERIMAGE))
	  GUICtrlSetFont(-1, 20, 400, 0, "Arial Bold")
	  GUICtrlSetColor(-1, 0x0)
	  GUICtrlSetBkColor(-1, $COLOR_WINDOW)
   Next
   GUICtrlSetData($message[Int($nLine/2)], "Hello mother fucker !!!")

   $OK = GUICtrlCreateLabel("OK", $PX_OK, $PY_OK, $W_OK, $H_OK, BitOR($SS_CENTER,$SS_CENTERIMAGE, $WS_BORDER))
   GUICtrlSetFont(-1, 16, 400, 0, "Arial Bold")
   GUICtrlSetColor(-1, 0x0)
   GUICtrlSetBkColor(-1, $COLOR_BUTTON)

   $cancel = GUICtrlCreateLabel("CANCEL", $PX_CANCEL, $PY_CANCEL, $W_CANCEL, $H_CANCEL, BitOR($SS_CENTER,$SS_CENTERIMAGE, $WS_BORDER))
   GUICtrlSetFont(-1, 16, 400, 0, "Arial Bold")
   GUICtrlSetColor(-1, 0x0)
   GUICtrlSetBkColor(-1, $COLOR_BUTTON)


   $switch = GUICtrlCreateLabel("QUESTION", $PX_SWITCH, $PY_SWITCH, $W_SWITCH, $H_SWITCH, BitOR($SS_CENTER,$SS_CENTERIMAGE, $WS_BORDER))
   GUICtrlSetFont(-1, 16, 400, 0, "Arial Bold")
   GUICtrlSetColor(-1, 0x0)
   GUICtrlSetBkColor(-1, $COLOR_BUTTON)


   $sound = GUICtrlCreateLabel("SOUND", $PX_SOUND, $PY_SOUND, $W_SOUND, $H_SOUND, BitOR($SS_CENTER,$SS_CENTERIMAGE, $WS_BORDER))
   GUICtrlSetFont(-1, 16, 400, 0, "Arial Bold")
   GUICtrlSetColor(-1, 0x0)
   GUICtrlSetBkColor(-1, $COLOR_BUTTON)

   WinSetTrans($question, "", 0)

   GUISetState(@SW_SHOW)

   __fade($question, 1)

   $fOverOK = False
   $fOverCancel = False
   $fOverAnswer = False
   $fOverSound = False

   $flagSwitch = 1
   $flagShowed = 0

   If $soundPath <> "" Then
	  $aSound = _SoundOpen($soundPath)
   EndIf

   While 1
	  $cursor = GUIGetCursorInfo($dialog)

	  __eventOnCover($OK, $cursor, $COLOR_BUTTON, $PX_OK, $PY_OK, $W_OK, $H_OK, 16, True, $fOverOK)
	  __eventOnCover($cancel, $cursor, $COLOR_BUTTON, $PX_CANCEL, $PY_CANCEL, $W_CANCEL, $H_CANCEL, 16, True, $fOverCancel)
	  __eventOnCover($switch, $cursor, $COLOR_BUTTON, $PX_SWITCH, $PY_SWITCH, $W_SWITCH, $H_SWITCH, 16, True, $fOverAnswer)
	  __eventOnCover($sound, $cursor, $COLOR_BUTTON, $PX_SOUND, $PY_SOUND, $W_SOUND, $H_SOUND, 16, True, $fOverSound)

	  $cursor = GUIGetCursorInfo($dialog)
	  $control = __controlOnClick($cursor)

	  Switch $control
		 Case $OK
			__fade($question, 0)
			GUIDelete($dialog)
			If $flagShowed = 0 Then
			   Return 2
			Else
			   Return 0
			EndIf
		 Case $cancel
			__fade($question, 0)
			GUIDelete($dialog)
			_SoundClose($aSound)
			If $flagShowed = 0 Then
			   Return 2
			Else
			   Return 1
			EndIf
		 Case $switch
			If $flagSwitch = 0 Then
			   If ($ans = Default) Then
				  Sleep($SOFT_TIME)
				  __displayNotification($__NOTIFY_ERROR, "BỚT NGÁO ĐÊ" , "Có Câu Trả Lời Đéo")
			   Else
				  For $i = 1 To $nLine
					 If $i <= $breakedAnswer[0] Then
						GUICtrlSetData($message[$i - 1], $breakedAnswer[$i])
					 Else
						GUICtrlSetData($message[$i - 1] , "")
					 EndIf
				  Next

				  $flagSwitch = 1
				  GUICtrlSetData($switch, "QUESTION")
			   EndIf
			   Sleep($SOFT_TIME)
			Else
			   For $i = 1 To $nLine
				  If $i <= $breakedQuestion[0] Then
					 GUICtrlSetData($message[$i - 1], $breakedQuestion[$i])
				  Else
					 GUICtrlSetData($message[$i - 1] , "")
				  EndIf
			   Next

			   GUICtrlSetData($switch, "ANSWER")
			   Sleep($SOFT_TIME)
			   $flagSwitch = 0
			   $flagShowed = 1
			EndIf
		 Case $sound
			If $soundPath = Default Then
			   Sleep($SOFT_TIME)
			   __displayNotification($__NOTIFY_ERROR, "BỚT NGÁO ĐÊ" , "Có Cài Âm Thanh Đâu Mà Phát -_-")
			Else
			   _SoundPlay($aSound)
			EndIf
			Sleep(200)
	  EndSwitch
   WEnd
EndFunc