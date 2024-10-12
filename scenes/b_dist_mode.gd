extends Button

var modes = {
	"Clip": AudioEffectDistortion.MODE_CLIP,
	"ATan": AudioEffectDistortion.MODE_ATAN,
	"LoFi": AudioEffectDistortion.MODE_LOFI,
	"OvrDrv": AudioEffectDistortion.MODE_OVERDRIVE,
	"WavShp": AudioEffectDistortion.MODE_WAVESHAPE
}

var mode = 0

func _ready():
	text = modes.find_key(mode)

func _on_pressed():
	if mode == 4:
		mode = 0
	else:
		mode += 1
	text = modes.find_key(mode)
