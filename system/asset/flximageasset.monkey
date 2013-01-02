Strict

Import mojo.graphics
Import flixel.system.flxcache
Import flxasset
Import flixel.flxg

Class FlxImageAsset Extends FlxAsset<Image>

	Field x:Int
	
	Field y:Int
	
	Field width:Int
	
	Field height:Int
	
	Field animated:Bool
	
	Method New(name:String = "", path:String = "", x:Int = 0, y:Int = 0, width:Int = 0, height:Int = 0)
		Super.New(name, path)
		Self.x = x
		Self.y = y
		Self.width = width
		Self.height = height
		Self.animated = False
	End Method
	
	Method Load:Void()
		If (data <> Null) Return
	
		Local image:Image = FlxG.Cache.Get(path)
		Local paddings:Int = 0
		Local frames:Int = 1
		
		If (image = Null) Then
			image = LoadImage(path)
			FlxG.Cache.Put(path, image)
		End If
		
		If (width = 0) Then
			If (animated) Then
				If (width >= height) Then
					width = image.Height()
				Else
					width = image.Width()
				End If
			Else
				width = image.Width()
			End If
		Else
			Local hFrames:Int = image.Width() / width
			If (image.Width() Mod width = hFrames * 2) Then
				width += 2
				paddings |= Image.XPadding
			End If
		End If
		
		If (height = 0) Then
			If (animated) Then
				If (height >= width) Then
					height = image.Width()
				Else
					height = image.Height()
				End If
			Else
				height = image.Height()
			End If
		Else
			Local vFrames:Int = image.Height() / height
			If (image.Height() Mod height = vFrames * 2) Then
				height += 2
				paddings |= Image.YPadding
			End If
		End If
		
		If (animated) Then
			frames = (image.Width() * image.Height()) / (width * height)
		End If
		
		data = image.GrabImage(x, y, width, height, frames, paddings)
	End Method	

End Class