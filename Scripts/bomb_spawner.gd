extends Node2D


onready var game = get_tree().current_scene

onready var warning_obj := preload("res://Objects/Warning.tscn")
onready var bomb_obj := preload("res://Objects/BombExplosion.tscn")


func _ready() -> void:
	set_process(false)
	$Timer.start()
	get_tree().current_scene.connect("restart", self, "restart")
	get_tree().current_scene.connect("die", self, "die")


func _on_Timer_timeout() -> void:
	# Spawn a warning at the current player position
	var warning_ins = warning_obj.instance()
	warning_ins.position = game.player.position
	warning_ins.spawner = self
	game.add_child(warning_ins)


func die() -> void:
	$Timer.stop()


func restart() -> void:
	$Timer.start()
