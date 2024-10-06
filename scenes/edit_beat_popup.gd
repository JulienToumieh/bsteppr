extends Node2D

@export var beatIDX = Vector2(0,0)
var beatVal = "0000"

func _ready():
	position = get_viewport().get_size() / 2
	
	for bQ in range(4):
		if get_node("VelocitySlider").value < int(beatVal[bQ]): get_node("VelocitySlider").value = int(beatVal[bQ])
		
		beatVal = Globals.activeBeat[beatIDX.x][beatIDX.y]
		updateGlobal()

func _on_close_popup_pressed():
	queue_free()

func updateGlobal():
	Globals.activeBeat[beatIDX.x][beatIDX.y] = beatVal
	
	for bQ in range(4):
		beatVal = Globals.activeBeat[beatIDX.x][beatIDX.y]
		if beatVal[bQ] == "0":
			get_node("BeatEditQuarter" + str(bQ+1)).modulate = Color(1, 1, 1, 0.2)
		else:
			get_node("BeatEditQuarter" + str(bQ+1)).modulate = Color(1, 1, 1, 1)
	
	Globals.updateUI()

func _on_velocity_slider_drag_ended(_value_changed):
	if beatVal == "0000":
		beatVal = str(int(get_node("VelocitySlider").value)) + str(int(get_node("VelocitySlider").value)) + str(int(get_node("VelocitySlider").value)) + str(int(get_node("VelocitySlider").value))
	else:
		for v in range(4):
			if beatVal[v] != "0": beatVal[v] = str(int(get_node("VelocitySlider").value))
	updateGlobal()


func _on_b_q_1_pressed():
	var v = 1
	if beatVal[v-1] == "0":
		if get_node("VelocitySlider").value == 0:
			get_node("VelocitySlider").value = 5
		beatVal[v-1] = str(int(get_node("VelocitySlider").value))
	else:
		beatVal[v-1] = "0"
	updateGlobal()


func _on_b_q_2_pressed():
	var v = 2
	if beatVal[v-1] == "0":
		if get_node("VelocitySlider").value == 0:
			get_node("VelocitySlider").value = 5
		beatVal[v-1] = str(int(get_node("VelocitySlider").value))
	else:
		beatVal[v-1] = "0"
	updateGlobal()


func _on_b_q_3_pressed():
	var v = 3
	if beatVal[v-1] == "0":
		if get_node("VelocitySlider").value == 0:
			get_node("VelocitySlider").value = 5
		beatVal[v-1] = str(int(get_node("VelocitySlider").value))
	else:
		beatVal[v-1] = "0"
	updateGlobal()


func _on_b_q_4_pressed():
	var v = 4
	if beatVal[v-1] == "0":
		if get_node("VelocitySlider").value == 0:
			get_node("VelocitySlider").value = 5
		beatVal[v-1] = str(int(get_node("VelocitySlider").value))
	else:
		beatVal[v-1] = "0"
	updateGlobal()
