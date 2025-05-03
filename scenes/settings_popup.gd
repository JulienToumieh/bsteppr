extends Node2D

var reverb: AudioEffectReverb
var compressor: AudioEffectCompressor
var distortion: AudioEffectDistortion
var eq: AudioEffectEQ

var master_bus_index = AudioServer.get_bus_index("Master")
var effect_count = AudioServer.get_bus_effect_count(master_bus_index)

signal resetFxSignal

var themeNames = []

func _ready():
	get_node("Settings/bCountIn").button_pressed = Globals.countIn
	position = get_viewport().get_size() / 2
	Globals.connect("update_ui", Callable(self, "_on_update_ui"))
	Globals.updateUI()
	
	themeNames = Globals.getDataFileNames(Globals.data_path + "/Themes/")
	var selectedThemeID = 0
	
	for i in range(len(themeNames)):
		themeNames[i] = themeNames[i].replace(".bclrs", '')
		get_node("Settings/ThemeDropdown").add_item(themeNames[i])
		if Globals.themeName == themeNames[i] : selectedThemeID = i
		
	get_node("Settings/ThemeDropdown").select(selectedThemeID)

func _on_update_ui():
	if Globals.fx["Compressor"]["enabled"]: get_node("Compressor/enabledVis").modulate.a = 1
	else: get_node("Compressor/enabledVis").modulate.a = 0.3
	if Globals.fx["EQ"]["enabled"]: get_node("EQ/enabledVis").modulate.a = 1
	else: get_node("EQ/enabledVis").modulate.a = 0.3
	if Globals.fx["Distortion"]["enabled"]: get_node("Distortion/enabledVis").modulate.a = 1
	else: get_node("Distortion/enabledVis").modulate.a = 0.3
	if Globals.fx["Reverb"]["enabled"]: get_node("Reverb/enabledVis").modulate.a = 1
	else: get_node("Reverb/enabledVis").modulate.a = 0.3




func _on_close_popup_pressed():
	Globals.saveConfig()
	queue_free()

func _on_b_comp_pressed():
	Globals.fx["Compressor"]["enabled"] = !Globals.fx["Compressor"]["enabled"]
	Globals.updateFXEnabled()
	Globals.updateUI()


func _on_b_dist_pressed():
	Globals.fx["Distortion"]["enabled"] = !Globals.fx["Distortion"]["enabled"]
	Globals.updateFXEnabled()
	Globals.updateUI()


func _on_b_eq_pressed():
	Globals.fx["EQ"]["enabled"] = !Globals.fx["EQ"]["enabled"]
	Globals.updateFXEnabled()
	Globals.updateUI()


func _on_b_rev_pressed():
	Globals.fx["Reverb"]["enabled"] = !Globals.fx["Reverb"]["enabled"]
	Globals.updateFXEnabled()
	Globals.updateUI()


func _on_b_reset_fx_pressed():
	Globals.initFX()
	Globals.updateUI()


func _on_b_count_in_toggled(toggled_on):
	Globals.countIn = toggled_on


func _on_theme_dropdown_item_selected(index):
	print(themeNames[index])
	Globals.loadTheme(themeNames[index])
