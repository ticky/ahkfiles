; FocuslessScroll by Scoox
; Source: http://www.autohotkey.com/board/topic/6292-send-mouse-scrolls-to-window-under-mouse/?p=398492
; Modifications by Geoff Stokes

;Directives
#NoEnv
#SingleInstance Force
#MaxHotkeysPerInterval 100 ;Avoid warning when mouse wheel turned very fast

;Autoexecute code
MinLinesPerNotch := 1
MaxLinesPerNotch := 6
AccelerationThreshold := 100
AccelerationType := "P" ;Change to "P" for parabolic acceleration
StutterThreshold := 10
NaturalScrolling := true ; Use "Natural" scrolling (like touch devices)
EmulateStandardWScrollLock := true ; Emulate default Windows scrolling when Scroll Lock is on (3-line, traditional direction)

;Function definitions

;See above for details
FocuslessScroll(MinLinesPerNotch, MaxLinesPerNotch, AccelerationThreshold, AccelerationType, StutterThreshold, NaturalScrolling, EmulateStandardWScrollLock)
{
	SetBatchLines, -1 ;Run as fast as possible
	CoordMode, Mouse, Screen ;All coords relative to screen

	If(GetKeyState("ScrollLock", "T")) AND (EmulateStandardWScrollLock)
    {
        MinLinesPerNotch := 3
        MaxLinesPerNotch := 3
        NaturalScrolling := false
    }

	;Stutter filter: Prevent stutter caused by cheap mice by ignoring successive WheelUp/WheelDown events that occur to close together.
	If(A_TimeSincePriorHotkey < StutterThreshold) ;Quickest succession time in ms
		If(A_PriorHotkey = "WheelUp" Or A_PriorHotkey ="WheelDown")
			Return

	MouseGetPos, m_x, m_y,, ControlClass2, 2
	ControlClass1 := DllCall( "WindowFromPoint", "int64", (m_y << 32) | (m_x & 0xFFFFFFFF), "Ptr") ;32-bit and 64-bit support

	lParam := (m_y << 16) | (m_x & 0x0000FFFF)
	wParam := (120 << 16) ;Wheel delta is 120, as defined by MicroSoft

    If(NaturalScrolling) ; hack to invert for natural scrolling
        wParam := -wParam

	;Detect WheelDown event
	If(A_ThisHotkey = "WheelDown" Or A_ThisHotkey = "^WheelDown" Or A_ThisHotkey = "+WheelDown" Or A_ThisHotkey = "*WheelDown")
		wParam := -wParam ;If scrolling down, invert scroll direction

	;Detect modifer keys held down (only Shift and Control work)
	If(GetKeyState("Shift","p"))
		wParam := wParam | 0x4
	If(GetKeyState("Ctrl","p"))
		wParam := wParam | 0x8

	;Adjust lines per notch according to scrolling speed
	Lines := LinesPerNotch(MinLinesPerNotch, MaxLinesPerNotch, AccelerationThreshold, AccelerationType)

	If(ControlClass1 != ControlClass2)
	{
		Loop %Lines%
		{
			SendMessage, 0x20A, wParam, lParam,, ahk_id %ControlClass1%
			SendMessage, 0x20A, wParam, lParam,, ahk_id %ControlClass2%
		}
	}
	Else ;Avoid using Loop when not needed (most normal controls). Greately improves momentum problem!
	{
		SendMessage, 0x20A, wParam * Lines, lParam,, ahk_id %ControlClass1%
	}
}

;All parameters are the same as the parameters of FocuslessScroll()
;Return value: Returns the number of lines to be scrolled calculated from the current scroll speed.
LinesPerNotch(MinLinesPerNotch, MaxLinesPerNotch, AccelerationThreshold, AccelerationType)
{
	T := A_TimeSincePriorHotkey

	;Normal slow scrolling, separationg between scroll events is greater than AccelerationThreshold miliseconds.
	If((T > AccelerationThreshold) Or (T = -1)) ;T = -1 if this is the first hotkey ever run
	{
		Lines := MinLinesPerNotch
	}
	;Fast scrolling, use acceleration
	Else
	{
		If(AccelerationType = "P")
		{
			;Parabolic scroll speed curve
			;f(t) = At^2 + Bt + C
			A := (MaxLinesPerNotch-MinLinesPerNotch)/(AccelerationThreshold**2)
			B := -2 * (MaxLinesPerNotch - MinLinesPerNotch)/AccelerationThreshold
			C := MaxLinesPerNotch
			Lines := Round(A*(T**2) + B*T + C)
		}
		Else
		{
			;Linear scroll speed curve
			;f(t) = Bt + C
			B := (MinLinesPerNotch-MaxLinesPerNotch)/AccelerationThreshold
			C := MaxLinesPerNotch
			Lines := Round(B*T + C)
		}
	}
	Return Lines
}

;All hotkeys with the same parameters can use the same instance of FocuslessScroll(). No need to have separate calls unless each hotkey requires different parameters (e.g. you want to disable acceleration for Ctrl-WheelUp and Ctrl-WheelDown). If you want a single set of parameters for all scrollwheel actions, you can simply use *WheelUp:: and *WheelDown:: instead.

#MaxThreadsPerHotkey 6 ;Adjust to taste. The lower the value, the lesser the momentum problem on certain smooth-scrolling GUI controls (e.g. AHK helpfile main pane, WordPad...), but also the lesser the acceleration feel. The good news is that this setting does no affect most controls, only those that exhibit the momentum problem. Nice.
;Scroll with acceleration
WheelUp::
WheelDown::FocuslessScroll(MinLinesPerNotch, MaxLinesPerNotch, AccelerationThreshold, AccelerationType, StutterThreshold, NaturalScrolling, EmulateStandardWScrollLock)
;Ctrl-Scroll zoom with no acceleration (MaxLinesPerNotch = MinLinesPerNotch).
^WheelUp::
^WheelDown::FocuslessScroll(MinLinesPerNotch, MinLinesPerNotch, AccelerationThreshold, AccelerationType, StutterThreshold, NaturalScrolling, EmulateStandardWScrollLock)
;If you want zoom acceleration, replace above line with this:
;FocuslessScroll(MinLinesPerNotch, MaxLinesPerNotch, AccelerationThreshold, AccelerationType, StutterThreshold, NaturalScrolling, EmulateStandardWScrollLock)
#MaxThreadsPerHotkey 1 ;Restore AHK's default  value i.e. 1