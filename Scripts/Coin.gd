extends Node2D

const types_num = 3
const texture_width = 1000;
const texture_height = 296;

const coin_values = [50, 35, 20] # [Gold, Silver, Bronze]

var type = 0 # Gold = 0, Silve = 1, Bronze = 2
var value = coin_values[type]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_type(coin_type):
	type = coin_type
	value = coin_values[coin_type]
	
	var coin_texture_x = 0
	var coin_texture_y = (type*1.0/types_num) * texture_height
	var coin_texture_w = texture_width
	var coin_texture_h = texture_height/3.0
	var coin_rect = Rect2(coin_texture_x, coin_texture_y, coin_texture_w, coin_texture_h)
	
	$Area2D/Sprite.set_region_rect(coin_rect)

func _on_Coin_body_entered(body):
	if body.get_parent().name == "Player":
		body.get_parent().add_currency(value)
		queue_free()