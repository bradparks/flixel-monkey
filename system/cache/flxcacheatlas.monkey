Strict

#Rem
	Packing algorithm from http://wiki.unity3d.com/index.php?title=MaxRectsBinPack
#end

Import flixel.flxrect
Import flixel.system.flximagedata

Class FlxCacheAtlas

	Const RECT_BEST_SHORT_SIDE_FIT:Int = 0
	
	Const RECT_BEST_LONG_SIDE_FIT:Int = 1
	
	Const RECT_BEST_AREA_FIT:Int = 2
	
	Const RECT_BOTTOM_LEFT_RULE:Int = 3
	
	Const RECT_CONTACT_POINT_RULE:Int = 4

Private
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
	
	Method SplitFreeNode:Bool(freeNode:FlxRect, usedNode:FlxRect)
		If (usedNode.x >= freeNode.x + freeNode.width Or usedNode.x + usedNode.width <= freeNode.x Or usedNode.y >= freeNode.y + freeNode.height Or usedNode.y + usedNode.height <= freeNode.y) Then
			Return False
		End If
		
		If (usedNode.x < freeNode.x + freeNode.width And usedNode.x + usedNode.width > freeNode.x) Then
			If (usedNode.y > freeNode.y And usedNode.y < freeNode.y + freeNode.height) Then
				_freeRectangles.Push(New FlxRect(freeNode.x, freeNode.y, freeNode.width, usedNode.y - freeNode.y))
			End If
			
			If (usedNode.y + usedNode.height < freeNode.y + freeNode.height) Then
				_freeRectangles.Push(New FlxRect(freeNode.x, usedNode.y + usedNode.height, freeNode.width, freeNode.y + freeNode.height - (usedNode.y + usedNode.height)))
			End If
		End If
		
		If (usedNode.y < freeNode.y + freeNode.height And usedNode.y + usedNode.height > freeNode.y)
			If (usedNode.y > freeNode.y And usedNode.y < freeNode.y + freeNode.height) Then
				_freeRectangles.Push(New FlxRect(freeNode.x, freeNode.y, usedNode.x - freeNode.x, freeNode.height))
			End If
			
			If (usedNode.y + usedNode.height < freeNode.y + freeNode.height) Then
				_freeRectangles.Push(New FlxRect(usedNode.x + usedNode.width, freeNode.y, freeNode.x + freeNode.width - (usedNode.x + usedNode.width), freeNode.height))
			End If			
		End If
		
		Return True
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