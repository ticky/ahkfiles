# AHKFiles

A set of AutoHotKey scripts I use daily on my Windows computers.

Generally written to avoid annoyances I find when using Windows.

## Features

* Modified version of FocuslessScroll, which allows you to scroll the window under the cursor and adds acceleration. This version has been modified to include "natural" (inverse) scrolling
* Mac-like hotkeys for various common functions like sleeping the display, shutting down, rebooting
* Media and volume keys modeled after Apple's keyboard layouts
* Accidental presses of Caps Lock are ignored - you need to press it for at least 100ms to register (most accidental presses are quicker than that)
* Clipboard monitor which rewrites afp protocol links as Windows-friendly SMB paths (Note: Is not aware of context. Simply translates host and path name)
* Pauses iTunes playback (if running and playing) on session lock
* iTunes metadata support (Incomplete at this stage)
* Volume meter (showing the first 20% of the volume scale) compatible with Windows Vista and Windows 7. Disabled on Windows 8 in favour of Windows' new built-in volume meter
* Relatively convenient Scroll Lock toggle for most key overrides (but not all hotkeys) so it doesn't interrupt anything

## Requirements

* Windows Vista, 7 or 8
* A Unicode version of Autohotkey_L (Current versions of Autohotkey seem to all "just work" but YMMV)
* The [Vista Audio Control library](http://www.autohotkey.com/board/topic/21984-vista-audio-control-functions/)

## Setup

* Make sure Autohotkey is installed
* Unzip or checkout this code to a directory of your choosing (somewhere in Documents is probably a good idea)
* (Optional) Disable components (see "config.ini" section below)
* (Optional) Put a `volume.wav` file in the same directory to play a short sound when changing volume (Extracting and converting `volume.aiff` from an OS X system works nicely - not provided for obvious legal reasons)
* Create a shortcut in your Startup folder running AutoHotKey for each script you want to run
* Run your shortcuts (they won't run automatically until you log back in)

## `config.ini`

The `config.ini` file, stored in the same directory as the script itself, allows enabling and disabling certain features.

All current options accept either `true` or `false` values.

### General

* `clipboard` - Enable clipboard monitoring and replacement
* `itunes` - Enable iTunes-specific functionality

### Hotkeys

* `macstyle` - Enable Mac-style keyboard shortcuts ("System, Session and Hardware" section below)
* `itunes` - Enable iTunes integration for computer lock pause function
* `everything` - Enable "Everything" search integration.
* `mediakeys` - Enable media playback keys ("Media Playback" section below)
* `volumekeys` - Enable system volume control keys ("System Volume" section below)

### OSD

* `enable` - Show volume OSD (Always overridden to "false" on Windows 8)

## Key Mappings

* `Scroll Lock`: Enable/Disable hoykeys, natural scrolling and acceleration

NOTE: Shortcuts marked with an asterisk are _not_ disabled by `Scroll Lock`. Hotkeys disabled within `config.ini` are not toggled by `Scroll Lock`.

### Media Playback

* `F6`: Media key Rewind/Previous
* `F7`: Media key Play/Pause
* `F8`: Media key Fast Forward/Next

### System Volume

* `F9`: Mute/Unmute
* `F10`: Volume Down
* `F11`: Volume Up

### System, Session and Hardware

* `Alt`+`Backspace`: Delete to last space*
* `Control`+`Shift`+`F12`, `Win`+`L`: Sleep display and lock session*
* `Control`+`Win`+`Alt`+`F12`: Shut Down*
* `Control`+`Alt`+`F12`: Restart*
* `F12`: Eject DVD Drive
* `Win`+`Space`, `Control`+`f`: Search using Everything*

### iTunes Metadata

* `Control`+`Win`+`↑`: Increase rating of current iTunes track by half a star*
* `Control`+`Win`+`↓`: Decrease rating of current iTunes track by half a star*

### Debug and Testing Stuff

* `Control`+`Win`+`r`: Show rating of current iTunes track*
* `Control`+`Win`+`v`: Show current system volume indicator*
