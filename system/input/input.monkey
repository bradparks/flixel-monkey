Strict

Import mojo

Import flixel.flxg
Import flixel.system.replay.keyrecord

Class Input Abstract	
	
Private
	Global _map:InputState[KEY_TOUCH0 + 32]
	
	Field _from:Int
	Field _to:Int
	
Public
	Method New(fromKey:Int, toKey:Int)
		If (_map[0] = Null) Then
			Local i:Int = 0			
			Local l:Int = _map.Length()		
			
			While (i < l)
				_map[i] = New InputState()
				i += 1
			Wend
		End If
		
		_from = fromKey
		_to = toKey + 1	
	End Method
	
	Method Update:Void()
		Local i:Int = _from
		Local is:InputState
		
		While (i < _to)
			is = _map[i]
			
			If (KeyDown(i)) Then
				If (is.last < 1) Then
					is.current = 2
				Else
					is.current = 1
				End If
			Else
				If (is.last > 0) Then
					is.current = -1
				Else
					is.current = 0
				End If
			End If
			
			is.last = is.current
			i += 1
		Wend
	End Method
	
	Method Update:Void(x:Float, y:Float)
		Return
	End Method
	
	Method Reset:Void()
		Local i:Int = _from
		Local is:InputState
		 	
		While (i < _to)
			is = _map[i]			
			is.current = 0
			is.last = 0
			i += 1
		Wend
	End Method
	
	Method Pressed:Bool()
		Return False
	End Method
	
	Method JustPressed:Bool()
		Return False
	End Method
	
	Method JustReleased:Bool()
		Return False
	End Method
	
	Method Used:Bool()
		Return False
	End Method
	
	Method Pressed:Bool(key:Int)
		Return _map[key].current > 0
	End Method
	
	Method JustPressed:Bool(key:Int)
		Return _map[key].current = 2
	End Method
	
	Method JustReleased:Bool(key:Int)
		Return _map[key].current = -1
	End Method
	
	Method Used:Bool(key:Int)
		Return _map[key].current <> 0
	End Method
	
	Method RecordKeys:Stack<KeyRecord>(data:Stack<KeyRecord> = Null)
		Local i:Int = _from
		Local is:InputState
		
		While (i < _to)
			is = _map[i]
			i += 1
			
			If (is.current = 0) Continue
			
			If (data = Null) Then
				data = New Stack<KeyRecord>()
			End If
			
			data.Push(New KeyRecord(i - 1, is.current))		
		Wend
		
		Return data
	End Method
	
	Method PlaybackKeys:Void(record:Stack<KeyRecord>)
		Local i:Int = 0
		Local l:Int = record.Length()
		Local kr:KeyRecord
		
		While (i < l)
			kr = record.Get(i)
			_map[kr.code].current = kr.value
			i += 1
		Wend
	End Method
	
	Method Any:Bool()
		Local i:Int = _from
		 	
		While (i < _to)
			If (_map[i].current > 0) Return True
			i += 1
		Wend
		
		Return False
	End Method
	
	Method Destroy:Void()
		Local i:Int = _from
		 	
		While (i < _to)
			_map[i] = Null
			i += 1
		Wend
		
		_to = 0
	End Method

End Class

Private
Class InputState
	
	Field current:Int
	Field last:Int
	
	Method New()
		current = 0
		last = 0	
	End Method

End Class