extends Node2D

@export var loopName = ""
@export var loopCount = 0
@export var nextLoop = ""

var maxLoopCount = 64

var loops = ["A", "B", "C", "D", "E", "F", "Ø"]

func _ready():
	position = get_viewport().get_size() / 2
	$LoopCount/loopCountSlider.max_value = maxLoopCount
	nextLoop = Globals.loop[loopName][1]
	
	for l in loops:
		get_node("NextLoops/Select" + l).modulate.v = 0.3
	get_node("NextLoops/Select" + nextLoop).modulate.v = 1
	loopCount = Globals.loop[loopName][0]
	get_node("LoopCount/Label").text = str(int(loopCount))
	
	updateLocal()


func updateGlobal():
	get_node("LoopCount/Label").text = str(int(loopCount))
	$LoopCount/loopCountSlider.value = loopCount
	for l in loops:
		get_node("NextLoops/Select" + l).modulate.v = 0.3
	get_node("NextLoops/Select" + nextLoop).modulate.v = 1
	Globals.loop[loopName] = [loopCount, nextLoop]
	Globals.updateLoopChips()
	Globals.loopCounter = Globals.loop[Globals.activeLoop][0]

func updateLocal():
	get_node("LoopCount/Label").text = str(int(loopCount))
	for l in loops:
		get_node("NextLoops/Select" + l).modulate.v = 0.3
	get_node("NextLoops/Select" + nextLoop).modulate.v = 1
	updateGlobal()

func _on_close_popup_pressed():
	#updateGlobal()
	queue_free()

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
	if loopCount < maxLoopCount: loopCount += 1
	updateLocal()
func _on_increase_2_pressed():
	if loopCount < maxLoopCount: loopCount += 5
	if loopCount > maxLoopCount: loopCount = maxLoopCount
	updateLocal()
func _on_decrease_1_pressed():
	if loopCount != 1: loopCount -= 1
	updateLocal()
func _on_decrease_2_pressed():
	if loopCount > 1: loopCount -= 5
	if loopCount < 1: loopCount = 1
	updateLocal()


func _on_loop_count_slider_value_changed(value):
	loopCount = $LoopCount/loopCountSlider.value
	updateLocal()
