extends Node2D

@export var LoopName = "X"
@export var LoopCount = 1
@export var NextLoop = "X"

func _ready():
	$LoopName.text = LoopName
	$LoopCount.text = "x" + str(LoopCount)
	$NextLoop.text = NextLoop


func _process(delta):
	pass
