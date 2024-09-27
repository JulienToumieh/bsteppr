extends Node2D


func _ready():
	pass


func _process(delta):
	get_node("PlayPauseButton/Play").visible = not Globals.playing
	get_node("PlayPauseButton/Pause").visible = Globals.playing


func _on_play_pause_button_pressed():
	Globals.togglePlayback()
