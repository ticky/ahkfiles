; nchittest by Andreone
; Source: http://www.autohotkey.com/board/topic/20431-wm-nchittest-wrapping-whats-under-a-screen-point/

; Script Function:
; 	Wraps the windows API message WM_NCHITTEST, that allows to know which part of a window is
;	at specified coordinates.
;
; ******************************************************************************
;
;	IsOverTitleBar (i.e. MinButton or MaxButton or CloseButton or HelpButton or TitleBarCaption or TitleBarIcon)
;	IsOverMinButton
;	IsOverMaxButton
;	IsOverCloseButton
;	IsOverHelpButton
;	IsOverTitleBarCaption
;	IsOverTitleBarIcon
;	IsOverTitleSysMenu (same as IsOverTitleBarIcon)
;	IsOverClientArea
;	IsOverBorder (resizable or not)
;	IsOverResizableBorder (at top, bottom, left, right or corners)
;	IsOverNonResizableBorder (no difference between top, bottom, left, right and corners)
;	IsOverResizableLeftBorder
;	IsOverResizableRightBorder
;	IsOverResizableTopBorder
;	IsOverResizableBottomBorder
;	IsOverResizableTopLeftBorder
;	IsOverResizableBottomLeftBorder
;	IsOverResizableTopRightBorder
;	IsOverResizableBottomRightBorder
;
; ******************************************************************************
;
; From winuser.h & MSDN:
; WM_NCHITTEST = 0x84
; The return value is one of the following values, indicating the position of the cursor hot spot.
; #define HTERROR             (-2)			On the screen background or on a dividing line between windows (same as HTNOWHERE, except that the DefWindowProc function produces a system beep to indicate an error).
; #define HTTRANSPARENT       (-1)			In a window currently covered by another window in the same thread (the message will be sent to underlying windows in the same thread until one of them returns a code that is not HTTRANSPARENT).
; #define HTNOWHERE           0				On the screen background or on a dividing line between windows.
; #define HTCLIENT            1				In a client area.
; #define HTCAPTION           2				In a title bar.
; #define HTSYSMENU           3				In a window menu or in a Close button in a child window.
; #define HTGROWBOX           4				In a size box (same as HTSIZE).
; #define HTSIZE              HTGROWBOX
; #define HTMENU              5				In a menu (works for basic menus like notepad, not for menu **bars like in MS Word)
; #define HTHSCROLL           6				In a horizontal scroll bar.
; #define HTVSCROLL           7				In the vertical scroll bar.
; #define HTMINBUTTON         8				In a Minimize button.
; #define HTMAXBUTTON         9				In a Maximize button.
; #define HTLEFT              10			In the left border of a resizable window (the user can click the mouse to resize the window horizontally).
; #define HTRIGHT             11			In the right border of a resizable window (the user can click the mouse to resize the window horizontally).
; #define HTTOP               12			In the upper-horizontal border of a window.
; #define HTTOPLEFT           13			In the upper-left corner of a window border.
; #define HTTOPRIGHT          14			In the upper-right corner of a window border.
; #define HTBOTTOM            15			In the lower-horizontal border of a resizable window (the user can click the mouse to resize the window vertically).
; #define HTBOTTOMLEFT        16			In the lower-left corner of a border of a resizable window (the user can click the mouse to resize the window diagonally).
; #define HTBOTTOMRIGHT       17			In the lower-right corner of a border of a resizable window (the user can click the mouse to resize the window diagonally).
; #define HTBORDER            18			In the border of a window that does not have a sizing border.
; #define HTCLOSE             20			In a Close button.
; #define HTHELP              21			In a Help button.
;
; ******************************************************************************

IsOverClientArea(x, y, hWnd)
{
	SendMessage, 0x84,, (x & 0xFFFF) | (y & 0xFFFF) << 16,, ahk_id %hWnd%
	return (ErrorLevel == 1)
}

IsOverTitleBar(x, y, hWnd)
{
	SendMessage, 0x84,, (x & 0xFFFF) | (y & 0xFFFF) << 16,, ahk_id %hWnd%
	if ErrorLevel in 2,3,8,9,20,21
		return true
	else
		return false
}

IsOverTitleBarCaption(x, y, hWnd)
{
	SendMessage, 0x84,, (x & 0xFFFF) | (y & 0xFFFF) << 16,, ahk_id %hWnd%
	return (ErrorLevel == 2)
}

IsOverTitleBarIcon(x, y, hWnd)
{
	SendMessage, 0x84,, (x & 0xFFFF) | (y & 0xFFFF) << 16,, ahk_id %hWnd%
	return (ErrorLevel == 3)
}

IsOverSysMenu(x, y, hWnd)
{
	SendMessage, 0x84,, (x & 0xFFFF) | (y & 0xFFFF) << 16,, ahk_id %hWnd%
	return (ErrorLevel == 3)
}

IsOverMinButton(x, y, hWnd)
{
	SendMessage, 0x84,, (x & 0xFFFF) | (y & 0xFFFF) << 16,, ahk_id %hWnd%
	return (ErrorLevel == 8)
}

IsOverMaxButton(x, y, hWnd)
{
	SendMessage, 0x84,, (x & 0xFFFF) | (y & 0xFFFF) << 16,, ahk_id %hWnd%
	return (ErrorLevel == 9)
}

IsOverCloseButton(x, y, hWnd)
{
	SendMessage, 0x84,, (x & 0xFFFF) | (y & 0xFFFF) << 16,, ahk_id %hWnd%
	return (ErrorLevel == 20)
}

IsOverHelpButton(x, y, hWnd)
{
	SendMessage, 0x84,, (x & 0xFFFF) | (y & 0xFFFF) << 16,, ahk_id %hWnd%
	return (ErrorLevel == 21)
}

IsOverBorder(x, y, hWnd)
{
	SendMessage, 0x84,, (x & 0xFFFF) | (y & 0xFFFF) << 16,, ahk_id %hWnd%
	return (ErrorLevel >= 10 && ErrorLevel <= 18)
}

IsOverResizableBorder(x, y, hWnd)
{
	SendMessage, 0x84,, (x & 0xFFFF) | (y & 0xFFFF) << 16,, ahk_id %hWnd%
	return (ErrorLevel >= 10 && ErrorLevel <= 17)
}

IsOverNonResizableBorder(x, y, hWnd)
{
	SendMessage, 0x84,, (x & 0xFFFF) | (y & 0xFFFF) << 16,, ahk_id %hWnd%
	return (ErrorLevel == 18)
}

IsOverResizableLeftBorder(x, y, hWnd)
{
	SendMessage, 0x84,, (x & 0xFFFF) | (y & 0xFFFF) << 16,, ahk_id %hWnd%
	return (ErrorLevel == 10)
}

IsOverResizableRightBorder(x, y, hWnd)
{
	SendMessage, 0x84,, (x & 0xFFFF) | (y & 0xFFFF) << 16,, ahk_id %hWnd%
	return (ErrorLevel == 11)
}

IsOverResizableTopBorder(x, y, hWnd)
{
	SendMessage, 0x84,, (x & 0xFFFF) | (y & 0xFFFF) << 16,, ahk_id %hWnd%
	return (ErrorLevel == 12)
}

IsOverResizableBottomBorder(x, y, hWnd)
{
	SendMessage, 0x84,, (x & 0xFFFF) | (y & 0xFFFF) << 16,, ahk_id %hWnd%
	return (ErrorLevel == 15)
}

IsOverResizableTopLeftBorder(x, y, hWnd)
{
	SendMessage, 0x84,, (x & 0xFFFF) | (y & 0xFFFF) << 16,, ahk_id %hWnd%
	return (ErrorLevel == 13)
}

IsOverResizableBottomLeftBorder(x, y, hWnd)
{
	SendMessage, 0x84,, (x & 0xFFFF) | (y & 0xFFFF) << 16,, ahk_id %hWnd%
	return (ErrorLevel == 17)
}

IsOverResizableTopRightBorder(x, y, hWnd)
{
	SendMessage, 0x84,, (x & 0xFFFF) | (y & 0xFFFF) << 16,, ahk_id %hWnd%
	return (ErrorLevel == 14)
}

IsOverResizableBottomRightBorder(x, y, hWnd)
{
	SendMessage, 0x84,, (x & 0xFFFF) | (y & 0xFFFF) << 16,, ahk_id %hWnd%
	return (ErrorLevel == 17)
}