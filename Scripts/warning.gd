extends Node2D


var spawner : Node2D


func _ready() -> void:
	set_process(false)


func _on_Timer_timeout() -> void:
	# Warning time is over. Spawn bomb
	queue_free()
	var bomb_ins = spawner.bomb_obj.instance()
	bomb_ins.position = position
	get_tree().current_scene.add_child(bomb_ins)


func _on_BlinkTimer_timeout() -> void:
	# Blink / Flicker
	visible = not visible
