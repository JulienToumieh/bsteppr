extends Node2D

var selectedKit = null

func _ready():

	position = get_viewport().get_size() / 2
	var drumKits = getFolderNames("res://drum_kits")
	
	for kit in drumKits:
		get_node("KitList").add_item(kit)
	
	selectedKit = Globals.currentKit
	selectItemName(selectedKit)


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


func _on_b_select_kit_pressed():
	Globals.currentKit = selectedKit
	Globals.loadInstruments(selectedKit)
