Strict

Import mojo

Import flxg
Import flxbasic
Import flxstate
Import flxcamera
Import flxtimer
Import flxtext

Import plugin.timermanager
Import plugin.monkey.flxassetsmanager

Class FlxGame extends App

Private
	Field _state:FlxState
	
	Field _iState:FlxClassCreator
	
	Field _created:Bool

	Field _lostFocus:Bool
	
	Field _requestedState:FlxState
	
	Field _requestedReset:Bool
	
Public
	Method New(gameSizeX:Int, gameSizeY:Int, initialState:FlxClassCreator, zoom:Float = 1, framerate:Int = 60, useSystemCursor:Bool = False)				
		_lostFocus = False		
		
		FlxG.Init(Self, gameSizeX, gameSizeY, zoom)
		FlxG.framerate = framerate
		
		_state = Null
		
		_iState = initialState
		_requestedState = Null
		_requestedReset = True
		_created = False 				
	End Method
	
	Method OnCreate:Int()
		SetUpdateRate(FlxG.framerate)
		
		FlxG.DEVICE_WIDTH = DeviceWidth()
		FlxG.DEVICE_HEIGHT = DeviceHeight()
		FlxG._deviceScaleFactorX = FlxG.DEVICE_WIDTH / Float(FlxG.width)
		FlxG._deviceScaleFactorY = FlxG.DEVICE_HEIGHT / Float(FlxG.height)		
		
		_InitData()				
		_Step()				
		Return 0
	End Method
	
	Method OnUpdate:Int()
		_Step()
		Return 0
	End Method
	
	Method OnRender:Int()	
		Cls(FlxG._bgColor.r, FlxG._bgColor.g, FlxG._bgColor.b)		
		Scale(FlxG._deviceScaleFactorX, FlxG._deviceScaleFactorY)
		
		Local cam:FlxCamera
		Local cams:Stack<FlxCamera> = FlxG.cameras
		Local i:Int = 0
		Local l:Int = cams.Length()
		
		FlxG._lastDrawingColor = FlxG.WHITE
		FlxG._lastDrawingBlend = GetBlend()		
		
		While(i < l)
			cam = cams.Get(i)
			If (cam = Null Or Not cam.exists Or Not cam.visible) Continue
			
			cam.Lock()
			FlxG.DrawPlugins()
			_state.Draw()
			cam.Unlock()
									
			i+=1
		Wend
								
		Return 0	
	End Method
	
	Method ToString:String()
		Return "FlxGame"	
	End Method
	
Private
	Method _SwitchState:Void()
		FlxG.ResetCameras()
		
		Local timeManager:TimerManager = FlxTimer.Manager()
		If (timeManager <> Null) timeManager.Clear()
		
		If (_state <> Null) _state.Destroy()		
		
		_state = _requestedState
		_state.Create()	
	End Method

	Method _Step:Void()
		If (_requestedReset) Then
			_requestedReset = False
			_requestedState = FlxState(_iState.CreateInstance())
			FlxG.Reset()			
		End If		
		
		If (_state <> _requestedState) _SwitchState()		
		
		_Update()
	End Method
	
	Method _Update:Void()
		FlxG.UpdatePlugins()		
		_state.Update()
		FlxG.UpdateCameras()
	End Method
	
	Method _InitData:Void()
		FlxAssetsManager.Init()
		
		Local minSystemFontSize:Int = 8
		Local maxSystemFontSize:Int = 24
		Local fontPathPrefix:String = FlxG.DATA_PREFIX + FlxText.SYSTEM_FONT + "_font"		
		
		For Local size:Int = minSystemFontSize To maxSystemFontSize
			FlxAssetsManager.RegisterFont(FlxText.SYSTEM_FONT, size, fontPathPrefix + "_fontmachine_" + size + ".txt", FlxText.DRIVER_FONTMACHINE)
			FlxAssetsManager.RegisterFont(FlxText.SYSTEM_FONT, size, fontPathPrefix + "_angelfont_" + size + ".txt", FlxText.DRIVER_ANGELFONT)
		Next	
	End Method
End Class