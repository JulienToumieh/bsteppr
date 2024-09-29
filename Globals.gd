extends Node2D

var beat = {
	"A": Array(),
	"B": Array(),
	"C": Array(),
	"D": Array(),
	"E": Array(),
	"F": Array()
}



var activeBeat = beat["A"]

var playbackPosition = 0
var barRound = 0
var playing = false

var bpm = 128
var beat_interval = 60.0 / (bpm * 4)
var timer : Timer


func togglePlayback():
	if playing:
		timer.stop()
		playbackPosition = 0
		barRound = 0
	else:
		timer.start()
	playing = !playing

func tick():
	if playbackPosition % 16 == 0: 
		playbackPosition = 1
		if barRound == 4: barRound = 1
		else: barRound += 1
	else: 
		playbackPosition += 1
	
	for ins in range(8):
		get_node("Instrument" + str(ins+1)).volume_db = mapVol(beat["A"][playbackPosition - 1][ins][barRound-1])
		if beat["A"][playbackPosition - 1][ins][barRound-1] != "0": get_node("Instrument" + str(ins+1)).play()
	
	#if (playbackPosition + 3) % 4 == 0: playSound(3)

func _ready():
	for key in beat.keys():
		for i in range(16):
			beat[key].append(Array())
			for j in range(8):
				beat[key][i].append("0000")
	
	timer = Timer.new()
	timer.wait_time = beat_interval
	timer.one_shot = false
	timer.connect("timeout", Callable(self, "tick"))
	add_child(timer)

func _process(delta):
	pass

func playSound(id):
	match id:
		1: get_node("Instrument1").play()
		2: get_node("Instrument2").play()
		3: get_node("Instrument3").play()
		4: get_node("Instrument4").play()
		5: get_node("Instrument5").play()
		6: get_node("Instrument6").play()
		7: get_node("Instrument7").play()
		8: get_node("Instrument8").play()

func activateBeatStep(beatIDX):
	if (activeBeat[beatIDX.x][beatIDX.y] == "0000"):
		activeBeat[beatIDX.x][beatIDX.y] = "5555"
	else:
		activeBeat[beatIDX.x][beatIDX.y] = "0000"

func editBeatStep(beatIDX):
	get_parent().get_node("Main").createEditBeatPopup(beatIDX)


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




'''
var beats = {
	"A": [["0000"] * 8 for _ in range(16)],
	"B": [["0000"] * 8 for _ in range(16)],
	"C": [["0000"] * 8 for _ in range(16)],
	"D": [["0000"] * 8 for _ in range(16)],
	"E": [["0000"] * 8 for _ in range(16)],
	"F": [["0000"] * 8 for _ in range(16)]

var activeBeat = beatA
var playbackPosition = 0
var playing = false

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

func playSound(id):
	match id:
		1: get_node("Instrument1").play()
		2: get_node("Instrument2").play()
		3: get_node("Instrument3").play()
		4: get_node("Instrument4").play()
		5: get_node("Instrument5").play()
		6: get_node("Instrument6").play()
		7: get_node("Instrument7").play()
		8: get_node("Instrument8").play()
'''
