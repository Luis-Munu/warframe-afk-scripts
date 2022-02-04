SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;Script created to afk farm intrinsics in railjack.
;The afk farm worked by using a ship with terrible survival capabilities and letting your crew repair it endlessly.
;Unfortunately this has been fixed as the maximum number of intrinsics you can get in a mission with this method is around 16.
;The farm itself is pretty slow but it was an effective way to farm overnight.
;The player should position itself in the lowest part of the railjack, inside of it, to not be disturbed by possible enemy invasions.


sleepR(sleepTime,deviation)
    {
        sleepLow := round((1-deviation/100)*sleepTime)
        sleepHigh := round((1+deviation/100)*sleepTime)
        random, ranSleepTime, %sleepLow%, %sleepHigh%
        sleep %ranSleepTime%
        return ranSleepTime
    }


;Used to create a random flow of movements and actions to prevent getting detected by the anti-afk system.
pressRandomKey()
    {

        keyList := ["w", "s", "a", "d", "SPACE", "e", "click", LShift]
	Random, i, 0, 7
	key := keyList[i] 

	Send {%key% DOWN}
        sleepR(1000, 15)
	Send {%key% UP}
        sleepR(1000, 15)
        
    }

;Reused function that came from the Wukong AFK Index farm, half the logic is useless here.
;Every 29 seconds it goes into operator, casts zenurik dash and uses the second ability. (Loki's invisibility in my case).
cloneCheck(flag)
    {
        currentTm := 0
        PixelGetColor, color, 3737, 132

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
            sleepR(1800-x, 3) ; This is done in order to assure that the player will stay in the same spot.
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
            currentTm := 1
        }

        Sleep, 500
        return currentTm
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
	    pressRandomKey()
            aux := cloneCheck(flag)
            currentTime := A_TickCount
            if (aux==1){
                lastActivation := currentTime
            }
            Sleep, 500
        } Until A_TickCount - startTime > min
        Send {Esc}
    }
F1:: pressRandomKey()
F5:: cloneLoop(15)
F7:: Reload

