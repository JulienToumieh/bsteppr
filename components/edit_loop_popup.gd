extends Node2D

@export var loopName = ""
@export var loopCount = 0
@export var nextLoop = ""

var loops = ["A", "B", "C", "D", "E", "F", "Ø"]

func _ready():
	position = get_viewport().get_size() / 2
	nextLoop = Globals.loop[loopName][1]
	
	for l in loops:
		get_node("NextLoops/Select" + l).modulate.v = 0.3
	get_node("NextLoops/Select" + nextLoop).modulate.v = 1
	loopCount = Globals.loop[loopName][0]
	get_node("LoopCount/Label").text = str(loopCount)


func updateGlobal():
	get_node("LoopCount/Label").text = str(loopCount)
	for l in loops:
		get_node("NextLoops/Select" + l).modulate.v = 0.3
	get_node("NextLoops/Select" + nextLoop).modulate.v = 1
	Globals.loop[loopName] = [loopCount, nextLoop]
	Globals.updateLoopChips()

func updateLocal():
	get_node("LoopCount/Label").text = str(loopCount)
	for l in loops:
		get_node("NextLoops/Select" + l).modulate.v = 0.3
	get_node("NextLoops/Select" + nextLoop).modulate.v = 1

func _on_close_popup_pressed():
	queue_free()
	updateGlobal()

func _on_sel_a_pressed():
	nextLoop = "A"
	updateLocal()
func _on_sel_b_pressed():
	nextLoop = "B"
	updateLocal()
func _on_sel_c_pressed():
	nextLoop = "C"
	updateLocal()
func _on_sel_d_pressed():
	nextLoop = "D"
	updateLocal()
func _on_sel_e_pressed():
	nextLoop = "E"
	updateLocal()
func _on_sel_f_pressed():
	nextLoop = "F"
	updateLocal()
func _on_sel_o_pressed():
	nextLoop = "Ø"
	updateLocal()

func _on_increase_1_pressed():
	if loopCount < 64: loopCount += 1
	updateLocal()
func _on_increase_2_pressed():
	if loopCount < 64: loopCount += 5
	if loopCount > 64: loopCount = 64
	updateLocal()
func _on_decrease_1_pressed():
	if loopCount != 1: loopCount -= 1
	updateLocal()
func _on_decrease_2_pressed():
	if loopCount > 1: loopCount -= 5
	if loopCount < 1: loopCount = 1
	updateLocal()
