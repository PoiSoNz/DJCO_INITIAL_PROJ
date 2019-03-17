extends Control

var progress_factor = 30
var previous_score = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_HUD_bonus(value):
	$CurrentBonus/Value.text = str(floor(value))
	$CurrentBonus/ProgressBar.value = value/progress_factor

func _on_HUD_score(value):
	if value != previous_score:
		previous_score = value
		#$Tween.interpolate_property($TotalScore/Value, "rect_scale:x", 1.5, 1, 0.5, Tween.TRANS_CUBIC,Tween.EASE_OUT)
		$Tween.interpolate_property($TotalScore/Value, "rect_scale:y", 1.5, 1, 0.5, Tween.TRANS_CUBIC,Tween.EASE_OUT)
		$Tween.start()
		$TotalScore/Value.text = str(floor(value))

func _on_HUD_bonus_info(bar_value, multiplier_value):
	$CurrentBonus/BonusInfo/ProgressBar.value = bar_value
