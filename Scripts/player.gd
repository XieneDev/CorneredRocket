extends KinematicBody2D
class_name Player


const TURN_SPEED := 2*PI # How fast you can turn around (radians per second)

const ACC := 160 # The rate of acceleration (pixels per second per second)
const MAX_SPEED := 120 # Maximum speed (pixels per second)

var velocity := Vector2.ZERO

onready var game : Node2D = get_tree().current_scene
onready var pivot : Position2D = $Pivot
onready var particles : Particles2D = $Pivot/Particles2D
onready var camera : Camera2D = $Camera2D

onready var explosion_obj := preload("res://Objects/Explosion.tscn")


signal die


func _ready() -> void:
	set_process(false)
	connect("die", game, "die")


func _physics_process(delta: float) -> void:
	# Get direction you are pressing (right/left)
	var press_direction : float = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	# Rotate the sprite and particles
	# NOTE: Don't rotate the whole player, otherwise velocity will change direction
	pivot.rotation += press_direction * TURN_SPEED * delta
	$CollisionShape2D.rotation = pivot.rotation
	
	if Input.is_action_pressed("ui_action"):
		particles.emitting = true
		# Accelerate in the direction you are facing
		velocity += Vector2.UP.rotated(pivot.rotation) * ACC * delta
		# If going faster than max speed, limit speed
		if velocity.length() > MAX_SPEED:
			velocity = velocity.normalized() * MAX_SPEED
	else:
		# Stop emitting particles when not pressing an action button
		particles.emitting = false
	
	velocity = move_and_slide(velocity)
	
	# Check for collision with the border
	var border_size : float = game.border_size
	if position.x > border_size/2 or position.x < -border_size/2 or position.y > border_size/2 or position.y < -border_size/2:
		die()


func die() -> void:
	# Spawn an explosion
	var explosion_ins : Particles2D = explosion_obj.instance()
	explosion_ins.position = position
	explosion_ins.emitting = true
	get_tree().current_scene.add_child(explosion_ins)
		
	# Hide and deactivate the player
	$Pivot/Sprite.visible = false
	particles.emitting = false
	set_physics_process(false)
	emit_signal("die")


func reset() -> void:
	# Reset the player state for a new game
	position = Vector2.ZERO
	velocity = Vector2.ZERO
	pivot.rotation = 0
	$CollisionShape2D.rotation = 0
	set_physics_process(true)
	$Pivot/Sprite.visible = true
