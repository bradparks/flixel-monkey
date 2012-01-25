Strict

Import flixel.flxg
Import replay.keyrecord
Import replay.xyrecord
Import replay.xyzrecord
Import replay.framerecord

Class FlxReplay
	
	Field seed:Float
	
	Field frame:Int
	
	Field frameCount:Int
	
	Field finished:Bool
	
Private
	Field _frames:FrameRecord[]
	
	Field _capacity:Int
	
	Field _marker:Int
	
Public
	Method New()
		seed = 0
		frame = 0
		frameCount = 0
		finished = False
		_frames = []
		_capacity = 0
		_marker = 0
	End Method
	
	Method Destroy:Void()
		If (_frames.Length() = 0) Return
		
		Local i:Int = frameCount - 1
		
		While (i >= 0)
			_frames[i].Destroy()
			i -= 1
		Wend
		
		_frames = []
	End Method	
	
	Method Create:Void(seed:Int)
		Destroy()
		_Init()
		Self.seed = seed
		Rewind()
	End Method
	
	Method Load:Void(fileContents:String)
		_Init()
		
		Local lines:String[] = fileContents.Split("~n")
		
		seed = Int(lines[0])
		
		Local line:String
		Local i:Int = 1
		Local l:Int = lines.Length()
		
		While (i < l)
			line = lines[i]
			
			If (line.Length() > 3) Then
				_frames[frameCount] = (New FrameRecord()).Load(line)
				frameCount += 1
				
				If (frameCount >= _capacity) Then
					_capacity *= 2
					_frames = _frames.Resize(_capacity)
				End If				
			End If
			
			i += 1
		Wend
		
		Rewind()
	End Method
	
	Method Save:String()
		If (frameCount <= 0) Return ""
		
		Local output:StringStack = New StringStack()		
		output.Push(FlxG.globalSeed + "~n")	
		
		Local i:Int = 0
		While (i < frameCount)
			_frames[i].Save(output)
			output.Push("~n")
			i += 1
		Wend
	
		Return output.Join("")
	End Method
	
	Method RecordFrame:Void()
		Local accelRecord:XYZRecord
		Local joystickRecord:Stack<XYZRecord[]>
		Local touchRecord:Stack<XYRecord>
		Local keysRecord:Stack<KeyRecord>
		Local mouseRecord:XYRecord
		
		#If TARGET = "html5" Or TARGET = "ios" Or TARGET = "android"
			accelRecord = FlxG.accel.RecordXYZ()
		#End		
		
		#If TARGET = "xna" Or TARGET = "glfw"
			If (Not FlxG.mobile) Then
				Local joyCount:Int = FlxG.JoystickCount()
				Local joyXYZRecord:XYZRecord[]
			
				For Local i:Int = 0 Until joyCount
					joyXYZRecord = FlxG.Joystick(i).RecordXYZ()
					
					If (joyXYZRecord.Length() > 0) Then
						If (joystickRecord = Null) joystickRecord = New Stack<XYZRecord[]>()
						joystickRecord.Insert(i, FlxG.Joystick(i).RecordXYZ())
					End If				
					
					keysRecord = FlxG.Joystick(i).RecordKeys(keysRecord)
				Next
			End If
		#End
		
		#If TARGET = "ios" Or TARGET = "android"
			Local touchCount:Int = FlxG.TouchCount()
			Local touchXYRecord:XYRecord
		
			For Local i:Int = 0 Until touchCount
				touchXYRecord = FlxG.Touch(i).RecordXY()
			
				If (touchXYRecord <> Null) Then
					If (touchRecord = Null) touchRecord = New Stack<XYRecord>()				
					touchRecord.Insert(i, FlxG.Touch(i).RecordXY())
				End If
				
				keysRecord = FlxG.Touch(i).RecordKeys(keysRecord)
							
				If (i <> touchCount - 1 And Not FlxG.Touch(i + 1).Used()) Exit
			Next
		#ElseIf TARGET = "xna" Or TARGET = "html5"
			If (Not FlxG.mobile) Then
				keysRecord = FlxG.keys.RecordKeys(keysRecord)	
			End If
		#Else
			keysRecord = FlxG.keys.RecordKeys(keysRecord)		
		#End
		
		#If TARGET = "html5" Or TARGET = "xna" Or TARGET = "glfw"
			Local touchXYRecord:XYRecord = FlxG.Touch(0).RecordXY()
			
			If (touchXYRecord <> Null) Then
				If (touchRecord = Null) touchRecord = New Stack<XYRecord>()				
				touchRecord.Insert(0, FlxG.Touch(0).RecordXY())
			End If
			
			keysRecord = FlxG.Touch(0).RecordKeys(keysRecord)
		#End 
		
		mouseRecord = FlxG.mouse.RecordXY()
		keysRecord = FlxG.mouse.RecordKeys(keysRecord)
		
		If (keysRecord = Null And mouseRecord = Null And joystickRecord = Null And touchRecord = Null And accelRecord = Null) Then
			frame += 1
			Return
		End If
		
		_frames[frameCount] = (New FrameRecord()).Create(frame, keysRecord, mouseRecord, joystickRecord, touchRecord, accelRecord)
		frame += 1
		frameCount += 1
		
		If (frameCount >= _capacity) Then
			_capacity *= 2
			_frames = _frames.Resize(_capacity)
		End If
	End Method
	
	Method PlayNextFrame:Void()			
		FlxG.ResetInput()
		
		If (_marker >= frameCount) Then
			finished = True
			Return
		End If
		
		If (_frames[_marker].frame <> frame) Then
			frame += 1
			Return
		End If
		
		frame += 1
		
		Local fr:FrameRecord = _frames[_marker]
		_marker += 1
		
		If (fr.keys <> Null) FlxG.keys.PlaybackKeys(fr.keys)
		If (fr.mouse <> Null) FlxG.mouse.PlaybackXY(fr.mouse)
		
		If (fr.joystick <> Null) Then
			Local i:Int = 0
			Local l:Int = fr.joystick.Length()
			
			While (i < l)
				FlxG.Joystick(i).PlaybackXYZ(fr.joystick.Get(i))
				i += 1
			Wend			
		End If
		
		If (fr.touch <> Null) Then
			Local i:Int = 0
			Local l:Int = FlxG.TouchCount()
			Local tr:XYRecord
			
			While (i < l)
				tr = fr.touch.Get(i)				
				If (tr = Null) Exit	
			
				FlxG.Touch(i).PlaybackXY(tr)
				
				i += 1
			Wend			
		End If
		
		If (fr.accel <> Null) FlxG.accel.PlaybackXYZ(fr.accel)
	End Method
	
	Method Rewind:Void()
		_marker = 0
		frame = 0
		finished = False
	End Method
	
Private
	Method _Init:Void()
		_capacity = 100
		_frames = _frames.Resize(_capacity)
		frameCount = 0
	End Method

End Class

Interface FlxReplayListener
	
	Method OnReplayComplete:Void()

End Interface