extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("GameJoltAPI").fetch_scores() # Fetches 10 highscores by default

func _on_NewGameButton_pressed():
	get_tree().change_scene("res://Scenes/MasterLevel.tscn")

func _on_MainMenuButton_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
	pass

func _on_GameJoltAPI_api_scores_fetched(data):
	$Fetching.visible = false
	
	var highscores1to5 = ""
	var highscores6to10 = ""
	
	var highscores = JSON.parse(data).result.response.scores
	
	if typeof(highscores) == TYPE_STRING:
		$HighscoreList.visible = true
		$NotFound.visible = true
		return
	
	for pos in range(10):
		var place = pos + 1
		var highscoreString = String(place) + ". \n"
		
		if pos < highscores.size():
			var nickname = highscores[pos].guest
			var score = highscores[pos].score
			highscoreString = String(place) + ". " + nickname + "    " + score + "\n"
		
		if place <= 5:
			highscores1to5 += highscoreString
		else:
			highscores6to10 += highscoreString
	
	$HighscoreList/List1to5.text = highscores1to5
	$HighscoreList/List6to10.text = highscores6to10
	$HighscoreList.visible = true