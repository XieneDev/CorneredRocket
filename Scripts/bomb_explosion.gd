extends Node2D


var deadly := true


func _ready() -> void:
	set_process(false)
	# Start the explosion
	$Particles2D.emitting = true


func _on_Timer_timeout() -> void:
	queue_free()


func _on_Area2D_body_entered(_body: Node2D) -> void:
	# Kill the player
	if deadly:
		get_tree().current_scene.player.die()


func _on_CollisionTimer_timeout() -> void:
	# After some time, collision is no longer deadly
	deadly = false
