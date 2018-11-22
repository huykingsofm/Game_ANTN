#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

Func __displayAbout()
   $image = "E:\huykingsofm\card_ANTNLauncher.jpg"
   $aRet = _GetWHI($image)

   $W_WINDOW = $aRet[0]
   $H_WINDOW = $aRet[1]
   $PX_WINDOW = ($SCREEN[2] - $W_WINDOW) / 2
   $PY_WINDOW = ($SCREEN[3] - $H_WINDOW) / 2
   #Region ### START Koda GUI section ### Form=
   $about = GUICreate("Form1", $W_WINDOW, $H_WINDOW, $PX_WINDOW, $PY_WINDOW,$WS_POPUP)
   $card = GUICtrlCreatePic($image, 0, 0, $W_WINDOW, $H_WINDOW)
   WinSetTrans($about, "", 0)
   GUISetState(@SW_SHOW)
   __fade($about, 1)
   #EndRegion ### END Koda GUI section ###

   While 1
	  $cursor = GUIGetCursorInfo($about)
	  If $cursor[2] = 1 Then
		 __fade($about, 0)
		 $cursor[2] = 0
		 GUIDelete($about)
		 ExitLoop
	  EndIf
   WEnd
EndFunc