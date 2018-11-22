;=======================================================Introduction==========================================
; Author: 			Le Ngoc Huy - UIT K12
; Contact:
;	Email : 		huykingsofm@gmail.com
;	Edu Email: 		17520074@gm.uit.edu.vn
;	Github: 		https://github.com/huykingsofm/Game_ANTN.git
;
; File Name: 		displayNotification.au3
; Language:			AutoIT
; Modified Date:	Dec 10 2018
; Purpose:			Provide a notification message window
;
; PUBLIC FUNCTION:
;	__displayNotification(flag, title, msg)
;=============================================================================================================
;
#include-once
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

;============================================================================
; Func __displayNotification(flag, title, msg)
; Purpose: Display a window to notify user with a title and message
;
; Parameters:
;	+ flag:		$__NOTIFY_ERROR,    $__NOTIFY_WARNING
;	+ title:	a title of window
;	+ msg:		a message will be notified
; Return:
;	+ no return
;=============================================================================
Const $__NOTIFY_ERROR   = 1
Const $__NOTIFY_WARNING = 2


Func __displayNotification($flag, $title, $msg)
   $W_BUTTON = 80
   $H_BUTTON = 66

   #Region # Create GUI
   $notification = GUICreate("Notification", 352, 215, 518, 270, BitOR($WS_MINIMIZEBOX,$WS_POPUP,$WS_GROUP))
   GUISetBkColor(0xDDDDDD)

   If $flag = $__NOTIFY_ERROR Then
	  $PX_CLOSE = 135
	  $PY_CLOSE = 135
	  $close = GUICtrlCreateLabel("CLOSE", $PX_CLOSE, $PY_CLOSE, $W_BUTTON, $H_BUTTON, BitOR($SS_CENTER,$SS_CENTERIMAGE))
	  GUICtrlSetBkColor(-1, 0x005555)
	  GUICtrlSetColor(-1,0xFFFFFF)
	  GUICtrlSetFont(-1, 15, 400, 0, "Arial Rounded MT Bold")

	  $PX_OK = 0
	  $PY_OK = 0
	  $ok = ""
   ElseIf $flag = $__NOTIFY_WARNING Then
	  $PX_OK = 50
	  $PY_OK = 135
	  $ok = GUICtrlCreateLabel("OK", $PX_OK, $PY_OK, $W_BUTTON, $H_BUTTON, BitOR($SS_CENTER,$SS_CENTERIMAGE))
	  GUICtrlSetBkColor(-1, 0x005555)
	  GUICtrlSetColor(-1,0xFFFFFF)
	  GUICtrlSetFont(-1, 15, 400, 0, "Arial Rounded MT Bold")

	  $PX_CLOSE = 220
	  $PY_CLOSE = 135
	  $close = GUICtrlCreateLabel("CLOSE", $PX_CLOSE, $PY_CLOSE, $W_BUTTON, $H_BUTTON, BitOR($SS_CENTER,$SS_CENTERIMAGE))
	  GUICtrlSetBkColor(-1, 0x005555)
	  GUICtrlSetColor(-1,0xFFFFFF)
	  GUICtrlSetFont(-1, 15, 400, 0, "Arial Rounded MT Bold")
   EndIf

   $Label1 = GUICtrlCreateLabel($title, 0, 0, 352, 53, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetFont(-1, 22, 400, 0, "Arial Bold")
   GUICtrlSetBkColor(-1, 0x005555)
   GUICtrlSetColor(-1,0xFFFFFF)

   $Label2 = GUICtrlCreateLabel($msg, 0, 53, 352, 80, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetFont(-1, 15, 400, 0, "Sogoe UI Bold")
   GUICtrlSetColor(-1,0)
   GUICtrlSetBkColor(-1, 0xDDDDDD)
   GUISetState(@SW_SHOW)
   #EndRegion ### END Koda GUI section ###

   $fOverClose = False
   $fOverOk = False
   While 1
	  $cursor = GUIGetCursorInfo($notification)
	  __eventOnCover($close, $cursor, 0x005555, $PX_CLOSE, $PY_CLOSE, $W_BUTTON, $H_BUTTON, 15, True, $fOverClose)
	  __eventOnCover($ok, $cursor, 0x005555, $PX_OK, $PY_OK, $W_BUTTON, $H_BUTTON, 15, True, $fOverOk)

	  $click = __controlOnClick($cursor)
	  $cursor[2] = 0
	  If ($click = $close) Then
		 GUIDelete($notification)
		 Return False
	  ElseIf $click = $ok Then
		 GUIDelete($notification)
		 Return True
	  EndIf
   WEnd
EndFunc