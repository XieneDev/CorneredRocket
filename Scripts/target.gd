extends Node2D


onready var game : Node2D = get_tree().current_scene


func _ready() -> void:
	set_process(false)


func _physics_process(_delta: float) -> void:
	# If it's too close to the border, it gets "dragged" along with it
	var border_size = game.border_size

	if position.x < -border_size/2 + game.effective_margin or position.x > border_size/2 - game.effective_margin:
		position.x = sign(position.x) * (border_size/2 - game.effective_margin)
	
	if position.y < -border_size/2 + game.effective_margin or position.y > border_size/2 -game.effective_margin:
		position.y = sign(position.y) * (border_size/2 - game.effective_margin)


func _on_Area2D_body_entered(_body: Node2D) -> void:
	# When you collect the target
	get_tree().current_scene.collect_target()
