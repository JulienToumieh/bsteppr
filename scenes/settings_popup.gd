extends Node2D

var reverb: AudioEffectReverb
var compressor: AudioEffectCompressor
var distortion: AudioEffectDistortion
var eq: AudioEffectEQ

var master_bus_index = AudioServer.get_bus_index("Master")
var effect_count = AudioServer.get_bus_effect_count(master_bus_index)

func _ready():
	position = get_viewport().get_size() / 2
	updateSettingsUI()

func updateSettingsUI():
	if Globals.fx["Compressor"]["enabled"]: get_node("Compressor/enabledVis").modulate.a = 1
	else: get_node("Compressor/enabledVis").modulate.a = 0.3
	if Globals.fx["EQ"]["enabled"]: get_node("EQ/enabledVis").modulate.a = 1
	else: get_node("EQ/enabledVis").modulate.a = 0.3
	if Globals.fx["Distortion"]["enabled"]: get_node("Distortion/enabledVis").modulate.a = 1
	else: get_node("Distortion/enabledVis").modulate.a = 0.3
	if Globals.fx["Reverb"]["enabled"]: get_node("Reverb/enabledVis").modulate.a = 1
	else: get_node("Reverb/enabledVis").modulate.a = 0.3

func _on_close_popup_pressed():
	queue_free()
 

func _on_b_comp_pressed():
	Globals.fx["Compressor"]["enabled"] = !Globals.fx["Compressor"]["enabled"]
	for i in range(effect_count):
		var effect = AudioServer.get_bus_effect(master_bus_index, i)
		if effect is AudioEffectCompressor:
			AudioServer.set_bus_effect_enabled(master_bus_index, i, Globals.fx["Compressor"]["enabled"])
	
	updateSettingsUI()


func _on_b_dist_pressed():
	Globals.fx["Distortion"]["enabled"] = !Globals.fx["Distortion"]["enabled"]
	for i in range(effect_count):
		var effect = AudioServer.get_bus_effect(master_bus_index, i)
		if effect is AudioEffectDistortion:
			AudioServer.set_bus_effect_enabled(master_bus_index, i, Globals.fx["Distortion"]["enabled"])
	
	updateSettingsUI()


func _on_b_eq_pressed():
	Globals.fx["EQ"]["enabled"] = !Globals.fx["EQ"]["enabled"]
	for i in range(effect_count):
		var effect = AudioServer.get_bus_effect(master_bus_index, i)
		if effect is AudioEffectEQ:
			AudioServer.set_bus_effect_enabled(master_bus_index, i, Globals.fx["EQ"]["enabled"])
	
	updateSettingsUI()


func _on_b_rev_pressed():
	Globals.fx["Reverb"]["enabled"] = !Globals.fx["Reverb"]["enabled"]
	for i in range(effect_count):
		var effect = AudioServer.get_bus_effect(master_bus_index, i)
		if effect is AudioEffectReverb:
			AudioServer.set_bus_effect_enabled(master_bus_index, i, Globals.fx["Reverb"]["enabled"])
	
	updateSettingsUI()
