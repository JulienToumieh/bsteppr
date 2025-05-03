extends Node2D

var master_bus_index = AudioServer.get_bus_index("Master")
var effect_count = AudioServer.get_bus_effect_count(master_bus_index)

var beat = {
	"A": Array(),
	"B": Array(),
	"C": Array(),
	"D": Array(),
	"E": Array(),
	"F": Array()
}

var loop = {
	"A": [1, "A"],
	"B": [1, "B"],
	"C": [1, "C"],
	"D": [1, "D"],
	"E": [1, "E"],
	"F": [1, "F"]
}

var fx = {
	"Compressor": {
		"enabled": false,
		"threshold": 0,
		"ratio": 4,
		"gain": 0,
		"attack_us": 20,
		"release_ms": 250,
		"mix": 1
	},
	"EQ": {
		"enabled": false,
		"band1": 0,
		"band2": 0,
		"band3": 0,
		"band4": 0,
		"band5": 0,
		"band6": 0
	},
	"Distortion": {
		"enabled": false,
		"mode": "Clip",
		"pre_gain": 0,
		"drive": 0,
		"post_gain": 0
	},
	"Reverb": {
		"enabled": false,
		"room_size": 0.8,
		"damping": 0.5,
		"spread": 1,
		"wet": 0.5,
		"hipass": 0,
		"predelay_msec": 0 
	}
}

var colorTheme = {
	"instrumentRows": [
		"FF4141",
		"FF44BF",
		"854BFF",
		"3385FF",
		"00F0FF",
		"3CFF72",
		"4CFF2F",
		"FF922D"
	],
	"instrumentRowBeats": [
		"FF4141",
		"FF44BF",
		"854BFF",
		"3385FF",
		"00F0FF",
		"3CFF72",
		"4CFF2F",
		"FF922D"
	],
	"loopChip": "07FCAE"
}

var themeName = "default"

var countIn = false
var countInCounter = 0
var countInVal = 4

signal update_ui
var instrumentNames = []

var currentKit = "EDM"

var activeLoop = "A"
var activeBeat = beat[activeLoop]
var activeBeatQueue = activeBeat
var loopCounter = 0


var playbackPosition = 0
var barRound = 0
var playing = false

var bpm = 120
var swing = 0
var timer : Timer

var data_path = "user:/"
var autoSaveConf = false

func updateUI():
	emit_signal("update_ui")
	if autoSaveConf: saveConfig()

func updateFXEnabled():
	for i in range(effect_count):
		var effect = AudioServer.get_bus_effect(master_bus_index, i)
		if effect is AudioEffectCompressor:
			AudioServer.set_bus_effect_enabled(master_bus_index, i, fx["Compressor"]["enabled"])
		if effect is AudioEffectDistortion:
			AudioServer.set_bus_effect_enabled(master_bus_index, i, fx["Distortion"]["enabled"])
		if effect is AudioEffectEQ:
			AudioServer.set_bus_effect_enabled(master_bus_index, i, fx["EQ"]["enabled"])
		if effect is AudioEffectReverb:
			AudioServer.set_bus_effect_enabled(master_bus_index, i, fx["Reverb"]["enabled"])

func updateCompFX():
	for i in range(effect_count):
		var effect = AudioServer.get_bus_effect(master_bus_index, i)
		if effect is AudioEffectCompressor:
			effect.threshold = fx["Compressor"]["threshold"] 
			effect.ratio = fx["Compressor"]["ratio"]  
			effect.gain = fx["Compressor"]["gain"] 
			effect.attack_us = fx["Compressor"]["attack_us"] 
			effect.release_ms = fx["Compressor"]["release_ms"] 
			effect.mix = fx["Compressor"]["mix"] 
			break

func updateEQFX():
	for i in range(effect_count):
		var effect = AudioServer.get_bus_effect(master_bus_index, i)
		if effect is AudioEffectEQ:
			effect.set_band_gain_db(0, fx["EQ"]["band1"])
			effect.set_band_gain_db(1, fx["EQ"]["band2"])
			effect.set_band_gain_db(2, fx["EQ"]["band3"])
			effect.set_band_gain_db(3, fx["EQ"]["band4"])
			effect.set_band_gain_db(4, fx["EQ"]["band5"])
			effect.set_band_gain_db(5, fx["EQ"]["band6"])
			break

func updateDistFX():
	var modes = {
		"Clip": AudioEffectDistortion.MODE_CLIP,
		"ATan": AudioEffectDistortion.MODE_ATAN,
		"LoFi": AudioEffectDistortion.MODE_LOFI,
		"OvrDrv": AudioEffectDistortion.MODE_OVERDRIVE,
		"WavShp": AudioEffectDistortion.MODE_WAVESHAPE
	}
	for i in range(effect_count):
		var effect = AudioServer.get_bus_effect(master_bus_index, i)
		if effect is AudioEffectDistortion:
			effect.mode = modes[fx["Distortion"]["mode"]]
			effect.pre_gain = fx["Distortion"]["pre_gain"] 
			effect.drive = fx["Distortion"]["drive"] 
			effect.post_gain = fx["Distortion"]["post_gain"] 
			break

func updateRevFX():
	for i in range(effect_count):
		var effect = AudioServer.get_bus_effect(master_bus_index, i)
		if effect is AudioEffectReverb:
			effect.room_size = fx["Reverb"]["room_size"]
			effect.damping = fx["Reverb"]["damping"] 
			effect.spread = fx["Reverb"]["spread"] 
			effect.hipass = fx["Reverb"]["hipass"] 
			effect.predelay_msec = fx["Reverb"]["predelay_msec"] 
			effect.wet = fx["Reverb"]["wet"] 
			effect.dry = 1 - fx["Reverb"]["wet"] 
			break
			

func initFX():
	fx = {
		"Compressor": {
			"enabled": false,
			"threshold": 0,
			"ratio": 4,
			"gain": 0,
			"attack_us": 20,
			"release_ms": 250,
			"mix": 1
		},
		"EQ": {
			"enabled": false,
			"band1": 0,
			"band2": 0,
			"band3": 0,
			"band4": 0,
			"band5": 0,
			"band6": 0
		},
		"Distortion": {
			"enabled": false,
			"mode": "Clip",
			"pre_gain": 0,
			"drive": 0,
			"post_gain": 0
		},
		"Reverb": {
			"enabled": false,
			"room_size": 0.8,
			"damping": 0.5,
			"spread": 1,
			"wet": 0.5,
			"hipass": 0,
			"predelay_msec": 150 
		}
	}
	
	updateFXEnabled()
	updateCompFX()
	updateDistFX()
	updateEQFX()
	updateRevFX()

func togglePlayback():
	loopCounter = loop[activeLoop][0]
	get_parent().get_node("Main/BeatGrid").updateTrackerPos()
	if playing:
		timer.stop()
		playbackPosition = 0
		barRound = 0
	else:
		if countIn:
			countInCounter = int(countInVal * 4)
		else:
			countInCounter = 0
		timer.start()
	
	playing = !playing
	updateUI()


func tick():
	if countInCounter != 0:
		if countInCounter % 4 == 0:
			get_node("CountInSound").play() 
		countInCounter -= 1
	else:
		if playbackPosition % 16 == 0: 
			playbackPosition = 1
			if barRound == 4: barRound = 1
			else: barRound += 1
			if activeBeat != activeBeatQueue:
				loopCounter = loop[activeLoop][0]
			activeBeat = activeBeatQueue
			if loopCounter == 0:
				if loop[activeLoop][1] == "Ø":
					togglePlayback()
				else:
					activeLoop = loop[activeLoop][1]
					activeBeat = beat[activeLoop]
					activeBeatQueue = activeBeat
					loopCounter = loop[activeLoop][0]
			updateUI()
			loopCounter -= 1
		else: 
			playbackPosition += 1
		get_parent().get_node("Main/BeatGrid").updateTrackerPos()
		get_parent().get_node("Main").updateBarIndicator()
		
		if playbackPosition % 2 and swing != 0: await get_tree().create_timer(((60.0 / bpm) * 4) * (swing * 1.0 / 100.0) * 0.035).timeout
		for ins in range(8):
			if activeBeat[playbackPosition - 1][ins][barRound-1] != "0": 
				get_node("Instrument" + str(ins+1)).volume_db = mapVol(activeBeat[playbackPosition - 1][ins][barRound-1])
			if activeBeat[playbackPosition - 1][ins][barRound-1] != "0": playSound(ins+1)


func _process(_delta):
	if Input.is_action_just_pressed("start-stop"):
		togglePlayback()

func save_loop(loopName):
	DirAccess.make_dir_absolute(data_path + "/Loop Presets/")
	var save_file = FileAccess.open(data_path + "/Loop Presets/" + loopName + ".blp", FileAccess.WRITE)
	
	var loop_data = {
		"beat": beat,
		"loop": loop,
		"tempo": bpm,
		"swing": swing,
		"fx": fx
	}
	
	save_file.store_line(JSON.stringify(loop_data))
	save_file.close()


func load_loop(loopName):
	if playing:
		togglePlayback()
	
	var load_file = FileAccess.open(data_path + "/Loop Presets/" + loopName + ".blp", FileAccess.READ)
	
	var json_data = load_file.get_line()
	load_file.close() 
	var json = JSON.new()
	var _parse_result = json.parse(json_data)

	var loop_data = json.data
	
	beat = loop_data["beat"]
	loop = loop_data["loop"]
	bpm = loop_data["tempo"]
	swing = loop_data["swing"]
	fx = loop_data["fx"]
	
	activeBeat = beat[activeLoop]
	activeBeatQueue = activeBeat
	setTempo()
	
	updateUI()


func _ready():
	saveTheme("default")
	
	for key in beat.keys():
		for i in range(16):
			beat[key].append(Array())
			for j in range(8):
				beat[key][i].append("0000")
	initLoop()
	#relocKit()
	
	loadInstruments(currentKit)
	setTempo()
	
	initFX()
	
	loadConfig()
	autoSaveConf = true


func saveTheme(themename):
	DirAccess.make_dir_absolute(data_path + "/Themes/")
	var save_file = FileAccess.open(data_path + "/Themes/"+ themename +".bclrs", FileAccess.WRITE)
	
	var data = {
		"colorTheme": colorTheme,
	}
	
	save_file.store_line(JSON.stringify(data))
	save_file.close()


func loadTheme(themename):
	if FileAccess.file_exists(data_path + "/Themes/"+ themename +".bclrs"):
		var load_file = FileAccess.open(data_path + "/Themes/"+ themename +".bclrs", FileAccess.READ)
		
		var json_data = load_file.get_line()
		load_file.close() 
		var json = JSON.new()
		var _parse_result = json.parse(json_data)
		var data = json.data
		
		colorTheme = data["colorTheme"]
		themeName = themename
		
		saveConfig()
		updateUI()



func saveConfig():
	var save_file = FileAccess.open(data_path + "/config.bcfg", FileAccess.WRITE)
	
	var data = {
		"beat": beat,
		"loop": loop,
		"tempo": bpm,
		"swing": swing,
		"kit": currentKit,
		"fx": fx,
		"countin": countIn,
		"countinval": countInVal,
		"colorTheme": colorTheme,
		"themeName": themeName
	}
	
	save_file.store_line(JSON.stringify(data))
	save_file.close()


func loadConfig():
	if FileAccess.file_exists(data_path + "/config.bcfg"):
		if playing:
			togglePlayback()
		
		var load_file = FileAccess.open(data_path + "/config.bcfg", FileAccess.READ)
		
		var json_data = load_file.get_line()
		load_file.close() 
		var json = JSON.new()
		var _parse_result = json.parse(json_data)

		var data = json.data
		
		beat = data["beat"]
		loop = data["loop"]
		bpm = data["tempo"]
		swing = data["swing"]
		fx = data["fx"]
		countIn = data["countin"]
		countInVal = data["countinval"]
		colorTheme = data["colorTheme"]
		themeName = data["themeName"]
		
		loadInstruments(data["kit"])
		activeBeat = beat[activeLoop]
		activeBeatQueue = activeBeat
		setTempo()
		
		updateFXEnabled()
		updateCompFX()
		updateDistFX()
		updateEQFX()
		updateRevFX()
		loadTheme(themeName)
		
		updateUI()
	else:
		saveConfig()


'
func relocKit():
	DirAccess.make_dir_absolute(data_path + "/Drum Kits")
	var internalKits = getFolderNames("res://drum_kits")
	for kit in internalKits:
		DirAccess.make_dir_absolute(data_path + "/Drum Kits/" + kit)
		var kitIns = getAllFileNames("res://drum_kits/" + kit)
		for ins in kitIns:
			#ResourceSaver.save(load("res://drum_kits/" + kit + "/" + ins), data_path + "/Drum Kits/" + kit + "/" + ins + ".import")
			DirAccess.copy_absolute("res://drum_kits/" + kit + "/" + ins, data_path + "/Drum Kits/" + kit + "/" + ins)
'

func loadInstruments(kit):
	instrumentNames = getFileNames("res://drum_kits/" + kit + "/")
	for ins in range(instrumentNames.size()):
		var path = "res://drum_kits/" + kit + "/" + instrumentNames[ins]
		get_node("Instrument" + str(ins + 1)).stream = load(path)
		'
		var file = FileAccess.open(path, FileAccess.READ)
		if file:
			var wav_data = file.get_buffer(file.get_length())
			file.close()
			
			# Create and configure AudioStreamWAV
			var audio_stream = AudioStreamWAV.new()
			audio_stream.data = wav_data  # This is a placeholder. Needs proper parsing!
			audio_stream.mix_rate = 44100
			audio_stream.format = 1
			audio_stream.stereo = true
			
			# Set parameters

			# Assign to the AudioStreamPlayer
			var player = get_node("Instrument" + str(ins + 1))
			player.stream = audio_stream
		'
	updateUI()



func initLoop():
	if playing:
		togglePlayback()
	
	beat = {
		"A": Array(),
		"B": Array(),
		"C": Array(),
		"D": Array(),
		"E": Array(),
		"F": Array()
	}
	loop = {
		"A": [1, "A"],
		"B": [1, "B"],
		"C": [1, "C"],
		"D": [1, "D"],
		"E": [1, "E"],
		"F": [1, "F"]
	}
	for key in beat.keys():
		for i in range(16):
			beat[key].append(Array())
			for j in range(8):
				beat[key][i].append("0000")
	
	initFX()
	
	bpm = 120
	swing = 0
	activeBeat = beat[activeLoop]
	activeBeatQueue = activeBeat
	#save_loop("init")
	setTempo()
	updateUI()


func setTempo():
	timer = get_node("Timer")
	timer.wait_time = 60.0 / (bpm * 4)
	timer.one_shot = false


func playSound(id):
	get_node("Instrument" + str(int(id))).play()


func activateBeatStep(beatIDX):
	if (activeBeat[beatIDX.x][beatIDX.y] == "0000"):
		activeBeat[beatIDX.x][beatIDX.y] = "5555"
		if !playing:
			Globals.get_node("Instrument" + str(int(beatIDX.y+1))).volume_db = 0
			playSound(beatIDX.y+1)
	else:
		activeBeat[beatIDX.x][beatIDX.y] = "0000"
	updateUI()

func editBeatStep(beatIDX):
	get_parent().get_node("Main").createEditBeatPopup(beatIDX)

func selectBeatLoop(loopName):
	activeLoop = loopName
	loopCounter = loop[activeLoop][0]
	if playing:
		activeBeatQueue = beat[loopName]
	else:
		activeBeat = beat[loopName]
		activeBeatQueue = beat[loopName]
		loopCounter = loop[loopName][0]
	updateUI()

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

func editLoop(loopName):
	get_parent().get_node("Main").createEditLoopPopup(loopName)
	
func updateLoopChips():
	updateUI()

func mapVol(val):
	match val:
		"0":
			return -80
		"1":
			return -30
		"2":
			return -22
		"3":
			return -12
		"4":
			return -8
		"5":
			return 0

func getFileNames(directory: String) -> Array:
	var dir = DirAccess.open(directory)
	var file_names = []

	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".import"): 
				file_names.append(file_name.replace('.import', ''))
			file_name = dir.get_next()
		
		dir.list_dir_end()
	return file_names

func getAllFileNames(directory: String) -> Array:
	var dir = DirAccess.open(directory)
	var file_names = []

	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if not dir.current_is_dir(): 
				file_names.append(file_name)
			file_name = dir.get_next()
		
		dir.list_dir_end()
	return file_names

'''
var tempo = 60000 / 128  # Tempo in milliseconds

@onready var metronome_timer = $Timer  # Reference to the Timer node

func togglePlayback():
	playing = !playing
	if playing:
		metronome_timer.start()  # Start the timer
	else:
		playbackPosition = 0
		metronome_timer.stop()  # Stop the timer

func tick():
	playbackPosition = (playbackPosition % 16) + 1
	if playbackPosition % 4 == 0:
		playSound(3)

func _ready():
	metronome_timer.wait_time = tempo / 4000.0  # Set wait time in seconds
	metronome_timer.timeout.connect(self._on_Timer_timeout)

func _on_Timer_timeout():
	tick()  # Call tick on timer timeout

'''
