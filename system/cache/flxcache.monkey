Strict

Import flxcacheclayer
Import flxcacheentry

Class FlxCache

#If FLX_CACHE_STRATEGY = "default"
	Const LAYER_SIZE:Int = 1024
	
	Const LAYERS_PER_STATE:Int = 2
	
	Const LAYERS_PER_GAME:Int = 4
#End

Private
	Field _layers:StringMap<FlxCacheLayer>
	
Public
	Method New()
		
	End Method

End Class

Interface FlxCacheable
	
	Method OnCache:FlxCacheEntry()
	
	Method OnCacheComplete:Void(data:Object)

End Interface