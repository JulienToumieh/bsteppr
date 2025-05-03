extends Node2D

@export var instrumentID = 0

func _ready():
	
	var colorTheme = Globals.colorTheme
	
	for i in range(8):
		if instrumentID == i+1 : modulate = Color(colorTheme.get("instrumentRows")[i])
	
	
	Globals.connect("update_ui", Callable(self, "_on_update_ui"))

func _on_update_ui():
	if instrumentID <= Globals.instrumentNames.size():
		get_node("Button").text = Globals.instrumentNames[instrumentID-1].substr(3).get_basename()


func _on_button_pressed():
	Globals.get_node("Instrument" + str(instrumentID)).volume_db = 0
	Globals.playSound(instrumentID)
