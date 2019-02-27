extends Node

signal health_changed(health)

func _on_Health_health_changed(health):
	emit_signal("health_changed", health)
