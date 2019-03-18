extends Node

signal health_changed(oldHealth, newHealth)
signal bled(oldHealth, newHealth)
signal immunity(immunity_type)
signal bonus(bonus)
signal score(value)

signal croissant()

signal water()
signal coffee()
signal special()

signal water_ended()
signal coffee_ended()
signal special_ended()

signal bonus_info(bar_value, multiplier_value)

signal money(ects)

func _on_Health_health_changed(oldHealth, newHealth):
	emit_signal("health_changed", oldHealth, newHealth)

func _on_Health_bled(oldHealth, newHealth):
	emit_signal("bled", oldHealth, newHealth)

func _on_Player_immunity(immunity_type):
	emit_signal("immunity", immunity_type)

func _on_CheckPoints_send_bonus(bonus):
	emit_signal("bonus", bonus)

func _on_Player_score(value):
	emit_signal("score", value)
	
func _on_Player_bought_croissant():
	emit_signal("croissant")
	
#func _on_Player_shield(immunity_type, immunity_timer):
#	emit_signal("shield", immunity_type, immunity_timer.time_left)
#
#func _on_Player_coffee(movement_speed_bonus_timer):
#	emit_signal("coffee", movement_speed_bonus_timer)

func _on_Player_bought_water():
	emit_signal("water")

func _on_Player_bought_coffee():
	emit_signal("coffee")

func _on_Player_bought_special():
	emit_signal("special")
	
func _on_Player_water_ended():
	emit_signal("water_ended")

func _on_KinematicBody2D_coffee_ended():
	emit_signal("coffee_ended")

func _on_Player_special_ended():
	emit_signal("special_ended")

func _on_CheckPoints_send_bonus_info(bar_value, multiplier_value):
	emit_signal("bonus_info", bar_value, multiplier_value)
	
func _on_Player_money(ects):
	emit_signal("money", ects)
