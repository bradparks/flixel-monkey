Strict

Class FlxAsset<T> Abstract

	Field name:String
	
	Field path:String
	
	Field data:T
	
	Method New(name:String, path:String)
		Self.name = name
		Self.path = path
	End Method
	
	Method Load:Void() Abstract
	
End Class