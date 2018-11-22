;=======================================================Introduction==========================================
; Author: 			Le Ngoc Huy - UIT K12
; Contact:
;	Email : 		huykingsofm@gmail.com
;	Edu Email: 		17520074@gm.uit.edu.vn
;	Github: 		https://github.com/huykingsofm/Game_ANTN.git
;
; File Name: 		sotaidoanchu.au3
; Language:			AutoIT
; Modified Date:	Dec 22 2018
; Purpose: 	Provide a GamePlay of sotaidoanchu
; PUPBLIC FUNCTION:
;	start_import()
;	start_sotaidoanchu()
;	__readGameFile_sotaidoanchu($gamePath)
;	__execAction(result, ByRef curTurn, ByRef log, tableSize, x, y)
;	__readGameFile_sotaidoanchu($gamePath)
; 	__changeState(iTurn, curTurn, turn, tableSize, log, cell, Byref colorCell, scoreTeam1, scoreTeam2, color1, color2, color_cell)
;=============================================================================================================

; Include some nessessary libraries
#include-once
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Array.au3>
#include "questionDialog.au3"
#include "displayNotification.au3"

;============================================================================
; Func start_import()
; Purpose: import game data
;
; Parameters:
;	+ no parameter
; Return:
;	+ no return
;=============================================================================

Func start_import()

   $W_WINDOW = 500
   $H_WINDOW = 300

   $W_BUTTON = 130
   $H_BUTTON = 100

   $PX_WINDOW = ($SCREEN[2] - $W_WINDOW) / 2
   $PY_WINDOW = ($SCREEN[3] - $H_WINDOW) / 2

   $COLOR_BUTTON = 0xDDDDDD

   $PX_START = 75
   $PX_BACK = 295
   $PY = 150
   $H_BUTTON = 75

   $import = GUICreate("import", $W_WINDOW, $H_WINDOW, $PX_WINDOW, $PY_WINDOW, $WS_POPUP)
   GUISetBkColor(0x333333)
   $title = GUICtrlCreateLabel("IMPORT", 0, 10, 500, 100, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetColor(-1, 0xFFFFFF)
   GUICtrlSetFont(-1, 40, 400, 0, "Bahnschrift Condensed")

   $pathInput = GUICtrlCreateInput("", 25, 100, 370, 23)
   GUICtrlSetBkColor(-1, 0xFFFFFF)
   GUICtrlSetFont(-1, 13, 500, Default, "Arial", 5)
   GUICtrlSendMsg(-1, $EM_SETCUEBANNER, False, "Enter path of game")

   $browse = GUICtrlCreateLabel("Browse", 400, 96, 80, 30, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetBkColor(-1, $COLOR_BUTTON)
   GUICtrlSetColor(-1, 0x000000)
   GUICtrlSetFont(-1, 13, 400, 0, "Arial Rounded MT Bold")

   $start = GUICtrlCreateLabel("START", $PX_START, $PY, $W_BUTTON, $H_BUTTON, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetFont(-1, 22, 400, 0, "Arial Rounded MT Bold")
   GUICtrlSetBkColor(-1, $COLOR_BUTTON)

   $back = GUICtrlCreateLabel("BACK", $PX_BACK, $PY, $W_BUTTON, $H_BUTTON, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetFont(-1, 22, 400, 0, "Arial Rounded MT Bold")
   GUICtrlSetBkColor(-1, $COLOR_BUTTON)

   ControlFocus($import, "", $title)
   WinSetTrans($import, "", 0)

   GUISetState(@SW_SHOW)
   __fade($import, 1)


   $fOverBrowse = False
   $fOverStart = False
   $fOverBack = False
   $fDirect = 0

   $hFile = FileOpen(@ScriptDir & "\.temp", $FO_READ)
   $gamePath = FileReadLine($hFile)
   GUICtrlSetData($pathInput, $gamePath)
   FileClose($hFile)

   While 1
	  $cursor = GUIGetCursorInfo($import)
	  __eventOnCover($browse, $cursor, $COLOR_BUTTON, 400, 95, 80, 30, 13, True, $fOverBrowse)
	  __eventOnCover($start, $cursor, $COLOR_BUTTON, $PX_START, $PY, $W_BUTTON, $H_BUTTON, 22, True, $fOverStart)
	  __eventOnCover($back, $cursor, $COLOR_BUTTON, $PX_BACK, $PY, $W_BUTTON, $H_BUTTON, 22, True, $fOverBack)

	  $control = __controlOnClick($cursor)
	  Switch($control)
	  Case $browse
			$initDir = $gamePath = "" ? @MyDocumentsDir : $gamePath;
			$path = FileOpenDialog("Choose game file", $initDir & "\", "Game files(*.game) | All File (*.*)")
			If ($path <> "") Then
			   GUICtrlSetData($pathInput, $path)
			EndIf
		 Case $start
			$gamePath = GUICtrlRead($pathInput)
			If ($gamePath = "") Then
			   __displayNotification("ERROR", "You must choose a file")
			Else
			   ; read File Game and check errors
			   ; __readGameFile_sotaidoanchu() is in utilities.au3
			   ; If File Game is valid, using temp file to store its path.

			   $game = __readGameFile_sotaidoanchu($gamePath)
			   $error = @error
			   Sleep($SOFT_TIME)
			   If $error = -1 Then
				  __displayNotification($__NOTIFY_ERROR, "ERROR", "An error occurs when reading file")
			   Else
				  If $error > 0 Then
					 Sleep($SOFT_TIME)
					 $a = __displayNotification($__NOTIFY_WARNING, "WARNING", "Sound path " & $error & " is invalid")
					 Sleep($SOFT_TIME)
					 If $a = False Then
						ContinueLoop
					 EndIf
				  EndIf
				  $hFile = FileOpen(@ScriptDir & "\.temp", $FO_OVERWRITE)
				  FileWrite($hFile, $gamePath)
				  FileClose($hFile)

				  $fDirect = 1
				  ExitLoop
			   EndIf
			EndIf
		 Case $back
			$fDirect = 2
			ExitLoop
		 Case 0
			ControlFocus($import, "", $title)
	  EndSwitch
   WEnd

   __fade($import, 0)
   GUIDelete($import)

   If ($fDirect = 1) Then
	  start_sotaidoanchu($game)
   ElseIf $fDirect = 2 Then
	  start_selection()
   EndIf
EndFunc

;============================================================================
; Func start_sotaidoanchu(game)
; Purpose: Create a gamePlay of sotaidoanchu with a game properties
;
; Parameters:
;	game 	: 	array returned by __readFileGame_sotaidoanchu()
; Return:
;	+ no return
;=============================================================================

Func start_sotaidoanchu($game)

   $n = $game[0][0]
   $teamName_1 = $game[0][1] = Default ? "Team 1" : $game[0][1]
   $teamName_2 = $game[0][2] = Default ? "Team 2" : $game[0][2]

   ; Find suitable size of table
   $tableSize = 0;
   While $tableSize * $tableSize < $n
	  $tableSize += 1
   WEnd

   _ArrayShuffle($game, 1, $n)

   ; Set some neccessary value
   #Region ### CONSTANTS
   $COLOR_LABEL = 0x444444

   $H_TITLE = 70

   $W_ALIGN = 50
   $H_ALIGN = 50

   $W_UNDO = 150
   $H_UNDO = 75
   $COLOR_UNDO = 0xDDDDDD

   $W_CELL = 75
   $H_CELL = 75
   Local $COLOR_CELL[2]
   $COLOR_CELL[0] = 0xBBBBBB
   $COLOR_CELL[1] = 0xDDDDDD


   $W_PLAYERNAME = 150
   $H_PLAYERNAME = 50
   $COLOR_PLAYER1 = 0x0000DD
   $COLOR_PLAYER2 = 0xDD0000

   $W_SCORECELL = $W_PLAYERNAME
   $H_SCORECELL = $H_PLAYERNAME
   $COLOR_SCORECELL = 0xEEEEEE

   $W_BACK = $W_UNDO
   $H_BACK = $H_UNDO
   $COLOR_BACK = $COLOR_UNDO

   $W_TURN = $W_PLAYERNAME
   $H_TURN = $H_PLAYERNAME


   ; Adjust some positions of TABLE And BUTTONS
   $H_TABLE = $tableSize * $H_CELL
   $H_CONTROLGUI = $H_UNDO + $H_SCORECELL + $H_PLAYERNAME + $H_BACK + 3 * $H_ALIGN
   If ($H_TABLE < $H_CONTROLGUI)  Then
	  $PY_TABLE = $H_TITLE + $H_ALIGN + ($H_CONTROLGUI - $H_TABLE) / 2
	  $PY_CONTROL = $H_TITLE + $H_ALIGN
	  $H = $H_CONTROLGUI
   Else
	  $PY_TABLE = $H_TITLE + $H_ALIGN
	  $PY_CONTROL = $H_TITLE + $H_ALIGN + ($H_TABLE - $H_CONTROLGUI) / 2
	  $H = $H_TABLE
   EndIf

   $PX_CELL = $W_ALIGN + $W_PLAYERNAME + $W_ALIGN

   $PX_BACK = $W_ALIGN
   $PX_UNDO = $W_ALIGN + $W_PLAYERNAME + $W_ALIGN + $tableSize * $W_CELL + $W_ALIGN

   $PY_PLAYERNAME = $PY_CONTROL+ $H_UNDO + $H_ALIGN
   $PY_SCORECELL = $PY_PLAYERNAME + $H_PLAYERNAME
   $PY_TURN = $PY_SCORECELL + $H_ALIGN

   $W_SCREEN = $SCREEN[2]
   $H_SCREEN = $SCREEN[3]

   $W_WINDOW = $W_ALIGN + $W_PLAYERNAME + $W_ALIGN + $W_CELL * $tableSize + $W_ALIGN + $W_PLAYERNAME + $W_ALIGN
   $H_WINDOW = $H_TITLE + $H + $H_ALIGN * 2
   $PX_WINDOW = ($W_SCREEN - $W_WINDOW)/2
   $PY_WINDOW = ($H_SCREEN - $H_WINDOW)/2
   #EndRegion CONSTANT

   #Region ### Create GUI
   $sotaidoanchu = GUICreate("sotaidoanchu", $W_WINDOW, $H_WINDOW, $PX_WINDOW, $PY_WINDOW, $WS_POPUP, $WS_EX_COMPOSITED)
   GUISetBkColor(0x333333)
   GUISetFont(9, 300, 0, "Consolas")

   #Region ### Create Title and Button
   $title = GUICtrlCreateLabel("SO TÀI ĐOÁN CHỮ", 0, 0, $W_WINDOW, $H_TITLE, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetFont(-1, 22, 400, 0, "Arial Bold")
   GUICtrlSetColor(-1, 0xFFFFFF)
   GUICtrlSetBkColor(-1, 0x333333)

   $undo = GUICtrlCreateLabel("UNDO", $PX_UNDO, $PY_CONTROL, $W_UNDO, $H_UNDO, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetFont(-1, 22, 400, 0, "Arial Bold")
   GUICtrlSetColor(-1, 0x000000)
   GUICtrlSetBkColor(-1, $COLOR_UNDO)

   $back = GUICtrlCreateLabel("BACK", $PX_BACK, $PY_CONTROL, $W_BACK, $H_BACK, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetFont(-1, 22, 400, 0, "Arial Bold")
   GUICtrlSetColor(-1, 0x000000)
   GUICtrlSetBkColor(-1, $COLOR_BACK)

   $player1 = GUICtrlCreateLabel($teamName_1, $W_ALIGN, $PY_PLAYERNAME, $W_PLAYERNAME, $H_PLAYERNAME, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetFont(-1, 22, 400, 0, "Arial Bold")
   GUICtrlSetColor(-1, 0x000000)
   GUICtrlSetBkColor(-1, $COLOR_PLAYER1)

   $PX_PLAYER2 = $PX_UNDO
   $player2 = GUICtrlCreateLabel($teamName_2, $PX_PLAYER2, $PY_PLAYERNAME, $W_PLAYERNAME, $H_PLAYERNAME, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetFont(-1, 22, 400, 0, "Arial Bold")
   GUICtrlSetColor(-1, 0x000000)
   GUICtrlSetBkColor(-1, $COLOR_PLAYER2)

   $score1 = GUICtrlCreateLabel("0", $W_ALIGN, $PY_SCORECELL, $W_SCORECELL, $H_SCORECELL, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetFont(-1, 22, 400, 0, "Arial Bold")
   GUICtrlSetColor(-1, 0x000000)
   GUICtrlSetBkColor(-1, $COLOR_SCORECELL)

   $PX_SCORE2 = $PX_UNDO
   $score2 = GUICtrlCreateLabel("0", $PX_SCORE2, $PY_SCORECELL, $W_SCORECELL, $H_SCORECELL, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetFont(-1, 22, 400, 0, "Arial Bold")
   GUICtrlSetColor(-1, 0x000000)
   GUICtrlSetBkColor(-1, $COLOR_SCORECELL)

   Local $turn[2]

   $turn[0] = GUICtrlCreateLabel("Your Turn", $W_ALIGN, $PY_TURN, $W_TURN, $H_TURN, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetFont(-1, 22, 400, 0, "Arial Bold")
   GUICtrlSetColor(-1, 0x000000)
   GUICtrlSetBkColor(-1, $COLOR_PLAYER1)

   $PX_TURN2 = $PX_UNDO
   $turn[1] = GUICtrlCreateLabel("Your Turn", $PX_TURN2, $PY_TURN, $W_TURN, $H_TURN, BitOR($SS_CENTER,$SS_CENTERIMAGE))
   GUICtrlSetFont(-1, 22, 400, 0, "Arial Bold")
   GUICtrlSetColor(-1, 0x000000)
   GUICtrlSetBkColor(-1, $COLOR_PLAYER2)
   GUICtrlSetState(-1, $GUI_HIDE)


   ; DRAW TABLE. THE TABLE HAVE MANY CELLS
   ; cell[][]        is handle of all label of table
   ; posCell[][][]   is positive of each cell, with posCell[i][j][0] = px,   posCell[i][j][1] = py
   ; colorCell[][]   is color of cell
   Local $cell[$tableSize][$tableSize]
   Local $posCell[$tableSize][$tableSize][2]
   Local $colorCell[$tableSize][$tableSize]

   For $i = 0 To $tableSize - 1
	  For $j = 0 To $tableSize - 1
		 ; identify every properties of cell
		 $posCell[$i][$j][0] = $PX_CELL + $j * $W_CELL
		 $posCell[$i][$j][1] = $PY_TABLE + $i * $H_CELL
		 $colorCell[$i][$j] = $COLOR_CELL[BitXOR(Mod($i,2), Mod($j,2))]

		 $content = $i * $tableSize + $j + 1 <= $n ? $i * $tableSize + $j + 1 : ""		; content of cell.

		 ; draw cell
		 $cell[$i][$j] = GUICtrlCreateLabel($content, $posCell[$i][$j][0], $posCell[$i][$j][1], $W_CELL, $H_CELL, BitOr($SS_CENTER, $SS_CENTERIMAGE, $WS_BORDER))
		 GUICtrlSetBkColor(-1, $colorCell[$i][$j])
		 GUICtrlSetFont(-1, 22, 200, 0, "Arial Rounded MT Bold")
	  Next
   Next


   GUISetState(@SW_SHOW)
   #EndRegion Create table

   Local $fOverCell[$tableSize][$tableSize]
   $fOverUndo = False
   $fOverBack = False

   For $i = 0 To $tableSize - 1
	  For $j = 0 To $tableSize - 1
		 $fOverCell[$i][$j] = False
	  Next
   Next

   ; log[][][]    is logs of game
   ; log[i][][]   is log of game at i_th turn
   ; log[i][x][y] is status of cell(x,y) at i_th turn

   ; log[i][x][y] have 5 values:
   ;	-1 : disable cell
   ;	0  : not-open cell
   ;	1  : cell belongs to team 1
   ;	2  : cell belongs to team 2
   ; 	3  : cell which some team answer wrong
   Local $log[$n + 2][$tableSize][$tableSize]

   ; Set all values of log
   For $i = 0 To $n - 1
	  For $x = 0 To $tableSize - 1
		 For $y = 0 To $tableSize - 1
			If $x * $tableSize + $y + 1 <= $n Then
			   $log[$i][$x][$y] = 0
			Else
			   $log[$i][$x][$y] = -1
			EndIf
		 Next
	  Next
   Next


   ; curTurn is id of current turn
   $curTurn = 0
   $notify_winner = 0

   While 1

	  ; CONTROL EFFECT
	  $cursor = GUIGetCursorInfo($sotaidoanchu)
	  For $i = 0 To $tableSize - 1
		 For $j = 0 To $tableSize - 1
			If ($log[$curTurn][$i][$j] = 0) Then
			   __eventOnCover($cell[$i][$j], $cursor, $colorCell[$i][$j], $posCell[$i][$j][0], $posCell[$i][$j][1], $W_CELL, $H_CELL, 22, True, $fOverCell[$i][$j])
			EndIf
		 Next
	  Next

	  __eventOnCover($undo, $cursor, $COLOR_UNDO, $PX_UNDO, $PY_CONTROL, $W_UNDO, $H_UNDO, 22, True, $fOverUndo)
	  __eventOnCover($back, $cursor, $COLOR_BACK, $PX_BACK, $PY_CONTROL, $W_BACK, $H_BACK, 22, True, $fOverBack)


	  ; CONTROL EVENT
	  $control = __controlOnClick($cursor)
	  Switch $control
		 Case $back
			__fade($sotaidoanchu, 0)
			GUIDelete($sotaidoanchu)
			ExitLoop
		 Case $undo
			; RETURN PREVIOUS TURN
			If $curTurn > 0 Then
			   $curTurn -= 1
			   __changeState($curTurn, $curTurn + 1, $turn, $tableSize, $log, $cell, $colorCell, $score1, $score2, $COLOR_PLAYER1, $COLOR_PLAYER2, $COLOR_CELL)
			EndIf
			Sleep($SOFT_TIME)
	  EndSwitch


	  ; TABLE EVENT
	  For $i = 0 To $tableSize - 1
		 For $j = 0 To $tableSize - 1
			If ($i * $tableSize + $j + 1 <= $n And $log[$curTurn][$i][$j] = 0 And $control = $cell[$i][$j]) Then

			   ; If user click on a cell, open Question Dialog in questionDialog.au3
			   $id = $i * $tableSize + $j + 1
			   $res = __questionDialog($game[$id][0], $game[$id][1], $game[$id][2])
			   If $res = 2 Then			; res = 2, question have not opened yet ---> ignore
				  ContinueLoop
			   ElseIf ($res = 0) Then	; res = 0, team answer correct
				  $res = True
				  SoundPlay(__getParentDir(@ScriptDir) & "\sound\win.mp3")
			   Else						; res = 1, team answer incorrect
				  $res = False
				  SoundPlay(__getParentDir(@ScriptDir) & "\sound\lose.mp3")
			   EndIf
			   ; change all status when any team answer the question, write it on log
			   __execAction($res, $curTurn, $log, $tableSize, $i, $j)

			   ; change status in table on GUI
			   $winner = __changeState($curTurn, $curTurn - 1, $turn, $tableSize, $log, $cell, $colorCell, $score1, $score2, $COLOR_PLAYER1, $COLOR_PLAYER2, $COLOR_CELL)
			EndIf
		 Next
	  Next


	  ; notify to winner
	  If $curTurn = $n and $notify_winner = 0 Then
		 If $winner = 1 Then
			__displayNotification($__NOTIFY_ERROR, "WINNER", "Congratulation To Team 1")
		 ElseIf $winner = 2 Then
			__displayNotification($__NOTIFY_ERROR, "WINNER", "Congratulation To Team 2")
		 Else
			__displayNotification($__NOTIFY_ERROR, "DRAW", "No winner")
		 EndIf
		 $notify_winner = 1
	  EndIf
   WEnd

   start_import()
EndFunc


;=================================================================================
; Func __readGameFile_sotaidoanchu($gamePath)
;
; Purpose : read all properties of game "sotaidoanchu" from file
;
; Parameters:
; 	+ $gamePath :  path of game file
;
; Return:
;	Game array
;		game[0][0]			number of questions
;		game[0][1]			name of team 1
;		game[0][2]			name of team 2
;		game[i][]			i_th question of game
;			game[i][0]			question
;			game[i][1]			answer
;			game[i][2]			sound path
;=================================================================================
Func __readGameFile_sotaidoanchu($gamePath)
   Const $ERR_FORMAT = -1

   ; Opening file to read number of questions to set whole elements of game_object
   $hFile = FileOpen($gamePath)
   If $hFile = -1 Then
	  SetError(-1)
	  Return
   EndIf
   $n = -1
   $soundFolder = ""
   $ext = "mp3"
   While 1
	  $element = __readAnElementJson($hFile)
	  If @error = -1 And $n = -1 Then
		 ConsoleWrite("number")
		 SetError(-1)
		 Return
	  ElseIf @error = -1 And $n > 0 Then
		 ExitLoop
	  ElseIf @error = -2 Then
		 ContinueLoop
	  EndIf

	  If StringCompare("NumberofQuestions", $element[0]) = 0 Then
		 $n = Int($element[2])
	  EndIf
	  If StringCompare("SoundPath", $element[0]) = 0 And $element[1] = Default Then
		 $soundFolder = $element[2]
	  EndIf
	  If StringCompare("SoundExtension", $element[0]) = 0 And $element[1] = Default Then
		 $ext = $element[2]
		 If StringCompare($ext, "mp3") <> 0 And StringCompare($ext, "wav")<> 0 Then
			SetError(-1)
			Return
		 EndIf
	  EndIf
   WEnd
   FileClose($hFile)

   ; End _____ read number of question


   ; Set attribute of game
   ; $game[0][0] = number of questions 			_ No Default value
   ; $game[0][1] = name of team 1 				_ Default value : "Team 1"
   ; $game[0][2] = name of team 2 				_ Default value : "Team 2"
   ; $game[i][0] = i_th question  				_ Default value : ""
   ; $game[i][1] = i_th answer 	  				_ Default value : ""
   ; $game[i][2] = sound path of i_th question	_ Default value : ""

   Local $game[$n + 1][3]
   $game[0][0] = $n
   $game[0][1] = Default
   $game[0][2] = Default
   For $i = 1 To $n
	  For $j = 0 To 2
		 $game[$i][$j] = Default
	  Next
   Next

   $invalidPath = 0
   If StringCompare($soundFolder, "") <> 0 Then
	  For $i = 1 To $n
		 $path = $soundFolder & "\" & $i & "." & $ext
		 If Not FileExists($path) Then
			$invalidPath = $i
		 Else
			$game[$i][2] = $path
		 EndIf
	  Next
   EndIf

   ; Opening file to read all remain elements
   $hFile = FileOpen($gamePath)
   If $hFile = -1 Then
	  SetError(-1)
	  Return
   EndIf

   While 1
	  $element = __readAnElementJson($hFile)
	  If @error = -2 Then									; Error = -2, empty line  --> ignore
		 ContinueLoop
	  EndIf

	  If @error = -1 Then									; Error = -1, end of file --> stop
		 ExitLoop
	  EndIf

	  $attribute = $element[0]
	  $id		 = $element[1]
	  $value 	 = $element[2]

	  If StringIsAlNum($id) And $id <> Default Then
		 $id = Int($id)
	  EndIf


	  ; Matching elements with game properties
	  ; If elements can't match with any property, return with error <> 0
	  If StringCompare($attribute, "Question") = 0 Then
		 If $id > 0 And $id <= $n Then
			$game[$id][0] = $value
		 Else
			SetError(-1)
			Return
		 EndIf

	  ElseIf StringCompare($attribute, "Answer") = 0 Then
		 If $id > 0 And $id <= $n Then
			$game[$id][1] = $value
		 Else
			SetError(-1)
			Return
		 EndIf

	  ElseIf StringCompare($attribute, "SoundPath") = 0 Then
		 If ($id > 0 And $id <= $n) Then
			$ext = StringRight($value, 3)
			; check whether sound path is valid or not
			; sound file is only *.mp3 or *.wav file
			; If file is not valid, return error = id of question
			If FileExists($value) = 0 Or (StringCompare($ext, "mp3") And StringCompare($ext, "wav")) Then
			   $invalidPath = $id
			Else
			   $game[$id][2] = $value
			EndIf
		 ElseIf $id = Default Then
			ContinueLoop
		 Else
			ConsoleWrite($attribute & " " & $value)

			SetError(-1)
			Return
		 EndIf

	  ElseIf StringCompare($attribute, "Team") = 0 Then
		 If $id = 1 Or $id = 2 Then
			$game[0][$id] = $value
		 Else
			SetError(-1)
			Return
		 EndIf

	  ElseIf StringCompare($attribute, "NumberOfQuestions") = 0 Or StringCompare($attribute, "SoundPath") = 0 Or StringCompare($attribute, "SoundExtension") = 0  Then
		 ContinueLoop
	  Else
		 SetError(-1)
		 Return
	  EndIf
   WEnd

   FileClose($hFile)

   SetError($invalidPath)
   Return $game
EndFunc


;=================================================================================
; Func __execAction(result, ByRef curTurn, ByRef log, tableSize, x, y)
;
; Purpose : perform changing table when a player choose any cell
;
; Parameters:
; 	+ result		 	 	bool  		result of turn-play
;	+ curTurn 		 		int			id of current turn
;	+ Log					ndarray		array of game log
;	+ tableSize				Int			size of table
;	+ x, y					(int, int)	position of cell in table
;
; Return:
;	no-return
;=================================================================================
Func __execAction($result, ByRef $curTurn, ByRef $log, $tableSize, $x, $y)
   Local $stepX[8]
   $stepX[0] = 1
   $stepX[1] = 0
   $stepX[2] = 0
   $stepX[3] = -1
   $stepX[4] = -1
   $stepX[5] = -1
   $stepX[6] = 1
   $stepX[7] = 1
   Local $stepY[8]
   $stepY[0] = 0
   $stepY[1] = 1
   $stepY[2] = -1
   $stepY[3] = 0
   $stepY[4] = -1
   $stepY[5] = 1
   $stepY[6] = -1
   $stepY[7] = 1


   For $i = 0 To $tableSize -1
	  For $j = 0 To $tableSize -1
		 $log[$curTurn + 1][$i][$j] = $log[$curTurn][$i][$j]
	  Next
   Next
   $curTurn += 1
   If $result = False Then
	  $log[$curTurn][$x][$y] = 3

   Else
	  $myTeam = Mod($curTurn, 2) = 1 ? 1 : 2
	  $rivalTeam = $myTeam = 1 ? 2 : 1

	  $log[$curTurn][$x][$y] = $myteam
	  For $k = 0 To 7
		 $flag = 0
		 $i = $x + $stepX[$k]
		 $j = $y + $stepY[$k]
		 While ($i >= 0 and $i < $tableSize and $j >= 0 and $j < $tableSize) And ($log[$curTurn][$i][$j] = $rivalTeam or $log[$curTurn][$i][$j] = $myTeam)
			If $log[$curTurn][$i][$j] = $myTeam Then
			   $flag = 1
			   ExitLoop
			EndIf
			$i += $stepX[$k]
			$j += $stepY[$k]
		 WEnd

		 $i = $x + $stepX[$k]
		 $j = $y + $stepY[$k]
		 If $flag = 1 Then
			While $log[$curTurn][$i][$j] <> $myTeam
			   $log[$curTurn][$i][$j] = $myTeam
			   $i += $stepX[$k]
			   $j += $stepY[$k]
			WEnd
		 EndIf
	  Next
   EndIf
EndFunc


;=================================================================================
; Func __changeState(iTurn, curTurn, turn, tableSize, log, cell, Byref colorCell, scoreTeam1, scoreTeam2, color1, color2, color_cell)
;
; Purpose : change status of table on GUI
;
; Parameters:
; 	+ iTurn			 	 	int  				id of turn need to be changed
;	+ curTurn		 		int					id of current turn
;	+ turn					ndarray_handle		handler of "your turn" label
;	+ tableSize				int					size of table
;	+ log					ndarray				log of game
;	+ cell					ndarray_handle		handlers of all cell in table
;	+ colorCell				ndarray				color of each cell
;	+ scoreTeam1,2			handler				handler of score label
;	+ color1,2				int_color			color of team 1 and 2
;	+ color_cell			const color[2]		two basic color of cell
; Return:
;	return id of team which has more score than rest one
;=================================================================================
Func __changeState($iTurn, $curTurn, $turn, $tableSize, $log, $cell, Byref $colorCell, $scoreTeam1, $scoreTeam2, $color1, $color2, $color_cell)

   If Mod($iTurn, 2) = 0 Then
	  GUICtrlSetState($turn[0], $GUI_SHOW)
	  GUICtrlSetState($turn[1], $GUI_HIDE)
   Else
	  GUICtrlSetState($turn[1], $GUI_SHOW)
	  GUICtrlSetState($turn[0], $GUI_HIDE)
   EndIf

   $score1 = 0
   $score2 = 0
   For $i = 0 To $tableSize - 1
	  For $j = 0 To $tableSize - 1
		 If $log[$iTurn][$i][$j] = 0 Then
			If $log[$curTurn][$i][$j] <> 0 Then
			   GUICtrlSetData($cell[$i][$j], $i * $tableSize + $j + 1)
			   __fallColor($cell[$i][$j], $colorCell[$i][$j], $color_cell[BitXor(Mod($i, 2), Mod($j, 2))])
			   $colorCell[$i][$j] = $color_cell[BitXor(Mod($i, 2), Mod($j, 2))]
			EndIf
		 ElseIf $log[$iTurn][$i][$j] = 1 Then
			$score1 += 1
			If $log[$curTurn][$i][$j] <> 1 Then
			   GUICtrlSetData($cell[$i][$j], "")
			   __fallColor($cell[$i][$j], $colorCell[$i][$j], $color1)
			   $colorCell[$i][$j] = $color1
			EndIf
		 ElseIf $log[$iTurn][$i][$j] = 2 Then
			$score2 += 1
			If $log[$curTurn][$i][$j] <> 2 Then
			   GUICtrlSetData($cell[$i][$j], "")
			   __fallColor($cell[$i][$j], $colorCell[$i][$j], $color2)
			   $colorCell[$i][$j] = $color2
			EndIf
		 ElseIf $log[$iTurn][$i][$j] = 3 Then
			If $log[$curTurn][$i][$j] <> 3 Then
			   GUICtrlSetData($cell[$i][$j], "")
			   __fallColor($cell[$i][$j], $colorCell[$i][$j], 0x0)
			   $colorCell[$i][$j] = 0x0
			EndIf
		 EndIf
	  Next
   Next
   GUICtrlSetData($scoreteam1, $score1)
   GUICtrlSetData($scoreteam2, $score2)
   If $score1 > $score2 Then
	  Return 1
   ElseIf $score1 < $score2 Then
	  Return 2
   Else
	  Return 0
   EndIf

EndFunc