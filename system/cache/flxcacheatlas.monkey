Strict

#Rem
	Packing algorithm from http://wiki.unity3d.com/index.php?title=MaxRectsBinPack
#end

Import flixel.flxrect
Import flixel.system.flximagedata

Class FlxCacheAtlas

Private
	Const _RECT_BEST_SHORT_SIDE_FIT:Int = 0
	
	Const _RECT_BEST_LONG_SIDE_FIT:Int = 1
	
	Const _RECT_BEST_AREA_FIT:Int = 2
	
	Const _RECT_BOTTOM_LEFT_RULE:Int = 3
	
	Const _RECT_CONTACT_POINT_RULE:Int = 4
	
	Field _width:Int
	
	Field _height:Int

	Field _usedRectangles:Stack<FlxRect>
	
	Field _freeRectangles:Stack<FlxRect>
	
	Field _atlasData:FlxImageData
	
Public
	Method New(size:Int)
		_atlasData = New FlxImageData(size, size)
		_width = size
		_height = size
		Clear()
	End Method
	
	Method Destroy:Void()
		_atlasData.Destroy(True)
		_usedRectangles.Clear()
		_freeRectangles.Clear()
		
		_atlasData = Null
		_usedRectangles = Null
		_freeRectangles = Null
	End Method
	
	Method Clear:Void()
		_usedRectangles.Clear()
		_freeRectangles.Clear()
		_freeRectangles.Push(New FlxRect(0, 0, _width, _height))
	End Method
	
	Method SplitFreeNode:Bool()
		Return False
	End Method
	
	Method PruneFreeList:Void()
		Local i:Int = 1, j:Int, l:Int = _freeRectangles.Length()
		
		While (i < l)
			j = i + 2
			
			While (j < l)
				If (IsContainedIn(_freeRectangles.Get(i), _freeRectangles.Get(j))) Then
					_freeRectangles.Remove(i)
					i -= 1
					Exit
				End If
				
				If (IsContainedIn(_freeRectangles.Get(j), _freeRectangles.Get(i))) Then
					_freeRectangles.Remove(j)
					j -= 1
				End If
			Wend
			
			i += 1
		Wend
	End Method
	
	Method IsContainedIn(a:FlxRect, b:FlxRect)
		Return (a.x >= b.x And a.y >= b.y And a.Right < b.Right And a.Bottom <= b.Bottom)
	End Method

End Class