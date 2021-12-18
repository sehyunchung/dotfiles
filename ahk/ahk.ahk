#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; hjkl stuff
; trigger hjkl mode with f
*f::Input, Key, VL1
*f Up::
Input
Key := StrLen(Key)
IF A_PriorHotKey = *f
{
	SendInput, {Left %Key%}
	SendInput, {Blind}f
	SendInput, {Right %Key%}
}
Key =
Return
#If GetKeyState("f","P")
h::left
j::down
k::up
l::right
#If

; trigger hjkl-select mode with d
*d::Input, Key, VL1
*d Up::
Input
Key := StrLen(Key)
IF A_PriorHotKey = *d
{
	SendInput, {Left %Key%}
	SendInput, {Blind}d
	SendInput, {Right %Key%}
}
Key =
Return
#If GetKeyState("d","P")
h::+left
j::+down
k::+up
l::+right
#If

; trigger hjkl-word-select mode with s
*s::Input, Key, VL1
*s Up::
Input
Key := StrLen(Key)
IF A_PriorHotKey = *s
{
	SendInput, {Left %Key%}
	SendInput, {Blind}s
	SendInput, {Right %Key%}
}
Key =
Return
#If GetKeyState("s","P")
h::^+left
j::^+down
k::^+up
l::^+right
#If

; trigger hjkl-select-to-end-of-the-line mode with s
*a::Input, Key, VL1
*a Up::
Input
Key := StrLen(Key)
IF A_PriorHotKey = *a
{
	SendInput, {Left %Key%}
	SendInput, {Blind}a
	SendInput, {Right %Key%}
}
Key =
Return
#If GetKeyState("a","P")
h::+up
j::+down
k::^+up
l::+down
#If
