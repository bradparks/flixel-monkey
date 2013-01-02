Strict

Import flxcacheatlas

Class FlxCache

#If FLX_CACHE_STRATEGY = "default"
	Const ATLAS_SIZE:Int = 1024
	
	Const ATLASES_PER_STATE:Int = 2
	
	Const ATLASES_PER_GAME:Int = 4
#End

Private
	Field _atlasCache:StringMap<FlxCacheAtlas>
	
	Field _assetCache:StringMap<Image>
	
	Field _imageCache:StringMap<Image>
	
Public
	Method New()
		
	End Method

End Class

Interface FlxCacheable
	
	Method OnCache:Object()
	
	Method OnCacheComplete:Void(data:Object)
	
	Method GetCacheKey:String()

End Interface