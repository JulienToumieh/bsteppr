extends Node2D

var reverb: AudioEffectReverb
var compressor: AudioEffectCompressor
var distortion: AudioEffectDistortion
var eq: AudioEffectEQ

func _ready():
	position = get_viewport().get_size() / 2


func removeFX(fxName):
	var master_bus_index = AudioServer.get_bus_index("Master")
	var effect_count = AudioServer.get_bus_effect_count(master_bus_index)
	
	match fxName: 
		"compressor":
			for i in range(effect_count):
				var effect = AudioServer.get_bus_effect(master_bus_index, i)
				if effect is AudioEffectCompressor:
					AudioServer.remove_bus_effect(master_bus_index, i)
					break
		"eq":
			for i in range(effect_count):
				var effect = AudioServer.get_bus_effect(master_bus_index, i)
				if effect is AudioEffectEQ:
					AudioServer.remove_bus_effect(master_bus_index, i)
					break
		"distortion":
			for i in range(effect_count):
				var effect = AudioServer.get_bus_effect(master_bus_index, i)
				if effect is AudioEffectDistortion:
					AudioServer.remove_bus_effect(master_bus_index, i)
					break
		"reverb":
			for i in range(effect_count):
				var effect = AudioServer.get_bus_effect(master_bus_index, i)
				if effect is AudioEffectReverb:
					AudioServer.remove_bus_effect(master_bus_index, i)
					break

func addFX(fxName):
	match fxName: 
		"compressor":
			compressor = AudioEffectCompressor.new()
			compressor.threshold = 0.5 
			compressor.ratio = 0.5 
			compressor.gain = 0.5
			compressor.attack_us = 0
			compressor.release_ms = 0
			compressor.mix = 1
			
			AudioServer.add_bus_effect(AudioServer.get_bus_index("Master"), compressor)
		"eq":
			eq = AudioEffectEQ.new()
			
			eq.set_band_gain_db(0, 0)
			eq.set_band_gain_db(1, 0)
			eq.set_band_gain_db(2, 0)
			eq.set_band_gain_db(3, 0)
			eq.set_band_gain_db(4, 0)
			eq.set_band_gain_db(5, 0)
			
			AudioServer.add_bus_effect(AudioServer.get_bus_index("Master"), eq)
		"distortion":
			distortion = AudioEffectDistortion.new()
			
			distortion.mode = AudioEffectDistortion.MODE_CLIP
			distortion.pre_gain = 0.5 
			distortion.drive = 0.5
			distortion.post_gain = 0
			
			AudioServer.add_bus_effect(AudioServer.get_bus_index("Master"), distortion)
		"reverb":
			reverb = AudioEffectReverb.new()
			reverb.room_size = 0.5 
			reverb.damping = 0.5 
			reverb.wet = 0.5
			reverb.hipass = 0
			reverb.spread = 1
			reverb.predelay_msec = 0
			reverb.dry = 1 - reverb.wet 
			
			AudioServer.add_bus_effect(AudioServer.get_bus_index("Master"), reverb)


func _on_close_popup_pressed():
	queue_free()
