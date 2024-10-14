extends Node2D

@export var fxName = ""
@export var fxAttr = ""

@export var minVal = 0
@export var maxVal = 100
@export var integer = false

@export var defaultVal = 50.0

var pos
var startPos = 0
var pressed = false

var last_click_time = 0.0
var click_count = 0
var double_click_threshold = 0.25 

func _ready():
	var val = Globals.fx[fxName][fxAttr]
	
	pos = (val - minVal) * 100.0 / (maxVal - minVal)
	
	$KnobArrow.rotation_degrees = (pos * 2.0 / 100.0) * 150.0 - 150.0
	val = minVal + (maxVal - minVal) * pos / 100.0
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
			
		Globals.fx[fxName][fxAttr] = val
		match fxName: 
			"Compressor":
				Globals.updateCompFX()
			"EQ":
				Globals.updateEQFX()
			"Distortion":
				Globals.updateDistFX()
			"Reverb":
				Globals.updateRevFX()

func doubleClick():
	Globals.fx[fxName][fxAttr] = defaultVal
	_ready()



func _on_b_knob_button_down():
	pressed = true
	startPos = get_global_mouse_position()
	var current_time = Time.get_ticks_msec() / 1000.0
	
	if current_time - last_click_time <= double_click_threshold:
		click_count += 1
	else:
		click_count = 1
	
	last_click_time = current_time
	if click_count == 2:
		doubleClick()

func _on_b_knob_button_up():
	pressed = false
