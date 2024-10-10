extends Node2D

@export var minVal = 0
@export var maxVal = 100

@export var pos = 50

var pressed = false

var startPos = 0

func _ready():
	$KnobArrow.rotation_degrees = (pos*2/100)*150 - 150
	$KnobVal.text = str(int(pos))


func _process(delta):
	if pressed:
		pos += (get_global_mouse_position() - startPos).x/2
		startPos = get_global_mouse_position()
		if pos > 100: pos = 100
		if pos < 0: pos = 0
		$KnobArrow.rotation_degrees = (pos*2/100)*150 - 150
		$KnobVal.text = str(int(pos))


func _on_b_knob_button_down():
	pressed = true
	startPos = get_global_mouse_position()

func _on_b_knob_button_up():
	pressed = false
