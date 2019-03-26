extends Node

var frameDelta
var health = 100
var bleed = true

signal health_changed(oldHealth, newHealth)
signal bled(oldHealth, newHealth)

# Called when the node enters the scene tree for the first time.
#func _ready():
#	emit_signal("health_changed", health, health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	frameDelta = delta;
	
	if bleed:
		health_bleed(2)

func health_increment(gain):
	var oldHP = change_health(gain)
	
	bleed = false
	emit_signal("health_changed", oldHP, health)

func reduce_health(damage):
	var oldHP = change_health(-damage)
	
	bleed = false
	emit_signal("health_changed", oldHP, health)

func health_bleed(value):
	var oldHP = change_health(-apply_delta(value))
	
	emit_signal("bled", oldHP, health)

func change_health(amount):
	var oldHP = health
	
	var newHP = health + amount
	if newHP < 0 :
		newHP = 0
	elif newHP > 100:
		newHP = 100
	health = newHP
	
	verify_hp_threshold(oldHP, newHP)
	
	return oldHP

func verify_hp_threshold(previousHealth, newHealth):
	if previousHealth > 30 && newHealth <= 30:
		get_parent().set_slowed(true)
	elif previousHealth <= 30 && newHealth > 30:
		get_parent().set_slowed(false)

func apply_delta(value):
	return value * frameDelta

func _on_Player_reenable_bleeding():
	bleed = true