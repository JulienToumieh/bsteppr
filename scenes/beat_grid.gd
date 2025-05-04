extends Node2D

var BeatStep = preload("res://components/beat_step.tscn")
var InstrumentRow = preload("res://components/instrument_row.tscn")
var grid = Globals.beat["A"]

var playbackTracker = [-1000,0,72,144,216,317,389,461,533,634,706,778,850,951,1023,1095,1167]

func _ready():
	update_theme()
	Globals.connect("update_ui", Callable(self, "_on_update_ui"))
	
	var x = 0
	var y = 0
	
	for i in range(16):
		y = 0
		for j in range(8):
			var bstep = BeatStep.instantiate()
			bstep.position = Vector2(x, y)
			bstep.name = "beat" + str(x) + str(y)
			bstep.beatIDX = Vector2(i,j)
			add_child(bstep)
			y += 72
		x += 72
		if (i + 1) % 4  == 0: x += 29
	
	for i in range(8):
		var instrument = InstrumentRow.instantiate()
		instrument.position = Vector2(-153, i*72)
		instrument.name = "instrument" + str(i)
		instrument.instrumentID = i + 1
		add_child(instrument)
		
	Globals.updateUI()
	updateTrackerPos()

func update_theme():
	var colorTheme = Globals.colorTheme
	get_node("PlaybackTracker").modulate = Color(colorTheme.get("playbackTracker"))

func _on_update_ui():
	update_theme()


func updateTrackerPos():
	get_node("PlaybackTracker").position.x = playbackTracker[Globals.playbackPosition]
