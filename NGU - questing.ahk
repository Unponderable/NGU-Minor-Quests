;Unponderable's Questing Script for NGU Idle v0.1
;Supports NGU Idle version 0.414-2
;
;Script will endlessly farm minor quests and the corresponding items from the Pretty Pink Princess zone.
;
;Release Notes
;Version 0.1 - First Draft
;
;Prerequisites:
; No active quest (or be willing to abort progress in current quest)
; Have completed the Pretty Pink Princess item set to unlock Pretty Pink Princess quests.
; Adequate Inventory Space on visible inventory page
; Adventure Mode idle mode is on
;
; I suggest wearing Quest Drops and Respawn accessories for maximum effectiveness
; I also suggest filtering 500 Boosts, and 1K Boosts, and MacGuffins unless you are confident in your auto-boost/merge.
;
;Instructions for Questing: 
;1. Run the script.
;2. With the NGU window focused and fully visible in your screen, use ***Ctrl+j*** to begin the script.
;3. Press Esc at any time to exit.
;


Global Px ;Top Left Corner X coordinate
Global Py ;Top Left Corner Y coordinate
Global XPositionAdventure
Global YPositionAdventure
Global XPositionPreviousZone
Global YPositionPreviousZone
Global XPositionNextZone
Global YPositionNextZone
Global Y_Inventory
Global Y_Questing
Global WinW
Global WinH
Global XQuestAccept
Global XQuestSkip
Global YQuestButton
Global XConfirmSkipQuest
Global YConfirmSkipQuest

Esc::ExitApp ;**Press Escape to end the script at anytime**

^j:: ;**Press CTRL+J to begin script loop**
{
	IfWinNotActive, Play NGU IDLE
	{
		MsgBox, Failed to initiate - NGU Idle window not active.`nRun the script when the game window is active.
		Exit
	}
	SetMouseDelay, 10
	SetKeyDelay, 10
	LoopCount := 0

	WinGetPos,,,WinW,WinH

	SearchFileName = TopLeft.png
	ImageSearch, Px, Py, 0, 0, %WinW%, %WinH%, *10 %SearchFileName%
	if ErrorLevel{
		MsgBox, Failed to initiate - couldn't detect top left corner of NGU Idle using ImageSearch.`nMake sure the game is fully visible on your screen.`nExiting...
		Exit
		}
	
	;Set the position of boxes relative to the top left corner. Determined in advance.
	XPositionAdventure := Px + 237 ;The Adventure button under Features
	YPositionAdventure := Py + 140
	XPositionPreviousZone := Px + 331 ;The left arrow in the Adventure menu
	YPositionPreviousZone := Py + 221
	XPositionNextZone := Px + 929 ;The right arrow in the Adventure menu
	YPositionNextZone := Py + 221
	Y_Inventory := Py + 537 - 375
	Y_Questing := Py + 841 - 375
	
	XQuestAccept := Px + 1040 - 330
	XQuestSkip := Px + 1200 - 330
	YQuestButton := Py + 537 - 375
	XConfirmSkipQuest := Px + 768 - 330
	YConfirmSkipQuest := Py + 690 - 375
		
	Adventure()
	Sleep, 100
	Click,right,%XPositionPreviousZone%, %YPositionPreviousZone% ;Safe Zone
	Sleep, 100
	Loop, 23 { ;Pretty Pink Princess zone
				Send,{Right}
				Sleep,100
	}
	Questing()
	MajorQuestCheck()
		
	Loop{
		GetPPPQuest()
		Inventory()
		Loop{
			ImageSearch, Px, Py, 0, 0, %WinW%, %WinH%, *10 questing_ppp_item.png
			if Px ;If there's quest item in the inventory...
			{
				Click, right, %Px%, %Py% ;deposit all quest items
				Sleep, 500
				Questing()
				Sleep, 2000
				ImageSearch, Px, Py, 0, 0, %WinW%, %WinH%, *10 questing_done.png
				if Px ;If there's a quest ready to be completed...
				{ 
					Questing()
					Click, %XQuestAccept%, %YQuestButton% ;Complete it
					Sleep, 100
					Inventory()
					break
				}
				Inventory()
			}
					
			Sleep, 1000
		}
		
	}
}

Adventure()
{
	Click %XPositionAdventure%, %YPositionAdventure%
	Sleep, 100
}

Inventory()
{
	Click %XPositionAdventure%, %Y_Inventory%
	Sleep, 100
}

Questing()
{
	Click %XPositionAdventure%, %Y_Questing%
	Sleep, 100
}

MajorQuestCheck() ;if major quest checkmark is checked, uncheck it
{
	ImageSearch, Px, Py, 0, 0, %WinW%, %WinH%, *10 questing_majqcheck.png
	if Px
	{
		Click, %Px%, %Py%
	}
	Sleep, 100
}

GetPPPQuest() ;get a PPP quest
{
	Questing()
	Sleep, 100
	
	;imagesearch for quest text
	ImageSearch, Px, Py, 0, 0, %WinW%, %WinH%, *10 questing_ppp_text.png
	if Px
	{
		return
	}
	Sleep, 100
	
	Loop{
	;if not there, try to start quest
	Click, %XQuestAccept%, %YQuestButton%
	Sleep, 100
	
	;imagesearch for quest text
	ImageSearch, Px, Py, 0, 0, %WinW%, %WinH%, *10 questing_ppp_text.png
	if Px
	{
		return
	}
	Sleep, 100
	
	;if not there, skip quest, confirm
	Click, %XQuestSkip%, %YQuestButton%
	Sleep, 100
	Click, %XConfirmSkipQuest%, %YConfirmSkipQuest%
	Sleep, 100
	
	;loop to second line
	}
}