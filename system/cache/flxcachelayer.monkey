Strict

Import flixel.system.flximagedata

Class FlxCacheLayer Extends FlxImageData

Private
	Field _availableSpace:Int
	
Public
	Method New(size:Int)
		Super.New(size, size)
		_availableSpace = size * size
	End Method
	
	Method Add:Bool(data:Image)
		
	End Method

End Class