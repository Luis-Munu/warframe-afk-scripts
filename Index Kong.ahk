SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;Script created to automate Index AFK farm with Wukong for 4K resolution.
;As of now it only resses the clone, heals it and the player and regains energy but it could be furtherly expanded.
;In the future it could loop the whole process:
;1: Selecting the Index
;2: Going into the safe spot
;3: Using the current functions to make the clone farm for the player.
;4: Selecting 2-3 rounds

sleepR(sleepTime,deviation)
    {
        sleepLow := round((1-deviation/100)*sleepTime)
        sleepHigh := round((1+deviation/100)*sleepTime)
        random, ranSleepTime, %sleepLow%, %sleepHigh%
        sleep %ranSleepTime%
        return ranSleepTime
    }

;Checks if there's a selection screen to continue or leave the index.
checkSelScreen()
    {
        isSelectionScreen := False
        PixelGetColor, color, 2730, 731 ; I define x and y values before that in the variables 
        Col1 := "0x"(SubStr(color, 3, 2))
        Col2 := "0x"(Substr(color, 5, 2))
        Col3 := "0x"(Substr(color, 7 ,2)) ; from the hexadecimal, take the last 2 values and add 0x in front of that, so it reads 0xF6 for example
        Col1 := Col1 + 0
        Col2 := Col2 + 0
        Col3 := Col3 + 0 ; adding a zero somehow transform it into a number between 0 and 255, representing the color


        if ((Col3 > 20 and Col3 < 30) and (Col2 > 20 and Col2 < 30) or (Col1 > 20 or Col1 < 30)){ 
            isSelectionScreen := True
        }
        return isSelectionScreen
    }

cloneCheck(flag)
    {
        tiempoAct := 0
        PixelGetColor, color, 3542, 1794 

        Col2 := "0x"(Substr(color, 5, 2))
        Col3 := "0x"(Substr(color, 7 ,2)) 
        Col2 := Col2 + 0
        Col3 := Col3 + 0


        if (((Col3 < 190 or Col3 > 210) and (Col2 <35 or Col2>50)) or (flag == True)){
            ;Uses wukong's cloud to fly downwards and upwards
            sleepR(50, 5)
            Send {2 DOWN}
            sleepR(50, 5)
            Send {2 UP}
            Send {s DOWN}
            x := sleepR(1000, 3)
            Send {s up}
            sleepR(30, 5)
            Send {w DOWN}
            sleepR(1800-x, 3)
            Send {w up}
            sleepR(1500, 5)
            

            ;Uses Zenurik dash
            Send {5 DOWN}
            sleepR(60, 5)
            Send {5 up}
            sleepR(205, 5)
            Send {CtrlDown}
            sleepR(150, 5)
            Send {Space}
            sleepR(150, 5)
            Send {CtrlUp}
            sleepR(200, 5)
            Send {5 DOWN}
            sleepR(60, 5)
            Send {5 up}
            sleepR(1000, 5)

            ;Checks if the clone is dead
            PixelGetColor, color, 3688, 1794 
            Col2 := "0x"(Substr(color, 5, 2))
            Col3 := "0x"(Substr(color, 7 ,2))
            Col2 := Col2 + 0
            Col3 := Col3 + 0 
            if ((Col3 < 190 or Col3 > 210) and (Col2 <35 or Col2>50) ){ 
                ;Uses Empower then clone, then corrects position.
                sleepR(100, 5)
                Send {4 DOWN}
                sleepR(50, 5)
                Send {4 UP}
                sleepR(1300, 5)
                Send {1 DOWN}
                sleepR(50, 5)
                Send {1 UP}
                sleepR(1500, 1)
                Send {d DOWN}
                sleepR(500, 5)
                Send {d UP}


            }
            tiempoAct := 1
        }

        Sleep, 500
        return tiempoAct
    }

;Checks for the Wukong's clone HP or if enough time has passed since the last activation and:
;1. Uses Wukong's cloud to go back and forth in order to heal and reactivate the Clone.
;2. Uses Zenurik Dash in order to regain the spent energy.
;3. If the clone is dead, it casts the 4th ability (Helminth's Empower), resses the clone and repositions itself.
cloneLoop(minutes)
    {
        SetKeyDelay, 100
        min:= minutes * 60000
        lastActivation := 0
	startTime = A_TickCount
        currentTime := A_TickCount
        flag := 0
        counter := 0
        Loop
        {
            flag := 0
            if (currentTime - lastActivation > 29000){
                flag := 1
                lastActivation := currentTime
            }
            aux := cloneCheck(flag)
            currentTime := A_TickCount
            if (aux==1){
                lastActivation := currentTime
            }
            Sleep, 500
        } Until A_TickCount - startTime > min
        Send {Esc}
    }
F5:: cloneLoop(15)
F7:: Reload

