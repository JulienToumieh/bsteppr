extends Node2D

@export var loopName = "X"
@export var loopCount = 1
@export var nextLoop = "X"

var buttonTime = 0
var pressed = false
var triggeredHold = false

func _ready():
	$LoopName.text = loopName
	$LoopCount.text = "x" + str(loopCount)
	$NextLoop.text = nextLoop


func _process(delta):
	if pressed:
		if Time.get_ticks_msec() - buttonTime >= 250 and not triggeredHold:
			pressed = false
			triggeredHold = true
			#Globals.editBeatStep(beatIDX)


func _on_loop_chip_button_button_down():
	buttonTime = Time.get_ticks_msec()
	pressed = true
	triggeredHold = false


func _on_loop_chip_button_button_up():
	pressed = false
	if not triggeredHold:
		Globals.selectBeatLoop(loopName)
