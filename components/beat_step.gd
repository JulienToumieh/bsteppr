extends Node2D

@export var beatIDX = Vector2(0, 0)

var Q1 = 0
var Q2 = 0
var Q3 = 0
var Q4 = 0

var buttonTime = 0

func _ready():
	if beatIDX.y == 0: modulate = Color("FF4141")
	if beatIDX.y == 1: modulate = Color("FF44BF")
	if beatIDX.y == 2: modulate = Color("854BFF")
	if beatIDX.y == 3: modulate = Color("3385FF")
	if beatIDX.y == 4: modulate = Color("00F0FF")
	if beatIDX.y == 5: modulate = Color("3CFF72")
	if beatIDX.y == 6: modulate = Color("4CFF2F")
	if beatIDX.y == 7: modulate = Color("#FF922D")


func _process(delta):
	var beatQ = Globals.activeBeat[beatIDX.x][beatIDX.y]
	
	Q1 = int(beatQ[0])
	Q2 = int(beatQ[1])
	Q3 = int(beatQ[2])
	Q4 = int(beatQ[3])
	
	get_node("BeatQuarter1").visible = true if (Q1 != 0) else false
	get_node("BeatQuarter2").visible = true if (Q2 != 0) else false
	get_node("BeatQuarter3").visible = true if (Q3 != 0) else false
	get_node("BeatQuarter4").visible = true if (Q4 != 0) else false


func _on_step_click_button_down():
	buttonTime = Time.get_ticks_msec()


func _on_step_click_button_up():
	if (Time.get_ticks_msec() - buttonTime) < 500:
		Globals.activateBeat(beatIDX)
