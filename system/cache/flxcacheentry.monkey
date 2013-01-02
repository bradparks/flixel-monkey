Strict

Import mojo.graphics
Import flixel.flxrect

Class FlxCacheEntry Extends FlxRect
	
	Field key:String
	
	Field data:Image
	
	Method New(key:String, image:Image)
		Super.New()
		Self.key = key
		Self.image = image
	End Method

End Class