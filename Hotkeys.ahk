﻿#SingleInstance Force

;;;; Geoff's Custom Hotkeys ;;;;
; These hotkeys and many functions are compiled from many sources all over the web.

;;; Setting up Volume and Feedback OSD ;;;
Gui, +ToolWindow -Caption +AlwaysOnTop +Disabled
Gui, Color, 000000

Gui, add, picture, vOSDPicture x57 y59, %A_WorkingDir%\headphone.png

Gui, Font, cFFFFFF S14, Arial
Gui, add, Text, vOSDBar center x0 w206 h20 y170, □□□□□□□□□□□□□□□□

Gui, Font, cFFFFFF S10, w100, Segoe UI
Gui, add, Text, vOSDSmallLabel center x0 w206 h20 y190, 

Gui, Show, H211 W206 Center NoActivate, OSDWindow
WinSet, Region, 0-0 H211 W206 R30-30, OSDWindow
WinSet, ExStyle, +0x20, OSDWindow

SetTimer, OSDIteration, 1

OSDIterationsSinceActivated = 60
OSDMaximumOpacity = 120

;;; MAC-STYLE SHORTCUTS ;;;
; These are shortcuts I've essentially lifted from my Mac, substituting F12 for the Eject key,
; and shifting other shortcuts over one key.
; NOTE: Most of these are toggled by Scroll Lock (for lack of an "fn" key on most Keyboards)

; Eject DVD Drive
$F12::
if GetKeyState("ScrollLock", "T")
{
    Send, {F12}
}
Else
{
    TrayTip,, DVD Drive Ejected, 10
    Drive, Eject
    ; If the command completed quickly, the tray was probably already ejected.
    ; In that case, retract it:
    if A_TimeSinceThisHotkey < 1000  ; Adjust this time if needed.
    {
        Drive, Eject,, 1
    }
}
return

; Ctrl+Shift+F12 or Win+L = Sleep display and Lock
^+F12::
Sleep 1000
SendMessage, 0x112, 0xF170, 2,, Program Manager
DllCall("LockWorkStation")
return

; Ctrl+Alt+Super+F12 = Shut Down
^!#F12::
Sleep 1000
Shutdown, 1
return

; Ctrl+Alt+F12 = Restart
^!F12::
Shutdown, 2
return

; Option+Backspace = Delete word
!Backspace::
Send, {blind}^+{Left}
Send, {Backspace}
return

;;; MEDIA KEYS ;;;
; These are intended for keyboards lacking media keys.

; F6 = Media ◄◄
$F6::
if GetKeyState("ScrollLock", "T")
{
    Send, {F6}
}
Else
{
    Send, {Media_Prev}
}
return

; F7 = Media ►||
$F7::
if GetKeyState("ScrollLock", "T")
{
    Send, {F7}
}
Else
{
    Send, {Media_Play_Pause}
}
return


; F8 = Media ►►
$F8::
if GetKeyState("ScrollLock", "T")
{
    Send, {F8}
}
Else
{
    Send, {Media_Next}
}
return

; iTunes Ratings

; Control+Win+Up = Increase song rating by half a star
$^#Up::
    iTunes := ComObjCreate("iTunes.Application")
    iTunes.CurrentTrack.Rating += 10
    iTunesRatingToast()
Return

; Control+Win+Down = Decrease song rating by half a star
$^#Down::
    iTunes := ComObjCreate("iTunes.Application")
    iTunes.CurrentTrack.Rating -= 10
    iTunesRatingToast()
Return

; F9 = Mute
$F9::
if GetKeyState("ScrollLock", "T")
{
    Send, {F9}
}
Else
{
    Send, {Volume_Mute}
    VolumeToast()
}
return

; F10 = Volume Down
$F10::
if ( GetKeyState("ScrollLock", "T") )
{
    Send, {F10}
}
Else
{
    Send, {Volume_Down}
    VolumeToast()
}
return

; F11 = Volume Up
$F11::
if ( GetKeyState("ScrollLock", "T") )
{
    Send, {F11}
}
Else
{
    Send, {Volume_Up}
    VolumeToast()
}
return

;;; EVERYTHING SEARCH ;;;
; I'm using "Everything" as a quick global system search engine.

; Windows+Space -> Everything
#Space::Send ^{Space}
; Replace Windows' Win+F search shortcut with Everything
#f::Send ^{Space}

;;; iTunes COM Stuff ;;;
; Reference: http://www.disavian.net/itunes-autohotkeyl/

; Shows a traytip of the current playing track
iTunesToast()
{
    iTunes := ComObjCreate("iTunes.Application")
    title := "iTunes - " . iTunesPlayerStateString(iTunes.PlayerState)
    trackInfo := iTunes.CurrentTrack.Name . "`n" . iTunes.CurrentTrack.Artist . "`n" . iTunes.CurrentTrack.Album
    TrayTip, %title%, %trackInfo%, 10
}

iTunesOSD()
{
    global OSDIterationsSinceActivated
    iTunes := ComObjCreate("iTunes.Application")
    ;trackInfo := iTunes.CurrentTrack.Name . "`n" . iTunes.CurrentTrack.Artist . "`n" . iTunes.CurrentTrack.Album
    ;TrayTip, %title%, %trackInfo%, 10
    trackName := iTunes.CurrentTrack.Name
    artistName := iTunes.CurrentTrack.Artist
    GuiControl,, OSDBar, %trackName%
    GuiControl,, OSDSmallLabel, %artistName%
    OSDIterationsSinceActivated = 0
}

; Shows a traytip of the current playing track's info and rating
iTunesRatingToast()
{
    iTunes := ComObjCreate("iTunes.Application")
    rating := iTunes.CurrentTrack.Rating
    title := "iTunes"
    ratingStr := iTunes.CurrentTrack.Name . "`n" . iTunes.CurrentTrack.Artist . "`n" . DrawTextBar(rating, 100, 5, "★", "☆", "½")
    TrayTip, %title%, %ratingStr%, 10
}

#^R::
iTunesOSD()
return

#^V::
VolumeToast()
return

; Shows the master volume information, cropped to the bottom 20% of the volume scale
; (I only really use the first 20% with my headphones, and this gives a better sense of relative volume for me)
; Need to detect output and make this work differently for front jack versus rear jack
VolumeToast()
{
  global OSDIterationsSinceActivated
  ; NOTE: each volume up/down call is +/- 2%, so we're dropping to 20%, and showing 16 segments.
  volBar := DrawTextBar(VA_GetMasterVolume(), 20, 16, "■", "□", "")
  GuiControl,, OSDBar, %volBar%
  ; Display volume maximum is one fifth of system volume.
  ; For system volumes greater than 20% (100% Display Volume), we show a percentage of display volume.
  ; So a system volume of 30% would be 150% Display Volume.
  vol := Round(VA_GetMasterVolume()*5) . "%"
  If (Round(VA_GetMasterVolume()*5) <= 100)
  {
    vol =
  }
  GuiControl,, OSDSmallLabel, %vol%
  OSDIterationsSinceActivated = 0
  SoundPlay, %A_ScriptDir%\volume.wav
}

; Iterating volume OSD subroutine
; Needs some serious optimisation and improvement (It currently lacks any kind of delay before fading out)
OSDIteration:

  if (OSDIterationsSinceActivated < OSDMaximumOpacity / 2)
  {
    OSDIterationsSinceActivated++
  }

  if (OSDIterationsSinceActivated = 1)
  {
    WinSet, Transparent, %OSDMaximumOpacity%, OSDWindow
  }
  Else If (OSDIterationsSinceActivated = OSDMaximumOpacity / 2)
  {
    WinSet, Transparent, 0, OSDWindow
  }
  Else
  {
    TransFade := OSDMaximumOpacity - OSDIterationsSinceActivated*2
    WinSet, Transparent, %TransFade%, OSDWindow
  }

return

;;; UTILITY FUNCTIONS ;;;

; Draw a text-based bar graph. Originally done for the rating view, but expanded when I needed to use it for volume too.
; Examples:
; DrawTextBar(20, 100, 5, "★", "☆", "½") == ★☆☆☆☆
; DrawTextBar(25, 100, 5, "★", "☆", "½") == ★½☆☆☆
; DrawTextBar(25, 100, 5, "★", "☆", "")  == ★☆☆☆☆ (No intermediate char floors result)
DrawTextBar(Value,Maximum,Bars,FullChar,EmptyChar,IntermediateChar)
{
    Ratio := Maximum / Bars
    Value := (Value > Maximum) ? Maximum : Value
    ReturnValue .= Repeat(FullChar,Value // Ratio)
    ReturnValue .= (IntermediateChar <> "" and Value / Ratio > Value // Ratio) ? IntermediateChar . Repeat(EmptyChar, Bars-1-Value // Ratio) : Repeat(EmptyChar, Bars-Value // Ratio)
    Return ReturnValue
}

Repeat(String,Times)
{
  Loop, %Times%
    ReturnValue .= String
  Return ReturnValue
}

; Gives a nice string version of the iTunes player state for the integer returned by the COM API.
iTunesPlayerStateString(playerStateId)
{
    if(playerStateId == 0)
    {
        return "Playing"
    }

    if(playerStateId == 1)
    {
        return "Paused"
    }

    return "Unknown"
}
