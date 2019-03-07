extends Node

var green_hp = Color("87da37")
var red_hp = Color("cd0404")

signal reenable_bleeding()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_HUD_health_changed(oldHealth, newHealth):
	animate_bar(oldHealth, newHealth)
	var t = Timer.new()
	
	#wait for the animation before enabling bleeding again
	t.set_wait_time(0.5)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	
	emit_signal("reenable_bleeding")

func _on_HUD_bled(oldHealth, newHealth):
	animate_bar(oldHealth, newHealth)

func animate_bar(oldHealth, newHealth):
	if oldHealth >= 30 && newHealth < 30:
		$Tween.interpolate_property($ProgressBar.get("custom_styles/fg/bg_color"), "bg_color", green_hp, red_hp, 0.3, Tween.TRANS_CUBIC,Tween.EASE_OUT)
	elif oldHealth < 30 && newHealth >= 30:
		$Tween.interpolate_property($ProgressBar.get("custom_styles/fg/bg_color"), "bg_color", red_hp, green_hp, 0.3, Tween.TRANS_CUBIC,Tween.EASE_OUT)
	
	$Tween.interpolate_property($ProgressBar, "value", oldHealth, newHealth, 0.3, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.start()
