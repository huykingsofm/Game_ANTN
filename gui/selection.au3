;=======================================================Introduction==========================================
; Author: 			Le Ngoc Huy - UIT K12
; Contact:
;	Email : 		huykingsofm@gmail.com
;	Edu Email: 		17520074@gm.uit.edu.vn
;	Github: 		https://github.com/huykingsofm/Game_ANTN.git
;
; File Name: 		selection.au3
; Language:			AutoIT
; Modified Date:	December 22 2018
; Purpose:			Lauch selection form to select operation
; PUPBLIC FUNCTION:
;	start_selection()
;=============================================================================================================
;
#include-once
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include "sotaidoanchu.au3"

;============================================================================
; Func start_selection()
; Purpose: Create a GUI which provide a option to choose some game
;
; Parameters:
;   + no-parameter
; Return:
;	+ no return
;=============================================================================
;start_selection()
Func start_selection()
   #Region ### Set Constant
   $W_WINDOW = 400
   $H_WINDOW = 300

   $PX_WINDOW = ($SCREEN[2] - $W_WINDOW) / 2
   $PY_WINDOW = ($SCREEN[3] - $H_WINDOW) / 2

   $W = $W_WINDOW
   $H = $H_WINDOW/2
   $COLOR_sotaidoanchu = 0xAAAAAA
   $COLOR_back = 0x555555

   #Region ### Create GUI
   $selection = GUICreate("selection", $W_WINDOW, $H_WINDOW, $PX_WINDOW, $PY_WINDOW, $WS_POPUP)
   GUISetBkColor(0x888888)

   $sotaidoanchu = GUICtrlCreateLabel("So Tài Đoán Chữ", 0, 0, $W, $H, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetFont(-1, 22, 400, 0, "Arial Bold")
   GUICtrlSetBkColor(-1, $COLOR_sotaidoanchu)

   $back = GUICtrlCreateLabel("BACK", 0, $H, $W, $H, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetFont(-1, 22, 400, 0, "Arial Rounded MT Bold")
   GUICtrlSetBkColor(-1, $COLOR_back)
   GUICtrlSetColor(-1, 0xEEEEEE)

   WinSetTrans($selection, "", 0)

   GUISetState(@SW_SHOW)

   __fade($selection, 1)
   #EndRegion ### END Koda GUI section ###

   $fOverSotaidoanchu = False
   $fOverBack = False

   $flag = 0

   While 1
	  Local $cursor = GUIGetCursorInfo($selection)

	  __eventOnCover($sotaidoanchu, $cursor, 0xAAAAAA, 0, $H, $W, $H, 22, False, $fOverSotaidoanchu)
	  __eventOnCover($back, $cursor, 0x555555, 0, $H, $W, $H, 22, False, $fOverBack)

	  Local $click = __controlOnClick($cursor)

	  Switch $click
		 Case $back
			__fade($selection, 0)
			GUIDelete($selection)
			$flag = 1
			ExitLoop
		 Case $sotaidoanchu
			__fade($selection, 0)
			GUIDelete($selection)
			$flag = 3
			ExitLoop
	  EndSwitch
   WEnd

   If $flag = 1 Then
	  start_launcher()
   ElseIf $flag = 3 Then
	  start_import()
   EndIf
EndFunc
