;=======================================================Introduction==========================================
; Author: 			Le Ngoc Huy - UIT K12
; Contact:
;	Email : 		huykingsofm@gmail.com
;	Edu Email: 		17520074@gm.uit.edu.vn
;	Github: 		https://github.com/huykingsofm/Game_ANTN.git
;
; File Name: 		laucher.au3
; Language:			AutoIT
; Modified Date:	Dec 22 2018
; Purpose: 	Provide a procedure which run a Laucher
;
; PUPBLIC FUNCTION:
;	start_laucher()
;=============================================================================================================

; Include some nessessary libraries
#include-once
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include "gui/selection.au3"
#include "gui/about.au3"

;============================================================================
; Func start_launcher()
; Purpose: Provide a connection to game manager
;
; Parameters:
;	+ no parameter
; Return:
;	+ no return
;=============================================================================

start_launcher()

Func start_launcher()
   #Region LOCAL CONSTANT

   $W_WINDOW = 600
   $H_WINDOW = 440

   $W_BUTTON = 130
   $H_BUTTON = 100

   $PX_WINDOW = ($SCREEN[2] - $W_WINDOW) / 2
   $PY_WINDOW = ($SCREEN[3] - $H_WINDOW) / 2

   $C_WINDOW = 0x222222
   $COLOR_BUTTON = 0xDDDDDD

   $PY = 250

   $PX_LAUCH = Int($W_WINDOW / 4 - $W_BUTTON/2)
   $PX_CLOSE = Int($W_WINDOW * 3/4 - $W_BUTTON/2)

   #EndRegion

   #Region ### START Koda GUI section ### Form=
   $launcher = GUICreate("launcher", $W_WINDOW, $H_WINDOW, $PX_WINDOW, $PY_WINDOW, $WS_POPUP)
   GUISetBkColor($C_WINDOW)

   $Welcome = GUICtrlCreateLabel("ANTN Game Launcher", 0, 0, $W_WINDOW, 250, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetColor(-1, 0xEEEEEE)
   GUICtrlSetFont(-1, 60, 400, 0, "Bahnschrift Condensed")

   $about = GUICtrlCreateLabel("designed by Le Ngoc Huy - UIT K12                      ", 0, 160, $W_WINDOW, 50, BitOr($SS_RIGHT, $SS_CENTERIMAGE))
   GUICtrlSetColor(-1, 0xEEEEEE)
   GUICtrlSetFont(-1, 20, 400, 0, "Bahnschrift Condensed")

   $launch = GUICtrlCreateLabel("LAUNCH", $PX_LAUCH, $PY, $W_BUTTON, $H_BUTTON, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetFont(-1, 22, 400, 0, "Arial Rounded MT Bold")
   GUICtrlSetBkColor(-1, $COLOR_BUTTON)

   $close = GUICtrlCreateLabel("CLOSE", $PX_CLOSE, $PY, $W_BUTTON, $H_BUTTON, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetFont(-1, 22, 400, 0, "Arial Rounded MT Bold")
   GUICtrlSetBkColor(-1, $COLOR_BUTTON)

   WinSetTrans($launcher, "", 0)
   GUISetState(@SW_SHOW)
   #EndRegion ### END Koda GUI section ###

   __fade($launcher, 1)
   ; If Connection is not ready, show laucher with message "Connecting..."
   ; Otherwise, start laucher without that message

   $flag = 0

   $fOverLaunch = False
   $fOverClose = False

   While 1
	  $cursor = GUIGetCursorInfo($launcher)

	  ; Change status of label if cursor covers it
	  __eventOnCover($launch, $cursor, $COLOR_BUTTON, $PX_LAUCH, $PY, $W_BUTTON, $H_BUTTON, 22, True, $fOverLaunch)
	  __eventOnCover($close, $cursor, $COLOR_BUTTON, $PX_CLOSE, $PY, $W_BUTTON, $H_BUTTON, 22, True, $fOverClose)


	  ; Get and solve click event
	  $click = __controlOnClick($cursor)
	  Switch $click
		 Case $launch
			__fade($launcher, 0)
			$flag = 1
			ExitLoop
		 Case $close
			__fade($launcher, 0)
			$flag = 0
			ExitLoop
		 Case $about
			__fade($launcher, 0)
			__displayAbout()
			__fade($launcher, 1)
		 Case $welcome
			__fade($launcher, 0)
			__displayAbout()
			__fade($launcher, 1)
	  EndSwitch
   WEnd

   GUIDelete($launcher)
   If $flag = 1 Then
	  start_selection()
   EndIf
EndFunc