extends Node2D

@export var fxName = ""
@export var fxAttr = ""

@export var minVal = 0
@export var maxVal = 100
@export var integer = false

@export var initVal = 50

var pos

var pressed = false

var startPos = 0

func _ready():
	pos = (initVal - minVal) * 100.0 / (maxVal - minVal)
	
	$KnobArrow.rotation_degrees = (pos * 2.0 / 100.0) * 150.0 - 150.0
	var val = minVal + (maxVal - minVal) * pos / 100.0
	if abs(abs(maxVal) - abs(minVal)) > 5:
		$KnobVal.text = str(int(val))
	else:
		$KnobVal.text = str("%.2f" % val)
	$Label.text = name


func _process(_delta):
	if pressed:
		if abs((get_global_mouse_position() - startPos).y) > abs((get_global_mouse_position() - startPos).x):
			pos -= (get_global_mouse_position() - startPos).y / 2
		else:
			pos += (get_global_mouse_position() - startPos).x / 2
		startPos = get_global_mouse_position()
		if pos > 100: pos = 100
		if pos < 0: pos = 0
		$KnobArrow.rotation_degrees = (pos * 2.0 / 100.0) * 150.0 - 150.0
		var val = minVal + (maxVal - minVal) * pos / 100.0
		if abs(abs(maxVal) - abs(minVal)) > 5:
			$KnobVal.text = str(int(val))
		else:
			$KnobVal.text = str("%.2f" % val)


func _on_b_knob_button_down():
	pressed = true
	startPos = get_global_mouse_position()

func _on_b_knob_button_up():
	pressed = false
