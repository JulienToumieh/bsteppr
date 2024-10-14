extends Button

@export var fxName = ""
@export var fxAttr = ""

var modes = ["Clip", "ATan", "LoFi", "OvrDrv", "WavShp"]

var mode = 0

func _ready():
	mode = modes.find(Globals.fx[fxName][fxAttr])
	text = modes[mode]

func _on_pressed():
	if mode == 4:
		mode = 0
	else:
		mode += 1
	text = modes[mode]
	Globals.fx[fxName][fxAttr] = modes[mode]
	Globals.updateDistFX()
