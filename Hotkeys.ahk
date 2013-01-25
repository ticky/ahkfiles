#SingleInstance Force

;;;; Geoff's Custom Hotkeys ;;;;
; These hotkeys and many functions are compiled from many sources all over the web.

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

; Ctrl+Shift+F12 = Sleep display and Lock
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
    SoundPlay, %A_ScriptDir%\volume.wav
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
    SoundPlay, %A_ScriptDir%\volume.wav
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
    SoundPlay, %A_ScriptDir%\volume.wav
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
iTunesRatingToast()
return

#^V::
VolumeToast()
return

; Shows the master volume information, cropped to the bottom 20% of the volume scale
; (I only really use the first 20% with my headphones, and this gives a better sense of relative volume for me)
; Need to detect output and make this work differently for front jack versus rear jack
VolumeToast()
{
    title := VA_GetMasterVolume() . "%"
    ; NOTE: each volume up/down call is +/- 2%, so we're dropping to 20% so that each "notch" is an item (and it's not enormous)
    str := DrawTextBar(VA_GetMasterVolume(), 20, 10, "▲", "▽", "")
    TrayTip, %title%, %str%, 10
}

;;; UTILITY FUNCTIONS ;;;

; Draw a text-based bar graph. Originally done for the rating view, but expanded when I needed to use it for volume too.
; Examples:
; DrawTextBar(20, 100, 5, "★", "☆", "½") == ★☆☆☆☆
; DrawTextBar(25, 100, 5, "★", "☆", "½") == ★½☆☆☆
; DrawTextBar(25, 100, 5, "★", "☆", "")  == ★☆☆☆☆ (No intermediate char floors result)
; Note that overflowing the "maximum" value will just draw a longer bar at this point.
DrawTextBar(Value,Maximum,Bars,FullChar,EmptyChar,IntermediateChar)
{
    Ratio := Maximum / Bars
    Output .= Repeat(FullChar,Value // Ratio)
    Output .= (IntermediateChar <> "" and Value / Ratio > Value // Ratio) ? IntermediateChar . Repeat(EmptyChar, Bars-1-Value // Ratio) : Repeat(EmptyChar, Bars-Value // Ratio)
    Return Output
}

Repeat(String,Times)
{
  Loop, %Times%
    Output .= String
  Return Output
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