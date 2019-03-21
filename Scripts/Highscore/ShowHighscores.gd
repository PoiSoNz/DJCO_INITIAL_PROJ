extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("GameJoltAPI").fetch_scores() # Fetches 10 highscores by default

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_NewGameButton_pressed():
	get_tree().change_scene("res://Scenes/MasterLevel.tscn")


func _on_MainMenuButton_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
	pass


func _on_GameJoltAPI_api_scores_fetched(data):
	pass # Replace with function body.