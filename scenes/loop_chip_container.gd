extends Node2D

var loopChip = preload("res://components/loop_chip.tscn")


func _ready():
	var x = 0
	var y = 0
	
	for i in range(6):
		var lc = loopChip.instantiate()
		lc.position = Vector2(i*174, 0)
		lc.name = "LoopChip" + str(i + 1)
		lc.loopName = Globals.loop.keys()[i]
		lc.loopCount = Globals.loop[Globals.loop.keys()[i]][0]
		lc.nextLoop = Globals.loop[Globals.loop.keys()[i]][1]
		add_child(lc)
	
