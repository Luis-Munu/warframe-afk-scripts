SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;To use: Use F2 key if you want to generate a random riven message and send it. 
;F3 for a random message with or without rivens and send it. 
;F4 to loop the only riven mode. 
;F8 to loop the Everything mode. 
;F9 to restart the script.
;Switch the excel file accordingly to your needs but make sure the script chooses the correct cells.
;600 minutes is the standard time, you may change it in the last lines of the script.

sleepR(sleepTime,deviation)
    {
        sleepLow := round((1-deviation/100)*sleepTime)
        sleepHigh := round((1+deviation/100)*sleepTime)
        random, ranSleepTime, sleepTime, %sleepHigh%
        sleep %ranSleepTime%
        return ranSleepTime
    }


;1 Only rivens, 2 Everything
Copy(Option)
    {
        ;Opens the excel file
        msExcel := ComObjGet("path\excel.xlsx")

        ;Used to update the random cells
        Random, randomVal, 1, 9999
        msExcel.Worksheets(1).Range("E41").Value := randomVal
        
        if(Option=1)
        {
            ;Chooses a random one
            A1Val :=msExcel.Worksheets(1).Range("A13").Value

        }
	else{
             A1Val :=msExcel.Worksheets(1).Range("A10").Value
        }

        Clipboard:=A1Val
        setkeydelay 100,50
        ;Remove the comment below if you're gonna spam in dojo
	;Send {t}
        Send ^v
        Sleep, 100
        Send {Enter}
        Sleep, 100
    }
LoopIn(minutes, option)
    {
        min:=minutes*60000
        tiempoInicio := A_TickCount
        Loop
        {
            Copy(option)
            sleepR(120000, 2)
        } Until A_TickCount - tiempoInicio > min
    }

F2::Copy(1)
F3::Copy(2)
F4::LoopIn(600, 1)
F8::LoopIn(600, 2)
F9::Reload
