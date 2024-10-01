extends Node2D

var bpm = 0
var swing = 0

var minTempo = 20
var maxTempo = 250

func _ready():
	position = get_viewport().get_size() / 2
	get_node("TempoSlider").min_value = minTempo
	get_node("TempoSlider").max_value = maxTempo
	bpm = Globals.bpm
	swing = Globals.swing
	updateGlobal()


func _on_close_popup_pressed():
	Globals.bpm = bpm
	Globals.swing = swing
	Globals.updateUI()
	queue_free()

func updateGlobal():
	get_node("TempoSlider").value = bpm
	get_node("SwingSlider").value = swing
	get_node("BPMLabel").text = str(bpm)
	get_node("SwingLabel").text = str(swing)


func _on_increase_tempo_pressed():
	bpm += 1
	if bpm > maxTempo: bpm = maxTempo
	updateGlobal()

func _on_increase_tempo_2_pressed():
	bpm += 5
	if bpm > maxTempo: bpm = maxTempo
	updateGlobal()

func _on_decrease_tempo_2_pressed():
	bpm -= 5
	if bpm < minTempo: bpm = minTempo
	updateGlobal()

func _on_decrease_tempo_pressed():
	bpm -= 1
	if bpm < minTempo: bpm = minTempo
	updateGlobal()

func _on_increase_swing_pressed():
	swing += 1
	if swing > 100: swing = 100
	updateGlobal()

func _on_increase_swing_2_pressed():
	swing += 5
	if swing > 100: swing = 100
	updateGlobal()

func _on_decrease_swing_2_pressed():
	swing -= 5
	if swing < 0: swing = 0
	updateGlobal()

func _on_decrease_swing_pressed():
	swing -= 1
	if swing < 0: swing = 0
	updateGlobal()


func _on_tempo_slider_value_changed(value):
	bpm = get_node("TempoSlider").value
	updateGlobal()

func _on_swing_slider_value_changed(value):
	swing = get_node("SwingSlider").value
	updateGlobal()
