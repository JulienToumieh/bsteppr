extends Node2D

var selectedKit = null
var selectedLoop = null

func _ready():
	position = get_viewport().get_size() / 2
	var drumKits = getFolderNames("res://drum_kits")
	
	for kit in drumKits:
		get_node("KitList").add_item(kit)
	
	selectedKit = Globals.currentKit
	selectItemName(selectedKit)
	loadKitInstruments()
	loadLoopPresets()

func loadKitInstruments():
	get_node("KIntrumentsList").clear()
	var insts = Globals.getFileNames("res://drum_kits/" + selectedKit + "/")
	for ins in insts:
		get_node("KIntrumentsList").add_item(ins)
		

func loadLoopPresets():
	var dir = DirAccess.open(Globals.data_path + "/Loop Presets/")
	var file_names = []

	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if not dir.current_is_dir(): 
				file_names.append(file_name.get_basename())
			file_name = dir.get_next()
		
		dir.list_dir_end()
	
	get_node("LoopPresetList").clear()
	for loop in file_names:
		get_node("LoopPresetList").add_item(loop)

func _on_close_popup_pressed():
	queue_free()


func getFolderNames(directory: String) -> Array:
	var dir = DirAccess.open(directory)
	var folder_names = []

	if dir:
		dir.list_dir_begin()
		var folder_name = dir.get_next()
		
		while folder_name != "":
			if dir.current_is_dir(): 
				folder_names.append(folder_name)
			folder_name = dir.get_next()
		
		dir.list_dir_end()
	return folder_names


func selectItemName(item_name: String) -> void:
	for index in range(get_node("KitList").get_item_count()):
		if get_node("KitList").get_item_text(index) == item_name:
			get_node("KitList").select(index)
			break 


func _on_item_list_item_selected(index):
	selectedKit = get_node("KitList").get_item_text(index)
	loadKitInstruments()


func _on_b_select_kit_pressed():
	Globals.currentKit = selectedKit
	Globals.loadInstruments(selectedKit)


func _on_k_intruments_list_item_clicked(index, at_position, mouse_button_index):
	get_node("InstrumentPlayer").stream = load("res://drum_kits/" + selectedKit + "/" + get_node("KIntrumentsList").get_item_text(index))
	get_node("InstrumentPlayer").play()


func _on_b_save_loop_pressed():
	if get_node("InputLoopName").text != "":
		Globals.save_loop(get_node("InputLoopName").text)
		get_node("InputLoopName").text = ""
		loadLoopPresets()

func _on_b_load_loop_pressed():
	if selectedLoop != null:
		Globals.load_loop(selectedLoop)

func _on_loop_preset_list_item_clicked(index, at_position, mouse_button_index):
	selectedLoop = get_node("LoopPresetList").get_item_text(index)
