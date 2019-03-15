extends Control

const no_immunity = 0
const one_time_immunity = 1
const persistent_immunity = 2

onready var previous_immunity_type = no_immunity
var immunity_type
onready var coffe_active = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_HUD_croissant():
	$Croissant.visible = true
	$Tween.interpolate_property($Croissant, "scale", Vector2(0.3,0.3),Vector2(0.15,0.15), 0.4, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.interpolate_property($Croissant, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1.2, Tween.TRANS_CUBIC, Tween.EASE_IN)
	$Tween.start()

func _on_HUD_water():
	immunity_type = one_time_immunity
	
	if previous_immunity_type == persistent_immunity:
		remove_from_hud("special")
		
	add_animation($Water)
	previous_immunity_type = one_time_immunity

func _on_HUD_coffee():
	coffe_active = true
	add_animation($Coffee)
	
func _on_HUD_special():
	immunity_type = persistent_immunity
	
	if previous_immunity_type == one_time_immunity:
		remove_from_hud("water")
	
	if coffe_active:
		remove_from_hud("coffee")
		
	add_animation($Special)
	previous_immunity_type = persistent_immunity
	
func add_animation(sprite):
	sprite.visible = true
	sprite.modulate = Color(1, 1, 1, 1)
	$Tween.interpolate_property(sprite, "scale", Vector2(0.3,0.3),Vector2(0.15,0.15), 0.4, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.start()
	
#func _on_HUD_shield(immunity_type, immunity_timer):
#	match immunity_type:
#		no_immunity:
#			remove_from_hud(previous_immunity_type)
#		one_time_immunity:
#			add_water_to_hud(previous_immunity_type, immunity_timer)
#		persistent_immunity:
#			add_special_to_hud(immunity_timer)
#
#	previous_immunity_type = immunity_type
#
#func add_water_to_hud(previous_immunity_type, immunity_timer):
#
#	if previous_immunity_type == one_time_immunity:
#		return 
#	elif previous_immunity_type == persistent_immunity:
#		remove_from_hud(persistent_immunity)
#
#	$Water.visible = true
#	$Water.modulate = Color(1, 1, 1, 1)
#	$Tween.interpolate_property($Water, "scale", Vector2(0.3,0.3),Vector2(0.15,0.15), 0.4, Tween.TRANS_CUBIC, Tween.EASE_OUT)
#	$Tween.start()
#
#func add_special_to_hud(immunity_timer):
#
#	if previous_immunity_type == persistent_immunity:
#		return 
#	elif previous_immunity_type == one_time_immunity:
#		remove_from_hud(one_time_immunity)
#
#	$Special.visible = true
#	$Special.modulate = Color(1, 1, 1, 1)
#	$Tween.interpolate_property($Special, "scale", Vector2(0.3,0.3),Vector2(0.15,0.15), 0.4, Tween.TRANS_CUBIC, Tween.EASE_OUT)
#	$Tween.start()
#
func remove_from_hud(sprite_name):
	var sprite = null

	match sprite_name:
		"water":
			sprite = $Water
		"coffee":
			sprite = $Coffee
		"special":
			sprite = $Special

	$Tween.interpolate_property(sprite, "scale", Vector2(0.15,0.15),Vector2(0.2,0.2), 0.1, Tween.TRANS_CUBIC, Tween.EASE_IN)
	$Tween.interpolate_property(sprite, "scale", Vector2(0.2,0.2),Vector2(0.15,0.15), 0.1, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.interpolate_property(sprite, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.4, Tween.TRANS_CUBIC, Tween.EASE_IN)
	$Tween.start()

func _on_HUD_water_ended():
	remove_from_hud("water")
	immunity_type = no_immunity
	previous_immunity_type = no_immunity

func _on_HUD_coffee_ended():
	coffe_active = false
	remove_from_hud("coffee")

func _on_HUD_special_ended():
	remove_from_hud("special")
	immunity_type = no_immunity
	previous_immunity_type = no_immunity
