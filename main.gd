extends Node2D

var EditBeatPopup = preload("res://components/edit_beat_popup.tscn")
var EditLoopPopup = preload("res://components/edit_loop_popup.tscn")
var LoopContainer = preload("res://scenes/loop_chip_container.tscn")

func _ready():
	Globals.connect("update_ui", Callable(self, "_on_update_ui"))

func _on_update_ui():
	get_node("PlayPauseButton/Play").visible = not Globals.playing
	get_node("PlayPauseButton/Pause").visible = Globals.playing
	get_node("BeatGrid").updateTrackerPos()

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
