extends Node2D

var reverb: AudioEffectReverb
var compressor: AudioEffectCompressor
var distortion: AudioEffectDistortion
var hisf: AudioEffectHighShelfFilter
var losf: AudioEffectLowShelfFilter
var filter: AudioEffectFilter

func _ready():
	position = get_viewport().get_size() / 2
	addReverb()
	removeFX("reverb")

func addFilter():
	filter = AudioEffectFilter.new()
	
	filter.cutoff_hz = 2000
	filter.resonance = 0.5 
	filter.gain = 0.5
	filter.db = 0
	
	AudioServer.add_bus_effect(AudioServer.get_bus_index("Master"), filter)

func addLoSF():
	losf = AudioEffectLowShelfFilter.new()
	
	losf.cutoff_hz = 2000
	losf.resonance = 0.5 
	losf.gain = 0.5
	losf.db = 0
	
	AudioServer.add_bus_effect(AudioServer.get_bus_index("Master"), losf)

func addHiSF():
	hisf = AudioEffectHighShelfFilter.new()
	
	hisf.cutoff_hz = 2000
	hisf.resonance = 0.5 
	hisf.gain = 0.5
	hisf.db = 0
	
	AudioServer.add_bus_effect(AudioServer.get_bus_index("Master"), hisf)

func addDistortion():
	distortion = AudioEffectDistortion.new()
	
	distortion.mode = AudioEffectDistortion.MODE_CLIP
	distortion.pre_gain = 0.5 
	distortion.drive = 0.5
	distortion.post_gain = 0
	
	AudioServer.add_bus_effect(AudioServer.get_bus_index("Master"), distortion)

func addCompressor():
	compressor = AudioEffectCompressor.new()
	
	compressor.threshold = 0.5 
	compressor.ratio = 0.5 
	compressor.gain = 0.5
	compressor.attack_us = 0
	compressor.release_ms = 0
	compressor.mix = 1
	
	AudioServer.add_bus_effect(AudioServer.get_bus_index("Master"), compressor)

func addReverb():
	reverb = AudioEffectReverb.new()
	
	reverb.room_size = 0.5 
	reverb.damping = 0.5 
	reverb.wet = 0.5
	reverb.hipass = 0
	reverb.predelay_msec = 0
	reverb.dry = 1 - reverb.wet 
	
	AudioServer.add_bus_effect(AudioServer.get_bus_index("Master"), reverb)

func removeFX(fxName):
	var master_bus_index = AudioServer.get_bus_index("Master")
	var effect_count = AudioServer.get_bus_effect_count(master_bus_index)
	
	match fxName: 
		"reverb":
			for i in range(effect_count):
				var effect = AudioServer.get_bus_effect(master_bus_index, i)
				if effect is AudioEffectReverb:
					AudioServer.remove_bus_effect(master_bus_index, i)
					break
		"compressor":
			for i in range(effect_count):
				var effect = AudioServer.get_bus_effect(master_bus_index, i)
				if effect is AudioEffectCompressor:
					AudioServer.remove_bus_effect(master_bus_index, i)
					break
		"distortion":
			for i in range(effect_count):
				var effect = AudioServer.get_bus_effect(master_bus_index, i)
				if effect is AudioEffectDistortion:
					AudioServer.remove_bus_effect(master_bus_index, i)
					break
		"hisf":
			for i in range(effect_count):
				var effect = AudioServer.get_bus_effect(master_bus_index, i)
				if effect is AudioEffectHighShelfFilter:
					AudioServer.remove_bus_effect(master_bus_index, i)
					break
		"losf":
			for i in range(effect_count):
				var effect = AudioServer.get_bus_effect(master_bus_index, i)
				if effect is AudioEffectLowShelfFilter:
					AudioServer.remove_bus_effect(master_bus_index, i)
					break
		"filter":
			for i in range(effect_count):
				var effect = AudioServer.get_bus_effect(master_bus_index, i)
				if effect is AudioEffectFilter:
					AudioServer.remove_bus_effect(master_bus_index, i)
					break



func _on_close_popup_pressed():
	queue_free()
