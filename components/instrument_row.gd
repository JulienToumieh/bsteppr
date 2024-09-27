extends Node2D

@export var instrumentID = 0

func _ready():
	if instrumentID == 0: modulate = Color("FF4141")
	if instrumentID == 1: modulate = Color("FF44BF")
	if instrumentID == 2: modulate = Color("854BFF")
	if instrumentID == 3: modulate = Color("3385FF")
	if instrumentID == 4: modulate = Color("00F0FF")
	if instrumentID == 5: modulate = Color("3CFF72")
	if instrumentID == 6: modulate = Color("4CFF2F")
	if instrumentID == 7: modulate = Color("#FF922D")


func _process(delta):
	pass


func _on_button_pressed():
	Globals.playSound(instrumentID)