extends Control

var score
var tweenGrew = true
var tweenColored = true

const tweenZoom = Vector2(1.2, 1.2)
const tweenColor = Color(0, 0.6, 0)
const tweenDuration = 0.65

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_new_score(score, place):
	start_new_highscore_anim()
	
	self.score = score
	
	$PlaceInfo.text = String(place)
	
	match place:
		"1st":
			$PlaceInfo.add_color_override("font_color", Color(1, 0.8431, 0))
		"2nd":
			$PlaceInfo.add_color_override("font_color", Color(0.5804, 0.5961, 0.6314))
		"3rd":
			$PlaceInfo.add_color_override("font_color", Color(0.8039, 0.498, 0.1961))

func start_new_highscore_anim():
	$Label/SizeTween.interpolate_property($Label, "rect_scale", Vector2(1, 1), tweenZoom, tweenDuration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Label/ColorTween.interpolate_property($Label, "custom_colors/font_color", Color(1, 1, 1), tweenColor, tweenDuration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Label/SizeTween.start()
	$Label/ColorTween.start()

func _on_SizeTween_tween_completed(object, key):
	if tweenGrew:
		$Label/SizeTween.interpolate_property($Label, "rect_scale", tweenZoom, Vector2(1, 1), tweenDuration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	else:
		$Label/SizeTween.interpolate_property($Label, "rect_scale", Vector2(1, 1), tweenZoom, tweenDuration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tweenGrew = !tweenGrew
	$Label/SizeTween.start()

func _on_ColorTween_tween_completed(object, key):
	if tweenColored:
		$Label/ColorTween.interpolate_property($Label, "custom_colors/font_color", tweenColor, Color(1, 1, 1), tweenDuration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	else:
		$Label/ColorTween.interpolate_property($Label, "custom_colors/font_color", Color(1, 1, 1), tweenColor, tweenDuration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tweenColored = !tweenColored
	$Label/ColorTween.start()

func _on_AddHighscoreButton_pressed():
	$AddHighscoreButton.visible = false
	$LoadingLabel.visible = true
	var nickname = $LineEdit.text
	get_parent().get_node("GameJoltAPI").add_score(String(score) + " Points", score, '', '', nickname)

func _on_GameJoltAPI_api_scores_added(success):
	globals.cleanPlayerScore()
	
	var addedScore = JSON.parse(success).result.response.success
	
	if addedScore:
		get_tree().change_scene("res://Scenes/ShowHighscores.tscn")
	else:
		$LoadingLabel.text = "Submission failed."
		$LoadingLabel.add_color_override("font_color", Color(1, 0, 0))
		$MainMenuButton.visible = true