extends Control

var tweenGrew = true

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("GameJoltAPI").fetch_scores()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_HighscoresButton_pressed():
	get_tree().change_scene("res://Scenes/ShowHighscores.tscn")


func _on_NewGameButton_pressed():
	get_tree().change_scene("res://Scenes/MasterLevel.tscn")


func _on_MainMenuButton_pressed():
	#get_tree().change_scene("res://Scenes/MainMenu.tscn")
	pass

func _on_GameJoltAPI_api_scores_fetched(data):
	var scores = JSON.parse(data).result.response.scores
	print(scores)
	start_new_highscore_anim()

func start_new_highscore_anim():
	$NewHighscoreUI/Label/Tween.interpolate_property($NewHighscoreUI/Label, "rect_scale", Vector2(1, 1), Vector2(2, 2), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$NewHighscoreUI/Label/Tween.start()

func _on_Tween_tween_completed(object, key):
	if tweenGrew:
		$NewHighscoreUI/Label/Tween.interpolate_property($NewHighscoreUI/Label, "rect_scale", Vector2(2, 2), Vector2(1, 1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	else:
		$NewHighscoreUI/Label/Tween.interpolate_property($NewHighscoreUI/Label, "rect_scale", Vector2(1, 1), Vector2(2, 2), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tweenGrew = !tweenGrew
	$NewHighscoreUI/Label/Tween.start()
