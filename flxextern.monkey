Strict

Import "native/flixel.${TARGET}.${LANG}"

Extern

#If LANG="cpp"
	Function IsMobile:Bool() = "flixel::isMobile"
#ElseIf TARGET = "xna" Or TARGET = "psm"
	Function IsMobile:Bool() = "flixel.functions.isMobile"
#Else
	Function IsMobile:Bool() = "flixel.isMobile"
#End

#If TARGET = "xna" Or TARGET = "psm"
	Function FlxOpenURL:Void(url:String) = "flixel.functions.openURL"
#End

#If TARGET = "html5"
	Function IsIE:Bool() = "flixel.isIE"
#End
