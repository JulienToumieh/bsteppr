extends Node2D

@export var instrumentID = 0

func _ready():
	if instrumentID == 1: modulate = Color("FF4141")
	if instrumentID == 2: modulate = Color("FF44BF")
	if instrumentID == 3: modulate = Color("854BFF")
	if instrumentID == 4: modulate = Color("3385FF")
	if instrumentID == 5: modulate = Color("00F0FF")
	if instrumentID == 6: modulate = Color("3CFF72")
	if instrumentID == 7: modulate = Color("4CFF2F")
	if instrumentID == 8: modulate = Color("#FF922D")
	
	Globals.connect("update_ui", Callable(self, "_on_update_ui"))

func _on_update_ui():
	get_node("Button").text = Globals.instrumentNames[instrumentID-1].substr(3).get_basename()


func _on_button_pressed():
	Globals.get_node("Instrument" + str(instrumentID)).volume_db = 0
	Globals.playSound(instrumentID)
