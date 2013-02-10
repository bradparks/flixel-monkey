Strict

Import flixel.flxextern
Import flixel.flxtext
Import flixel.system.flxfont
Import flixel.system.asset.flximageasset

Class FlxAssetsManager

Private
	Global _Images:StringMap<FlxImageAsset>

	Global _Fonts:StringMap<FlxFont>[]
	Global _Sounds:StringMap<String>
	Global _Music:StringMap<String>
	Global _Cursors:StringMap<String>
	Global _Strings:StringMap<String>
	
Public	
	Function Init:Void()
		_Images = New StringMap<FlxImageAsset>()
	
		_Fonts = New StringMap<FlxFont>[FlxText.DRIVER_ANGELFONT+1]
	
		Local l:Int = _Fonts.Length()
		For Local i:Int = 0 Until l
			_Fonts[i] = New StringMap<FlxFont>()
		Next
		
		_Sounds = New StringMap<String>()
		_Music = New StringMap<String>()
		_Cursors = New StringMap<String>()
		_Strings = New StringMap<String>()
	End Function
	
	Function AddImage:Void(name:String, path:String)
		AddImage(name, New FlxImageAsset(name, path))
	End Function
	
	Function AddImage:FlxImageAsset(name:String, asset:FlxImageAsset, unique:Bool = False)
		If (_Images.Get(name) <> Null) Then
			If ( Not unique) Return asset
			
			Local index:Int = 0
			Local uname:String = name + index
			
			While (_Images.Get(uname) <> Null)
				index += 1
				uname = name + index
			Wend
			
			name = uname
			asset.name = name
			asset.path = _Images.Get(name).path
		End If
		
		_Images.Set(name, asset)
		Return asset
	End Function
	
	Function RemoveImage:Void(name:String)
		_Images.Remove(name)
	End Function
	
	Function GetImage:Image(name:String, width:Int = 0, height:Int = 0, animated:Bool = False)
		Local asset:FlxImageAsset = _Images.Get(name)
		
		If (asset = Null) Return Null
		If (asset.data <> Null) Return asset.data
		
	 	If (width <> 0) asset.width = width
		If (height <> 0) asset.height = height
		asset.animated = animated		
		asset.Load()
		
		Return asset.data
	End Function
	
	#Rem
	Function GetImageAsset:FlxImageAsset(name:String,)
	
	
	#End
	
	Function AddFont:FlxFont(name:String, driver:Int = FlxText.DRIVER_NATIVE)
		Local font:FlxFont = _Fonts[driver].Get(name)
		If (font <> Null) Return font
		
		font = New FlxFont(name)
		_Fonts[driver].Set(name, font)
		
		Return font	
	End Function
	
	Function RemoveFont:Void(name:String, driver:Int = FlxText.DRIVER_NATIVE)
		_Fonts[driver].Remove(name)
	End Function
	
	Function GetFonts:StringMap<FlxFont>(driver:Int = FlxText.DRIVER_NATIVE)
		Return _Fonts[driver]
	End Function
	
	Function GetFont:FlxFont(name:String, driver:Int = FlxText.DRIVER_NATIVE)
		Return _Fonts[driver].Get(name)
	End Function

	Function AddSound:Void(name:String, path:String)
		_Sounds.Set(name, path)
	End Function
	
	Function RemoveSound:Void(name:String)
		_Sounds.Remove(name)
	End Function
	
	Function GetSoundPath:String(name:String)
		Return _Sounds.Get(name)
	End Function
	
	Function AllSounds:MapKeys<String, String>()
		Return _Sounds.Keys()
	End Function
	
	Function AddMusic:Void(name:String, path:String)
		_Music.Set(name, path)
	End Function
	
	Function RemoveMusic:Void(name:String)
		_Music.Remove(name)
	End Function
	
	Function GetMusicPath:String(name:String)
		Return _Music.Get(name)
	End Function
	
	Function AllMusic:MapKeys<String, String>()
		Return _Music.Keys()
	End Function
	
	Function AddCursor:Void(cursor:String, path:String)
		_Cursors.Set(cursor, path)
	End Function
	
	Function RemoveCursor:Void(cursor:String)
		_Cursors.Remove(cursor)
	End Function
	
	Function GetCursorPath:String(cursor:String)
		Return _Cursors.Get(cursor)
	End Function
	
	Function AllCursors:MapKeys<String, String>()
		Return _Cursors.Keys()
	End Function
	
	Function AddString:Void(name:String, path:String)
		_Strings.Set(name, path)
	End Function
	
	Function RemoveString:Void(name:String)
		_Strings.Remove(name)
	End Function
	
	Function GetString:String(name:String)
		Return LoadString(_Strings.Get(name))
	End Function
	
	Function AllStrings:MapKeys<String, String>()
		Return _Cursors.Keys()
	End Function

End Class