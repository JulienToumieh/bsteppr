extends Node2D

@export var beatIDX = Vector2(0, 0)

var Q1 = 0
var Q2 = 0
var Q3 = 0
var Q4 = 0

var buttonTime = 0
var pressed = false
var triggeredHold = false

@onready var timer = $Timer

func _ready():
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	Globals.connect("update_ui", Callable(self, "_on_update_ui"))
	
	var colorTheme = Globals.colorTheme
	
	for i in range(8):
		if beatIDX.y == i : modulate = Color(colorTheme.get("instrumentRowBeats")[i])

func update_theme():
	var colorTheme = Globals.colorTheme
	
	for i in range(8):
		if beatIDX.y == i : modulate = Color(colorTheme.get("instrumentRowBeats")[i])

func _on_update_ui():
	update_theme()
	var beatQ = Globals.activeBeat[beatIDX.x][beatIDX.y]
	
	Q1 = int(beatQ[0])
	Q2 = int(beatQ[1])
	Q3 = int(beatQ[2])
	Q4 = int(beatQ[3])
	
	get_node("BeatQuarter1").visible = true if (Q1 != 0) else false
	get_node("BeatQuarter2").visible = true if (Q2 != 0) else false
	get_node("BeatQuarter3").visible = true if (Q3 != 0) else false
	get_node("BeatQuarter4").visible = true if (Q4 != 0) else false
	
	var val = 0
	for bQ in range(4):
		if val < int(beatQ[bQ]): val = int(beatQ[bQ])
	modulate.v = 0.5 + val/10.0


func _on_step_click_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			match event.button_index:
				1:
					buttonTime = Time.get_ticks_msec()
					pressed = true
					triggeredHold = false
					timer.start() 
				2:
					Globals.editBeatStep(beatIDX)
		elif event.is_released():
			match event.button_index:
				1:
					pressed = false
					timer.stop()
					if not triggeredHold: 
						Globals.activateBeatStep(beatIDX)

func _on_timer_timeout():
	if not triggeredHold:
		triggeredHold = true
		Globals.editBeatStep(beatIDX)
