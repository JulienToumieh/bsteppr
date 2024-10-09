extends Node2D

var bpm = 0
var swing = 0

var minTempo = 20
var maxTempo = 250

var tapTempoVals = []

func _ready():
	position = get_viewport().get_size() / 2
	get_node("TempoSlider").min_value = minTempo
	get_node("TempoSlider").max_value = maxTempo
	bpm = Globals.bpm
	swing = Globals.swing
	updateGlobal()
	tapTempoIndicator()

func tapTempo():
	tapTempoVals.append(Time.get_ticks_msec())
	var subs = []
	if tapTempoVals.size() >= 2:
		for i in range(tapTempoVals.size()):
			if i+1 != tapTempoVals.size():
				subs.append(tapTempoVals[i+1] - tapTempoVals[i])
		bpm = int(60000/average(subs))
		updateGlobal()
		
	tapTempoIndicator()
	
	
	if tapTempoVals.size() == 8:
		subs.clear()
		tapTempoVals.clear()


func average(numbers: Array) -> float:
	if numbers.size() == 0: 
		return 0.0
	
	var total_sum = numbers.reduce(func(accum, number): return accum + number, 0)
	return total_sum / numbers.size()

func tapTempoIndicator():
	for i in range(8):
		if i < tapTempoVals.size(): 
			get_node("TapTempoIndicator/P" + str(i+1)).modulate.a = 1
		else:
			get_node("TapTempoIndicator/P" + str(i+1)).modulate.a = 0.3

func _on_close_popup_pressed():
	Globals.bpm = bpm
	Globals.swing = swing
	Globals.setTempo()
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
