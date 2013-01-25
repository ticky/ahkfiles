# AHKFiles

A set of AutoHotKey scripts I use daily on my Windows computers.

Generally written to avoid annoyances I find when using Windows.

## Features

* Modified version of FocuslessScroll featuring "natural" scrolling
* Mac-like hotkeys for various common functions like sleeping the display, shutting down, rebooting
* Media and volume keys modeled after Apple's keyboard layouts
* iTunes metadata support (Incomplete at this stage)
* 20% scaled Volume meter compatible with Vista and newer
* Relatively convenient Scroll Lock toggle for most key overrides so it doesn't interrupt anything

## Requirements

* A Unicode version of Autohotkey_L (Current versions of Autohotkey seem to all "just work" but YMMV)
* Windows Vista, 7 or 8

## Setup

* Make sure Autohotkey is installed
* Unzip or checkout this code to a directory of your choosing (somewhere in Documents is probably a good idea)
* (Optional) Put a `volume.wav` file in the same directory to play a short sound when changing volume (Extracting and converting `volume.aiff` from an OS X system works nicely - not provided for obvious legal reasons)
* Create a shortcut in your Startup folder running AutoHotKey for each script you want to run
* Run your shortcuts (they won't run automatically until you log back in)

## Key Mappings

* `Scroll Lock`: Enable/Disable key overrides

NOTE: Shortcuts marked with an asterisk are _not_ disabled by `Scroll Lock`.

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
* `Control`+`Shift`+`F12`: Sleep display and lock session*
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