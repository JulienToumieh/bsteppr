extends Node2D

var EditBeatPopup = preload("res://components/edit_beat_popup.tscn")
var EditLoopPopup = preload("res://components/edit_loop_popup.tscn")
var LoopContainer = preload("res://scenes/loop_chip_container.tscn")

func _ready():
	resetLoopContainer()


func _process(delta):
	$Label.text = str(Globals.loopCounter) + " " + Globals.activeLoop
	get_node("PlayPauseButton/Play").visible = not Globals.playing
	get_node("PlayPauseButton/Pause").visible = Globals.playing


func _on_play_pause_button_pressed():
	Globals.togglePlayback()


func resetLoopContainer():
	if get_node("LoopChipContainer"):
		get_node("LoopChipContainer").queue_free()
	await get_tree().process_frame
	await get_tree().process_frame
	var loopContainer = LoopContainer.instantiate()
	loopContainer.position = Vector2(305, 690)
	loopContainer.name = "LoopChipContainer"
	add_child(loopContainer)

func createEditBeatPopup(beatIDX):
	var bEditPopup = EditBeatPopup.instantiate()
	bEditPopup.beatIDX = beatIDX
	add_child(bEditPopup)

func createEditLoopPopup(loopName):
	var lEditPopup = EditLoopPopup.instantiate()
	lEditPopup.loopName = loopName
	add_child(lEditPopup)
