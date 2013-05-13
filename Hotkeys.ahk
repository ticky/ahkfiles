#SingleInstance Force

;;;; Geoff's Custom Hotkeys ;;;;
; These hotkeys and many functions are compiled from many sources all over the web.

Menu, Tray, Tip, Geoff's Custom Hotkeys (Loading...)
Menu, Tray, Icon, Shell32.dll, 264

#Include nchittest.ahk

;;; Loading Configuration ;;;

; Toggles
IniRead, osdenable, config.ini, OSD, enable, true
IniRead, machotkys, config.ini, Hotkeys, macstyle, true
IniRead, mediakeys, config.ini, Hotkeys, mediakeys, true
IniRead, volumekys, config.ini, Hotkeys, volumekeys, true
IniRead, everythingkey, config.ini, Hotkeys, everything, true
IniRead, clipboardedit, config.ini, General, clipboard, true
IniRead, ituneshooks, config.ini, General, itunes, true

; General hotkeys
IniRead, keyeject, config.ini, Keymap, eject, F12
IniRead, keylock, config.ini, Keymap, lock, ^+F12
IniRead, keyshutdown, config.ini, Keymap, macshutdown, ^!#F12
IniRead, keyrestart, config.ini, Keymap, macrestart, ^!F12

; Media playback hotkeys
IniRead, keymediaprev, config.ini, Keymap, mediaprev, F6
IniRead, keymediaplay, config.ini, Keymap, mediaplay, F7
IniRead, keymedianext, config.ini, Keymap, medianext, F8

; iTunes rating hotkeys
IniRead, keyitunesrateup, config.ini, Keymap, itunesrateup, ^#Up
IniRead, keyitunesratedown, config.ini, Keymap, itunesratedown, ^#Down

; Volume control hotkeys
IniRead, keyvolumemute, config.ini, Keymap, volumemute, F9
IniRead, keyvolumedown, config.ini, Keymap, volumedown, F10
IniRead, keyvolumeup, config.ini, Keymap, volumeup, F11

; Disable the OSD entirely on Windows 8 (which provides its own)
if A_OSVersion in WIN_8,WIN_9
{
  osdenable = false
}

; Binding general hotkeys
Hotkey $%keyeject%, EjectDVD
Hotkey $%keylock%, SleepLock
Hotkey $%keyshutdown%, ShutDown
Hotkey $%keyrestart%, Restart

; Binding media playback hotkeys
Hotkey $%keymediaprev%, MediaPrev
Hotkey $%keymediaplay%, MediaPlay
Hotkey $%keymedianext%, MediaNext

; Binding iTunes rating hotkeys
Hotkey $%keyitunesrateup%, iTunesRateUp
Hotkey $%keyitunesratedown%, iTunesRateDown

; Binding volume control hotkeys
Hotkey $%keyvolumemute%, VolumeMute
Hotkey $%keyvolumedown%, VolumeDown
Hotkey $%keyvolumeup%, VolumeUp

;;; Setting up Volume and Feedback OSD ;;;

if (%osdenable% == true)
{
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
}

Menu, Tray, Tip, Geoff's Custom Hotkeys
Menu, Tray, NoStandard
Menu, Tray, Add, Lock and Sleep Display, EjectDVD
Menu, Tray, Add, Eject DVD Drive, EjectDVD
Menu, Tray, Add
Menu, Tray, Standard

return

#Include Hotstrings.ahk

;;; MAC-STYLE SHORTCUTS ;;;
; These are shortcuts I've essentially lifted from my Mac, substituting F12 for the Eject key,
; and shifting other shortcuts over one key.
; NOTE: Most of these are toggled by Scroll Lock (for lack of an "fn" key on most Keyboards)

; Eject DVD Drive
EjectDVD:
if (%machotkys% != true or GetKeyState("ScrollLock", "T"))
{
  Send, {%keyeject%}
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

; Sleep display and Lock
SleepLock:
if (%machotkys% != true)
{
  Send, {%keylock%}
}
Else
{
  iTunesPauseIfActive()
  Sleep 1000
  SendMessage, 0x112, 0xF170, 2,, Program Manager
  DllCall("LockWorkStation")
}
return

; Caps Lock Suppression
; If you press Caps Lock for less than 100ms, the input is ignored.
; Avoids accidental caps; mimics Apple Keyboard behaviour.
$CapsLock::
  If capsLockIsPressed
    return
  capsLockIsPressed := true
  SetTimer, CapsLockSuppress, 100
return

$CapsLock Up::
  SetTimer, CapsLockSuppress, Off
  capsLockIsPressed := false
return

CapsLockSuppress:
  SetTimer, CapsLockSuppress, Off
  capsLockIsPressed := false
  SetStoreCapslockMode Off
  Send, {CapsLock}
  SetStoreCapslockMode On
return

; Shut Down
ShutDown:
if (%machotkys% != true)
{
  Send, {%keyshutdown%}
}
Else
{
  Sleep 1000
  Shutdown, 1
}
return

; Restart
Restart:
if (%machotkys% != true)
{
  Send, {%keyrestart%}
}
Else
{
  Shutdown, 2
}
return

; Option+Backspace = Delete word
!Backspace::
if (%machotkys% != true)
{
  Send, {!Backspace}
}
Else
{
  Send, {blind}^+{Left}
  Send, {Backspace}
}
return

;;; MEDIA KEYS ;;;
; These are intended for keyboards lacking media keys.

; Media ◄◄
MediaPrev:
if (%mediakeys% != true or GetKeyState("ScrollLock", "T"))
{
  Send, {%keymediaprev%}
}
Else
{
  Send, {Media_Prev}
}
return

; Media ►||
MediaPlay:
if (%mediakeys% != true or GetKeyState("ScrollLock", "T"))
{
  Send, {%keymediaplay%}
}
Else
{
  Send, {Media_Play_Pause}
}
return


; Media ►►
MediaNext:
if (%mediakeys% != true or GetKeyState("ScrollLock", "T"))
{
  Send, {%keymedianext%}
}
Else
{
  Send, {Media_Next}
}
return

; iTunes Ratings

; Increase song rating by half a star
iTunesRateUp:
  iTunes := ComObjCreate("iTunes.Application")
  iTunes.CurrentTrack.Rating += 10
  iTunesRatingToast()
Return

; Decrease song rating by half a star
iTunesRateDown:
  iTunes := ComObjCreate("iTunes.Application")
  iTunes.CurrentTrack.Rating -= 10
  iTunesRatingToast()
Return

; Mute
VolumeMute:
if ( %volumekys% != true or GetKeyState("ScrollLock", "T") )
{
  Send, {%keyvolumemute%}
}
Else
{
  Send, {Volume_Mute}
  VolumeToast()
}
return

; Volume Down
VolumeDown:
if ( %volumekys% != true or GetKeyState("ScrollLock", "T") )
{
  Send, {%keyvolumedown%}
}
Else
{
  Send, {Volume_Down}
  VolumeToast()
}
return

; Volume Up
VolumeUp:
if ( %volumekys% != true or GetKeyState("ScrollLock", "T") )
{
  Send, {%keyvolumeup%}
}
Else
{
  Send, {Volume_Up}
  VolumeToast()
}
return

; Show OSD for Volume Keys
~Volume_Mute::
  Sleep 100
  VolumeToast()
return

~Volume_Down::
  Sleep 100
  VolumeToast()
return

~Volume_Up::
  Sleep 100
  VolumeToast()
return

; Clipboard Monitor for afp:// URIs.
OnClipboardChange:
if ( %clipboardedit% == true and InStr(clipboard, "afp`://") == 1 )
{
  clip = %clipboard%
  StringReplace, clip, clip, afp`://, \\, All
  StringReplace, clip, clip, /, \, All
  clipboard = %clip%
  TrayTip, Apple Filing Protocol URI detected, Converted to Windows path and updated clipboard.
}
return

;;; EVERYTHING SEARCH ;;;
; I'm using "Everything" as a quick global system search engine.

; Windows+Space -> Everything
#Space::
if (%everythingkey% == true)
  Send ^{Space}
Else
  Send #{Space}
return

; Replace Windows' Win+F search shortcut with Everything
#f::
if (%everythingkey% == true)
  Send ^{Space}
Else
  Send #{f}
return

;;; iTunes COM Stuff ;;;
; Reference: http://www.disavian.net/itunes-autohotkeyl/

iTunesOSD()
{
  global OSDIterationsSinceActivated
  iTunes := ComObjCreate("iTunes.Application")
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

; If the iTunes process exists, and the player state is currently playing, pauses playback.
iTunesPauseIfActive()
{
  global ituneshooks
  if ( %ituneshooks% == true )
  {
    Process, Exist, itunes.exe
    if ErrorLevel
    {
      ; iTunes is running
      iTunes := ComObjCreate("iTunes.Application")
      state := iTunes.PlayerState
      if (state == 1)
      {
        iTunes.Pause()
      }
    }
  }
}

; Shows the master volume information, cropped to the bottom 20% of the volume scale
; (I only really use the first 20% with my headphones, and this gives a better sense of relative volume for me)
; Need to detect output and make this work differently for front jack versus rear jack
VolumeToast()
{
  if A_OSVersion in WIN_VISTA,WIN_7
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
  }
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
    Gui, Show, H211 W206 Center NoActivate, OSDWindow
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