extends Control

var currentHighscores

# Called when the node enters the scene tree for the first time.
func _ready():
	$NewHighscoreUI.visible = false
	$RegularScoreUI.visible = false
	get_node("GameJoltAPI").fetch_scores()

func check_new_score():
	#for score in range(currentHighscores):
		#if 
	#if novo score:
	#var score = globals.playerScore
	var score = 100
	var place = "6th"
	$NewHighscoreUI.visible = true
	$NewHighscoreUI.add_new_score(score, place)

func _on_GameJoltAPI_api_scores_fetched(data):
	currentHighscores = JSON.parse(data).result.response.scores
	print(currentHighscores)
	check_new_score()

func _on_HighscoresButton_pressed():
	get_tree().change_scene("res://Scenes/ShowHighscores.tscn")

func _on_NewGameButton_pressed():
	get_tree().change_scene("res://Scenes/MasterLevel.tscn")

func _on_MainMenuButton_pressed():
	#get_tree().change_scene("res://Scenes/MainMenu.tscn")
	print("vai para o main menu")
	pass