#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;Some functions used to automatically check for health and energy values of Khora and its pet.
;Certain functions are copied or extremelly similar to those created by the grandmaster Hackerman from Folren's server, thank you mate.
;The scripts are designed to work on a 1600x900 resolution, coordinates must be changed depending on the user's resolution.

;Randomized sleep function, created to make sleep times between moves randomized to make it difficult to be detected.
sleepR(sleepTime,deviation)
    {
        sleepLow := round((1-deviation/100)*sleepTime)
        sleepHigh := round((1+deviation/100)*sleepTime)
        random, ranSleepTime, %sleepLow%, %sleepHigh%
        sleep %ranSleepTime%
        return ranSleepTime
    }

;Pretty rudimentary function, it checks for certain values in the HP bar, if none of them are found it goes into operator to heal with Magus.
healthCheck(){ ;
    x:=
    y:=
    Loop{
        PixelSearch, x, y, 1480,32, 1490, 50, 0xE6C001, 3, Fast
        if ErrorLevel{

            PixelSearch, x, y, 1480,32, 1490, 50, 0xE802A2, 3, Fast
            if ErrorLevel{

                PixelSearch, x, y, 1480,32, 1490, 50, 0x8C8C8C, 3, Fast
                if ErrorLevel{
                    
                    sleepR(200, 5)
                    Send {5 down}
                    sleepR(500, 5)
                    Send {v down}
                    sleepR(4000, 10)           
                    Send {v up}
                    sleepR(50, 25)
                    Send {5 up}
                }
            }
        }
        Sleep, 100
    }
}

;Better health check, uses health pads and Khora's cage to stay alive
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

        getThresholdX:=1405
        getThresholdY:=855

        PixelGetColor, color, %getThresholdX%, %getThresholdY% 

        Col3 := "0x"(Substr(color, 7 ,2))

        Col3 := Col3 + 0

        if (Col3 < 150){ 
            sleepR(100, 5)
            Send {6 DOWN}
            sleepR(100, 5)
            Send {6 UP}

        }
        Sleep, 200
}

;Checks for Venari HP bar and resses him in case he's dead.
ressCat(){

    Loop{
        getThresholdX:=1561
        getThresholdY:=107
        PixelGetColor, color, %getThresholdX%, %getThresholdY% 
        Col3 := "0x"(Substr(color, 7 ,2)) 
        Col3 := Col3 + 0
        if (Col3 < 185){ ;
            sleepR(100, 5)
            Send {2 DOWN}
            sleepR(100, 5)
            Send {2 UP}

        }
        Sleep, 200
    }
}

;Checks for the player HP bar
selfRess(){
    Loop{
        getThresholdX:=1561
        getThresholdY:=107
        PixelGetColor, color, %getThresholdX%, %getThresholdY% 
        Col3 := "0x"(Substr(color, 7 ,2)) 
        Col3 := Col3 + 0
        if (Col3 >180 and Col3 < 200 or Col3>84 and Col3 < 90){ 
	    ;MsgBox test section
        } else{
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
        }
        Sleep, 200
    }
}

;A distance function made to give some flexibility to the program, it's not been used in other scripts yet.

;Returns the distance between two colors of pixels by comparing the RGB values.
;It follows this formula sqrt((r2-r1)^2+(g2-g1)^2+(b2-b1)^2).
distance(c1, c2){

    r1 := c1 >> 16
    g1 := c1 >> 8 & 255
    b1 := c1 & 255
    r2 := c2 >> 16
    g2 := c2 >> 8 & 255
    b2 := c2 & 255
    return Sqrt( (r1-r2)**2 + (g1-g2)**2 + (b1-b2)**2 )
}
}
F5::healthCheck()
F6::energyCheck()
F7::ressCat()
F8::selfRess()
