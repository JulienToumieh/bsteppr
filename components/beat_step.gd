extends Node2D

@export var beatIDX = Vector2(0, 0)

var Q1 = 0
var Q2 = 0
var Q3 = 0
var Q4 = 0

var buttonTime = 0
var pressed = false
var triggeredHold = false


func _ready():
	if beatIDX.y == 0: modulate = Color("FF4141")
	if beatIDX.y == 1: modulate = Color("FF44BF")
	if beatIDX.y == 2: modulate = Color("854BFF")
	if beatIDX.y == 3: modulate = Color("3385FF")
	if beatIDX.y == 4: modulate = Color("00F0FF")
	if beatIDX.y == 5: modulate = Color("3CFF72")
	if beatIDX.y == 6: modulate = Color("4CFF2F")
	if beatIDX.y == 7: modulate = Color("#FF922D")
	Globals.connect("update_ui", Callable(self, "_on_update_ui"))

func _on_update_ui():
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


func _process(_delta):
	if pressed:
		if Time.get_ticks_msec() - buttonTime >= 250 and not triggeredHold:
			pressed = false
			triggeredHold = true
			Globals.editBeatStep(beatIDX)


func _on_step_click_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:  
			match event.button_index:
				1:
					buttonTime = Time.get_ticks_msec()
					pressed = true
					triggeredHold = false
				2:
					Globals.editBeatStep(beatIDX)
		elif event.is_released():
			match event.button_index:
				1:
					pressed = false
					if not triggeredHold: 
						Globals.activateBeatStep(beatIDX)
