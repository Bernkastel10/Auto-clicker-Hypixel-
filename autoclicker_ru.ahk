#NoEnv
#SingleInstance Force
#Warn
SendMode Input
SetBatchLines -1
SetWorkingDir %A_ScriptDir%

global toggle := false
global clickCounter := 0
global previousKey := ""

RegRead, minCPS, HKCU, Software\HypixelAutoClicker, minCPS
if ErrorLevel
    minCPS := 10
RegRead, maxCPS, HKCU, Software\HypixelAutoClicker, maxCPS
if ErrorLevel
    maxCPS := 14
RegRead, movementChancePercentage, HKCU, Software\HypixelAutoClicker, movementChancePercentage
if ErrorLevel
    movementChancePercentage := 20
RegRead, movementStrengthPercent, HKCU, Software\HypixelAutoClicker, movementStrengthPercent
if ErrorLevel
    movementStrengthPercent := 10
RegRead, activationKey, HKCU, Software\HypixelAutoClicker, activationKey
if ErrorLevel
    activationKey := "XButton1"

Gui, +AlwaysOnTop +LastFound
Gui, Color, 2d2d2d, 2d2d2d
Gui, Font, s10, Segoe UI

Gui, Add, Text, cFFFFFF w340 Center, Hypixel AutoClicker
Gui, Add, Text, cAAAAAA w340 Center, (Мод-инструмент)

Gui, Add, Text, cFFFFFF x20 y70, Статус:
Gui, Add, Text, cFFFFFF x200 y70, Бинд:
Gui, Add, Text, cFF3131 x20 y90 w80 vStatusText, ВЫКЛЮЧЕН
Gui, Add, Hotkey, x200 y90 w120 vActivationKey gSetHotkey

Gui, Add, Text, cFFFFFF x20 y135, Min CPS:
Gui, Add, Text, cFFFFFF x160 y135 w40 vMinCpsDisplay, %minCPS%
Gui, Add, Slider, x200 y135 w120 vMinCPS gUpdateSettings

Gui, Add, Text, cFFFFFF x20 y170, Max CPS:
Gui, Add, Text, cFFFFFF x160 y170 w40 vMaxCpsDisplay, %maxCPS%
Gui, Add, Slider, x200 y170 w120 vMaxCPS gUpdateSettings

Gui, Add, Text, cFFFFFF x20 y205, Шанс движений (`%):
Gui, Add, Text, cFFFFFF x160 y205 w40 vMovementChanceDisplay, %movementChancePercentage%
Gui, Add, Slider, x200 y205 w120 vMovementChancePercentage gUpdateSettings

Gui, Add, Text, cFFFFFF x20 y240, Сила движений (`%):
Gui, Add, Text, cFFFFFF x160 y240 w40 vMovementStrengthDisplay, %movementStrengthPercent%
Gui, Add, Slider, x200 y240 w120 vMovementStrengthPercent gUpdateSettings

Gui, Add, Button, x20 y285 w145 h30 gSaveSettings, Сохранить
Gui, Add, Button, x175 y285 w145 h30 gResetSettings, Сбросить
Gui, Add, Button, x20 y325 w300 h30 gToggleClicker, Старт / Стоп

Gui, Show, w340, AutoClicker

GuiControl,, MinCPS, %minCPS%
GuiControl,, MaxCPS, %maxCPS%
GuiControl,, MovementChancePercentage, %movementChancePercentage%
GuiControl,, MovementStrengthPercent, %movementStrengthPercent%
GuiControl,, ActivationKey, %activationKey%
Hotkey, %activationKey%, ToggleClicker
previousKey := activationKey
return

SetHotkey:
    Gui, Submit, NoHide
    newActivationKey := activationKey
    if (newActivationKey = previousKey or newActivationKey = "")
        return
    Hotkey, %newActivationKey%, TempHotkeyLabel, On, UseErrorLevel
    if (ErrorLevel)
    {
        GuiControl,, ActivationKey, %previousKey%
        return
    }
    Hotkey, %newActivationKey%, TempHotkeyLabel, Off
    Hotkey, %previousKey%, Off
    Hotkey, %newActivationKey%, ToggleClicker, On
    previousKey := newActivationKey
return

SaveSettings:
    Gui, Submit, NoHide
    RegWrite, REG_SZ, HKCU, Software\HypixelAutoClicker, minCPS, %minCPS%
    RegWrite, REG_SZ, HKCU, Software\HypixelAutoClicker, maxCPS, %maxCPS%
    RegWrite, REG_SZ, HKCU, Software\HypixelAutoClicker, movementChancePercentage, %movementChancePercentage%
    RegWrite, REG_SZ, HKCU, Software\HypixelAutoClicker, movementStrengthPercent, %movementStrengthPercent%
    RegWrite, REG_SZ, HKCU, Software\HypixelAutoClicker, activationKey, %activationKey%
    Gosub, ShowSaveNotification
return

ResetSettings:
    minCPS := 10
    maxCPS := 14
    movementChancePercentage := 20
    movementStrengthPercent := 10
    activationKey := "XButton1"
    GuiControl,, minCPS, %minCPS%
    GuiControl,, maxCPS, %maxCPS%
    GuiControl,, movementChancePercentage, %movementChancePercentage%
    GuiControl,, movementStrengthPercent, %movementStrengthPercent%
    GuiControl,, ActivationKey, %activationKey%
    GuiControl,, MinCpsDisplay, %minCPS%
    GuiControl,, MaxCpsDisplay, %maxCPS%
    GuiControl,, MovementChanceDisplay, %movementChancePercentage%
    GuiControl,, MovementStrengthDisplay, %movementStrengthPercent%
    Gosub, SetHotkey
    Gosub, SaveSettings
return

UpdateSettings:
    Gui, Submit, NoHide
    if (minCPS > maxCPS) {
        maxCPS := minCPS
        GuiControl,, MaxCPS, %maxCPS%
    }
    GuiControl,, MinCpsDisplay, %minCPS%
    GuiControl,, MaxCpsDisplay, %maxCPS%
    GuiControl,, MovementChanceDisplay, %movementChancePercentage%
    GuiControl,, MovementStrengthDisplay, %movementStrengthPercent%
return

ToggleClicker:
    toggle := !toggle
    if (toggle) {
        GuiControl,, StatusText, ВКЛЮЧЕН
        GuiControl, +c00FF00, StatusText 
        global StatusNotificationText := "Кликер включен"
        global StatusNotificationColor := "00FF00"
    } else {
        GuiControl,, StatusText, ВЫКЛЮЧЕН
        GuiControl, +cFF3131, StatusText
        global StatusNotificationText := "Кликер выключен"
        global StatusNotificationColor := "FF3131"
    }
    SetTimer, ShowStatusNotification, -1
    WinSet, Redraw,, AutoClicker
return

ShowStatusNotification:
    Gui, 3:Destroy
    Gui, 3:+Owner1 +AlwaysOnTop -Caption +ToolWindow +LastFound
    Gui, 3:Color, 000000
    Gui, 3:Font, s16 Bold, Segoe UI
    Gui, 3:Add, Text, c%StatusNotificationColor% Center, %StatusNotificationText%
    Gui, 3:Show, x0 y0 NoActivate
    Loop, 15
    {
        alpha := A_Index * 17
        WinSet, Transparent, %alpha%
        Sleep, 12
    }
    Sleep, 800
    Loop, 15
    {
        alpha := 255 - (A_Index * 17)
        WinSet, Transparent, %alpha%
        Sleep, 18
    }
    Gui, 3:Destroy
return

ShowSaveNotification:
    Gui, 2:+Owner1 +AlwaysOnTop -Caption +ToolWindow +LastFound +E0x80000
    Gui, 2:Font, s16, MTS Compact
    Gui, 2:Add, Text, c301934 Center, Изменения сохранены
    WinGetPos, mainX, mainY, mainW, mainH, AutoClicker
    Gui, 2:Show, NA Hide
    WinGetPos,,, notifW, notifH
    notifX := mainX + (mainW - notifW) / 2
    notifY := mainY + (mainH - notifH) / 2
    Gui, 2:Show, x%notifX% y%notifY% NoActivate
    Loop, 10 {
        alpha := A_Index * 25
        WinSet, Transparent, %alpha%
        Sleep, 15
    }
    Sleep, 1000
    Loop, 10 {
        alpha := 255 - (A_Index * 25)
        WinSet, Transparent, %alpha%
        Sleep, 20
    }
    Gui, 2:Destroy
return

GuiClose:
GuiEscape:
    ExitApp
return

#if toggle
~*$LButton::
    prevDelay := 0
    consecutiveFastClicks := 0
    clickCounter := 0
    startTime := A_TickCount
    while (toggle && GetKeyState("LButton","Physical"))
    {
        Click
        clickCounter++
        elapsed := A_TickCount - startTime
        clicksPerSecond := clickCounter / (elapsed / 1000)
        Random, movementChance, 1, 100
        if (clicksPerSecond > 15 || RandomClickDelay())
        {
            Random, delay, 30, 40
            if (movementChance <= movementChancePercentage)
                RandomMouseMovement()
            Sleep, delay
            if (movementChance <= movementChancePercentage)
                RandomMouseMovement()
        }
        else if (Mod(clickCounter, 3) = 0)
        {
            Random, delay, 10, 35
            Sleep, delay
        }
        else if (Mod(clickCounter, 5) = 0)
        {
            Random, delay, 10, 70
            if (delay > 40)
                Random, delay, 40, 80
            Sleep, delay
        }
        else
        {
            Sleep, 60
        }
        prevDelay := delay
        if (delay < 55)
            consecutiveFastClicks++
        else
            consecutiveFastClicks := 0
    }
    prevDelay := 0
    consecutiveFastClicks := 0
    clickCounter := 0
return
#if

TempHotkeyLabel:
return

RandomClickDelay()
{
    global clickCounter
    localDelay := 0 
    Random, chance, 1, 3
    if (chance = 1)
    {
        Random, localDelay, 10, 60
        if (localDelay <= 50)
            Random, localDelay, 10, 30
        else
            Random, localDelay, 40, 80
    }
    else if (chance = 2 && Mod(clickCounter, 3) = 0)
    {
        Random, localDelay, 10, 60
        if (localDelay <= 60)
            Random, localDelay, 1, 40
        else
            Random, localDelay, 40, 70
    }
    else
    {
        Random, localDelay, 40, 80
    }
    return localDelay
}

RandomMouseMovement()
{
    global movementStrengthPercent
    actualStrength := Round((movementStrengthPercent / 100) * 10)
    if (actualStrength <= 0)
        return
    MouseGetPos, startX, startY
    Random, offsetX, -actualStrength, %actualStrength%
    yStrength := actualStrength + 1
    Random, offsetY, -yStrength, %yStrength%
    targetX := startX + offsetX
    targetY := startY + offsetY
    DllCall("mouse_event", "uint", 0x0001, "int", targetX - startX, "int", targetY - startY, "uint", 0, "int", 0)
}
