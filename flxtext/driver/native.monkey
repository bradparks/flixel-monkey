Strict

Import mojo

Import flixel.flxextern
Import flixel.flxtext
Import flixel.flxtext.driver

Import flixel.system.flxassetsmanager
Import flixel.system.flxresourcesmanager

Import "../../data/system_font_8_flx.png"
Import "../../data/system_font_9_flx.png"
Import "../../data/system_font_10_flx.png"
Import "../../data/system_font_11_flx.png"
Import "../../data/system_font_12_flx.png"
Import "../../data/system_font_13_flx.png"
Import "../../data/system_font_14_flx.png"
Import "../../data/system_font_15_flx.png"
Import "../../data/system_font_16_flx.png"
Import "../../data/system_font_17_flx.png"

Class FlxTextNativeDriver Extends FlxTextDriver

	Global ClassObject:Object

Private
	Global _FontLoader:FlxNFDriverLoader = New FlxNFDriverLoader()
	
	Global _FontsManager:FlxResourcesManager<Image> = New FlxResourcesManager<Image>()
	
	Global _DefaultFont:Image
	
	Field _font:Image
	
	Field _fontHeight:Int

Public
	Method Destroy:Void()
		_font = Null						
		Super.Destroy()
	End Method
	
	Method GetTextWidth:Int(text:String)
		Return text.Length()*_font.Width()
	End Method
	
	Method GetTextHeight:Int()
		Return _countLines * _fontHeight
	End Method
	
	Method Draw:Void(x:Float, y:Float)
		_DefaultFont = GetFont()
		SetFont(_font)
		
		If (_countLines <= 1) Then
			DrawText(_text, x + _offsetX, y)
		Else			
			For Local line:Int = 0 Until _countLines
				DrawText(_textLines.Get(line).text, x + _textLines.Get(line).offsetX, y + line * _fontHeight)
			Next
		End If
		
		SetFont(_DefaultFont)	
	End Method				

	Method Reset:Void()
		_FontLoader.fontFamily = _fontFamily
		_FontLoader.fontSize = _size
		
		_font = _FontsManager.GetResource(_fontFamily + _size, _FontLoader)		
		_fontHeight = _font.Height()
	End Method
	
	Method GetFontObject:Object()
		Return _font
	End Method

End Class

Private
Class FlxNFDriverLoader Extends FlxResourceLoader<Image>
	
	Field fontFamily:String = FlxText.SYSTEM_FONT
	Field fontSize:Int
	
	Method Load:T(name:String)
		Return LoadImage(FlxAssetsManager.GetFont(fontFamily).GetPath(fontSize), 96, Image.XPadding)			
	End Method

End Class