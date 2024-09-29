extends Node2D

var EditBeatPopup = preload("res://components/edit_beat_popup.tscn")

func _ready():
	pass


func _process(delta):
	get_node("PlayPauseButton/Play").visible = not Globals.playing
	get_node("PlayPauseButton/Pause").visible = Globals.playing


func _on_play_pause_button_pressed():
	Globals.togglePlayback()

func createEditBeatPopup(beatIDX):
	var bEditPopup = EditBeatPopup.instantiate()
	bEditPopup.beatIDX = beatIDX
	add_child(bEditPopup)
