SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;Script used to afk farm with Khora, pretty good during the golden Ophelia days, can still be useful for SE afk farm in groups.
;It checks for the health of the player, its pet, energy, anti-afk movement...

timerw=0
timerd=0

sleepR(sleepTime,deviation)
    {
        sleepLow := round((1-deviation/100)*sleepTime)
        sleepHigh := round((1+deviation/100)*sleepTime)
        random, ranSleepTime, %sleepLow%, %sleepHigh%
        sleep %ranSleepTime%
        return ranSleepTime
    }

;Pretty rudimentary function, it checks for certain values in the HP bar, if none of them are found it goes into operator to heal with Magus.
healthCheck(){
    x:=
    y:=

    PixelSearch, x, y, 1480,32, 1490, 50, 0xE6C001, 3, Fast
    if ErrorLevel{

        PixelSearch, x, y, 1480,32, 1490, 50, 0xE802A2, 3, Fast
        if ErrorLevel{

            PixelSearch, x, y, 1480,32, 1490, 50, 0x8C8C8C, 3, Fast
            if ErrorLevel{
                sleepR(200, 10)
                PixelSearch, x, y, 1480,32, 1490, 50, 0xE6C001, 3, Fast
                if ErrorLevel{

                    PixelSearch, x, y, 1480,32, 1490, 50, 0xE802A2, 3, Fast
                    if ErrorLevel{

                        PixelSearch, x, y, 1480,32, 1490, 50, 0x8C8C8C, 3, Fast
                        if ErrorLevel{
                            sleepR(415, 5)                  
                            Send {5 down}
                            sleepR(500, 5)
                            Send {v down}
                            sleepR(4000, 10)           
                            Send {v up}
                            sleepR(50, 25)
                            Send {5 up}
                            Send {5 down}
                            sleepR(100, 25)
                            Send {5 up}
                            sleepR(500, 5)
                            Send {4 DOWN}
                            sleepR(100, 5)
                            Send {4 UP}
                            sleepR(350, 5)
                        }
                    }
                }
            
            }
        }
    }
}
;Better health check
betterHealthCheck(){

    PixelGetColor, color, 1517,61
    Col3 := "0x"(Substr(color, 7 ,2))
    Col3 := Col3 + 0
    if (Col3 < 185){
        Send {7 DOWN}
        sleepR(100, 5)
        Send {7 UP}
        sleepR(350, 5)
        Send {4 DOWN}
        sleepR(100, 5)
        Send {4 UP}
        sleepR(350, 5)
    }

}
;Checks how much energy is left and, in case it gets lower than a threshold, it drops an energy pad.
energyCheck(){

        PixelGetColor, color, 1405, 855 
        Col3 := "0x"(Substr(color, 7 ,2)) 
        Col3 := Col3 + 0 

        if (Col3 < 150){
            sleepR(200, 5)
            Send {6 DOWN}
            sleepR(100, 5)
            Send {6 UP}
        }
        
    }

;Checks for Venari HP bar and resses him in case he's dead.
ressCat(){

        PixelGetColor, color, 1561, 107 
        Col3 := "0x"(Substr(color, 7 ,2)) 
        Col3 := Col3 + 0 
        if (Col3 < 185){
            sleepR(400, 5)
            Send {2 DOWN}
            sleepR(100, 10)
            Send {2 UP}
            sleepR(800, 10)
        }



}
;Checks for the player HP bar
selfRess(){
        getThresholdX:=1561
        getThresholdY:=59
        PixelGetColor, color, %getThresholdX%, %getThresholdY% 
        Col3 := "0x"(Substr(color, 7 ,2)) 
        Col3 := Col3 + 0 
        if ((Col3 < 175 or Col3 > 205) and (Col3<84 or Col3 > 95)){
            sleepR(200, 5)
            PixelGetColor, color, %getThresholdX%, %getThresholdY% 
            Col3 := "0x"(Substr(color, 7 ,2)) 
            Col3 := Col3 + 0 
            if ((Col3 < 175 or Col3 > 205) and (Col3<84 or Col3 > 90)){
                sleepR(300, 5)
                Send {x DOWN}
                sleepR(2000, 5)
                Send {x UP}
                sleepR(2500, 5)
                Send {6 DOWN}
                sleepR(100, 5)
                Send {6 UP}
                sleepR(100, 5)
                Send {4 DOWN}
                sleepR(100, 5)
                Send {4 UP}
                sleepR(200, 5)
                Send {w DOWN}
                sleepR(1000, 5)
                Send {W Up}
                sleepR(100, 5)
            }
        }
}
;Whip loop
whipLoop()
    {

        WhipTime := A_TickCount
            Loop{
                Send {1 down}
                sleepR(100, 20)
                Send {1 up}
                healthCheck()
                betterHealthCheck()
                energyCheck()
                sleepR(900, 15)
            } Until A_TickCount - WhipTime > 24000 ;Around 24 seconds of loop +-1.5
    }

;Main loop of the script, used to call every function.
khoraLoop(minutes)
    {
        SetKeyDelay, 100
        min:= minutes * 60000
        StartTime := A_TickCount
        Loop
        {
            sleepR(200, 10)
            Send {4 down}
            sleepR(200, 10)
            Send {4 up}
            sleepR(610, 5)
            Send {w down}
            timerw:=sleepR(670, 10)
            Send {w up}
            sleepR(600, 10)

            whipLoop()

            Send {w down}
            timerw:=timerw + sleepR(670, 10)
            Send {Space down}
            timerw:=timerw + sleepR(250, 10)
            Send {Space up}
            timerw:=timerw + sleepR(200, 5)
            Send {Space down}
            sleepR(250, 10)
            Send {Space up}
            sleepR(200, 5)
            Send {w up}
            sleepR(10, 10)
            

            Send {s down}
            Sleep, %timerw%
            Send {s up}

            ressCat()
        } Until A_TickCount - StartTime > min ;Input
        Send {Esc}
    }

;Moves the player randomly using A and D keys. It ensures the player will always have the save position over time.
randomMovement()
    {
        loop
        {
            keyList := ["a", "d"] ; Initially it was going to have more keys, lol
            while keyList.Length()
            {
                Random, keyPop, 1, keyList.Length()
                Send % keyList.RemoveAt(keyPop)
                Random, delay, 5000, 20000
                sleep %delay%
            }
            
        }
    }
F5:: khoraLoop(200)
F7:: Reload
