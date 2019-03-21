extends Control

var currentHighscores = []

# Called when the node enters the scene tree for the first time.
func _ready():
	$NewHighscoreUI.visible = false
	$RegularScoreUI.visible = false
	get_node("GameJoltAPI").fetch_scores()

func check_new_score():
	var score = globals.playerScore
	var place = -1
	
	if typeof(currentHighscores) == TYPE_ARRAY:
		for pos in range(currentHighscores.size()):
			var currHighscore = currentHighscores[pos].sort
			if score >= int(currHighscore):
				place = pos + 1
				break
		
		if place == -1 && currentHighscores.size() < 10: #Guarantee the is inside the top 10 if there less then 10 registered highscores
			place = currentHighscores.size() + 1
	else:
		place = 1
	
	if place == 1:
		place = String(place) + "st"
	elif place == 2:
		place = String(place) + "nd"
	elif place == 3:
		place = String(place) + "rd"
	elif place >= 4:
		place = String(place) + "th"
	else: #place = -1 if player score is is not inside top 10
		$RegularScoreUI.visible = true
		return
	
	$NewHighscoreUI.visible = true
	$NewHighscoreUI.add_new_score(score, place)

func _on_GameJoltAPI_api_scores_fetched(data):
	currentHighscores = JSON.parse(data).result.response.scores
	print("oi: ", currentHighscores)
	check_new_score()

func _on_HighscoresButton_pressed():
	get_tree().change_scene("res://Scenes/ShowHighscores.tscn")

func _on_NewGameButton_pressed():
	get_tree().change_scene("res://Scenes/MasterLevel.tscn")

func _on_MainMenuButton_pressed():
	#get_tree().change_scene("res://Scenes/MainMenu.tscn")
	print("vai para o main menu")