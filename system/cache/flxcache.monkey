Strict

Import flxcacheatlas
Import flxcacheentry

Class FlxCache

#If FLX_CACHE_STRATEGY = "default"
	Const ATLAS_SIZE:Int = 1024
	
	Const ATLASES_PER_STATE:Int = 2
	
	Const ATLASES_PER_GAME:Int = 4
#End

Private
	Field _layers:StringMap<FlxCacheAtlas>
	
Public
	Method New()
		
	End Method

End Class

Interface FlxCacheable
	
	Method OnCache:FlxCacheEntry()
	
	Method OnCacheComplete:Void(data:Object)

End Interface