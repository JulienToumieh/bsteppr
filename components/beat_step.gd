extends Node2D

@export var beatIDX = Vector2(0, 0)

var Q1 = 0
var Q2 = 0
var Q3 = 0
var Q4 = 0

func _ready():
	pass


func _process(delta):
	var beatQ = Globals.activeBeat[beatIDX.x][beatIDX.y]
	
	Q1 = int(beatQ[0])
	Q2 = int(beatQ[1])
	Q3 = int(beatQ[2])
	Q4 = int(beatQ[3])
	
	get_node("BeatQuarter1").visible = true if (Q1 != 0) else false
	get_node("BeatQuarter2").visible = true if (Q2 != 0) else false
	get_node("BeatQuarter3").visible = true if (Q3 != 0) else false
	get_node("BeatQuarter4").visible = true if (Q4 != 0) else false
