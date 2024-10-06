extends Node2D


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

func updateUI():
	emit_signal("update_ui")

func togglePlayback():
	if playing:
		timer.stop()
		playbackPosition = 0
		barRound = 0
	else:
		timer.start()
	loopCounter = loop[activeLoop][0]
	playing = !playing
	get_parent().get_node("Main/BeatGrid").updateTrackerPos()
	updateUI()

func tick():
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
		"swing": swing
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
	
	activeBeat = beat[activeLoop]
	activeBeatQueue = activeBeat
	setTempo()
	
	updateUI()


func _ready():
	for key in beat.keys():
		for i in range(16):
			beat[key].append(Array())
			for j in range(8):
				beat[key][i].append("0000")
	initLoop()
	#relocKit()
	
	loadInstruments(currentKit)
	setTempo()
	
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
	get_node("Instrument" + str(id)).play()


func activateBeatStep(beatIDX):
	if (activeBeat[beatIDX.x][beatIDX.y] == "0000"):
		activeBeat[beatIDX.x][beatIDX.y] = "5555"
		if !playing:
			Globals.get_node("Instrument" + str(beatIDX.y+1)).volume_db = 0
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
