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

	Field _usedRectangles:Stack<ImageRect>
	
	Field _freeRectangles:Stack<FlxRect>
	
	Field _atlasData:FlxImageData
	
	Field _score1:Int
	
	Field _score2:Int
	
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
	
	Method FindPositionForNewNodeContactPoint:FlxRect(width:Int, height:Int)
		Return Null
	End Method
	
	Method ContactPointScoreNode:Int(x:Int, y:Int, width:Int, height:Int)
		Local score:Int = 0
		
		If (x = 0 Or x + width = _width) score += height
		If (y = 0 Or y + height = _height) score += width
		
		Local i:Int = 0, l:Int = _usedRectangles.Length(), rect:FlxRect
		
		While (i < l)
			rect = _usedRectangles.Get(i)
			
			If (rect.x = x + width Or rect.x + rect.width = x) Then
				score += CommonIntervalLength(rect.y, rect.y + rect.height, y, y + height)
			End If
			
			If (rect.y = y + height Or rect.y + rect.height = y) Then
				score += CommonIntervalLength(rect.x, rect.x + rect.width, x, x + width)
			End If
			
			i += 1
		Wend
		
		Return score
	End Method
	
	Method CommonIntervalLength:Int(i1start:Int, i1end:Int, i2start:Int, i2end:Int)
		If (i1end < i2start Or i2end < i1start) Return 0
		Return Min(i1end, i2end) - Max(i1start, i2start)
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
	
	Method IsContainedIn:Bool(a:FlxRect, b:FlxRect)
		Return (a.x >= b.x And a.y >= b.y And a.Right < b.Right And a.Bottom <= b.Bottom)
	End Method

End Class

Private
Class ImageRect Extends FlxRect

	Field image:Image
	
	Method New(image:Image)
		Super.New()
		Self.image = image
	End Method

End Class