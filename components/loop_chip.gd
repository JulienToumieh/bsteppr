extends Node2D

@export var loopName = "X"
@export var loopCount = 1
@export var nextLoop = "X"

var buttonTime = 0
var pressed = false
var triggeredHold = false

@onready var timer = $Timer

func _ready():
	$LoopName.text = loopName
	_on_update_ui()
	Globals.connect("update_ui", Callable(self, "_on_update_ui"))
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	
	var colorTheme = Globals.colorTheme
	get_node("px").modulate = Color(colorTheme.get("loopChip"))

func _on_update_ui():
	if loopName != Globals.activeLoop: modulate.v = 0.4
	else: modulate.v = 1
	$LoopCount.text = "x" + str(int(Globals.loop[loopName][0]))
	$NextLoop.text = Globals.loop[loopName][1]
	
	var colorTheme = Globals.colorTheme
	get_node("px").modulate = Color(colorTheme.get("loopChip"))


func _on_loop_chip_button_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:  
			match event.button_index:
				1:
					buttonTime = Time.get_ticks_msec()
					pressed = true
					triggeredHold = false
					timer.start()
				2:
					Globals.editLoop(loopName)
		elif event.is_released():
			match event.button_index:
				1:
					pressed = false
					timer.stop()
					if not triggeredHold:
						Globals.selectBeatLoop(loopName)


func _on_timer_timeout():
	if not triggeredHold:
		triggeredHold = true
		Globals.editLoop(loopName)
