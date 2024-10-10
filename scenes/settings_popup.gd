extends Node2D


func _ready():
	position = get_viewport().get_size() / 2


func _on_close_popup_pressed():
	queue_free()
