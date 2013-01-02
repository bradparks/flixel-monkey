Strict

Import cache.flxcacheatlas
Import cache.flxcacheentry

Class FlxCache

#If FLX_CACHE_STRATEGY = "default"
	Const ATLAS_SIZE:Int = 1024
	
	Const ATLASES_PER_STATE:Int = 2
	
	Const ATLASES_PER_GAME:Int = 4
#End

Private
	Field _itemsToCache:StringMap<FlxCacheEntry>

	Field _atlases:StringMap<FlxCacheAtlas>
	
	Field _images:StringMap<Image>
	
Public
	Method New()
		_images = New StringMap<Image>
	End Method
	
	Method Get:Image(key:String)
		Return _images.Get(key)
	End Method
	
	Method Has:Bool(key:String)
		Return (_images.Get(key) <> Null)
	End Method
	
	Method Put:Void(key:String, image:Image)
		_images.Set(key, image)
	End Method
	
	Method Forget:Void(key:String, discard:Bool = True)
		If (discard) Then
			Local image:Image = Get(key)
			If (image <> Null) image.Discard()
		End If
		
		_images.Remove(key)
	End Method
	
	#Rem
	Method PutImage:Void(key:String, image:Image)
		If ( Not HasImage(key)) Then
			_images.Set(key, image)
		Else
			Local i:Int = 0
			Local ukey:String = key + i
			
			While (HasImage(ukey))
				i += 1
				ukey = key + i
			Wend
			
			_images.Set(ukey, image)
		End If
	End Method
	#End

End Class

Interface FlxCacheable
	
	Method OnCache:FlxCacheEntry()
	
	Method OnCacheComplete:Void(data:Image)

End Interface