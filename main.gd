extends Node2D

var EditBeatPopup = preload("res://scenes/edit_beat_popup.tscn")
var EditLoopPopup = preload("res://scenes/edit_loop_popup.tscn")
var EditTempoPopup = preload("res://scenes/edit_tempo_popup.tscn")
var ChangeKitPopup = preload("res://scenes/change_kit_popup.tscn")
var LoopContainer = preload("res://scenes/loop_chip_container.tscn")

func _ready():
	Globals.connect("update_ui", Callable(self, "_on_update_ui"))
	_on_update_ui()

func _on_update_ui():
	get_node("PlayPauseButton/Play").visible = not Globals.playing
	get_node("PlayPauseButton/Pause").visible = Globals.playing
	get_node("TempoDisp/Tempo").text = str(Globals.bpm)
	get_node("TempoDisp/Swing").text = str(Globals.swing) + "%"
	updateBarIndicator()

func updateBarIndicator():
	get_node("BarIndicator/b1").modulate.a = 0.3
	get_node("BarIndicator/b2").modulate.a = 0.3
	get_node("BarIndicator/b3").modulate.a = 0.3
	get_node("BarIndicator/b4").modulate.a = 0.3
	match Globals.barRound - 1:
		0:
			get_node("BarIndicator/b1").modulate.a = 1
		1:
			get_node("BarIndicator/b2").modulate.a = 1
		2:
			get_node("BarIndicator/b3").modulate.a = 1
		3:
			get_node("BarIndicator/b4").modulate.a = 1

func _on_play_pause_button_pressed():
	Globals.togglePlayback()

func createEditBeatPopup(beatIDX):
	var bEditPopup = EditBeatPopup.instantiate()
	bEditPopup.beatIDX = beatIDX
	add_child(bEditPopup)

func createEditLoopPopup(loopName):
	var lEditPopup = EditLoopPopup.instantiate()
	lEditPopup.loopName = loopName
	add_child(lEditPopup)

func createChangeKitPopup():
	var kChangePopup = ChangeKitPopup.instantiate()
	add_child(kChangePopup)

func _on_tempo_button_pressed():
	var tEditPopup = EditTempoPopup.instantiate()
	add_child(tEditPopup)


func _on_b_drum_kit_pressed():
	createChangeKitPopup()


func _on_b_settings_pressed():
	pass # Replace with function body.
