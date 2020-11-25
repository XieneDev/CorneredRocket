extends Node2D


var border_shrink_speed : float = 20 # How many pixels the border shrinks in 1 second
var spawn_margin : int = 60 # Margin of how many pixels from the border a target can spawn
var border_size : float = 480 setget set_border_size # Initial border size

var effective_margin : int
var initial_border_size := border_size # Used when resetting the game
var dead := false # Track wether the game is still running or the player is dead

var score := 0 setget set_score

onready var pause_menu := PauseMenu.get_child(0)
onready var game_over := $GameOver.get_child(0)
onready var player := $Player
onready var arrow := $CanvasLayer/Position2D
onready var score_label := $CanvasLayer/Score
onready var border := $Border
onready var rect1 := $ColorRect
onready var rect2 := $ColorRect2
onready var rect3 := $ColorRect3
onready var rect4 := $ColorRect4

onready var target_sfx := $SFX/TargetSFX
onready var die_sfx := $SFX/Die

onready var target_obj := preload("res://Objects/Target.tscn")
var target : Node2D = null


signal die
signal restart


func _ready() -> void:
	# Hide the Game Over screen
	game_over.visible = false
	
	# Call the setter
	self.border_size = border_size
	
	# Create the target object
	target = load("res://Objects/Target.tscn").instance()
	add_child(target)
	spawn_target()


func _process(delta: float) -> void:
	# Check if the game has ended
	if not dead:
		# Shrink the border
		# self.border_size is used so that the setter will be called
		self.border_size -= border_shrink_speed * delta
		
		# Point arrow to target smoothly
		var desired_angle : float = (target.position - player.position).angle() + PI/2
		arrow.rotation = move_toward(arrow.rotation, desired_angle, 3*PI*delta)
	
		if Input.is_action_just_pressed("ui_pause"):
			# Pause the game
			get_tree().paused = not get_tree().paused
			if get_tree().paused:
				pause_menu.start()


func spawn_target() -> void:
	# As the border shrinks, the margin where targets can't be becomes smaller
	effective_margin = min(border_size*0.2, spawn_margin)
	
	# Pick random x and y, considering the margin space
	var x = randi()%(int(border_size) - 2*effective_margin) - border_size/2 + effective_margin
	var y = randi()%(int(border_size) - 2*effective_margin) - border_size/2 + effective_margin
	
	target.position = Vector2(x, y)


func collect_target() -> void:
	# Called when you collect a target
	border_size += 30
	freeze(0.03)
	player.camera.add_trauma(0.35)
	spawn_target()
	self.score += 1
	target_sfx.play()


func die() -> void:
	# When the player dies
	freeze(0.06)
	player.camera.add_trauma(0.6)
	die_sfx.play()
	dead = true
	# Show Game Over screen
	game_over.start()
	emit_signal("die")


func restart() -> void:
	# Reset the game to be played again
	player.reset()
	self.border_size = initial_border_size
	spawn_target()
	dead = false
	self.score = 0
	emit_signal("restart")


func set_border_size(new_size: float) -> void:
	# Set the new size of the border panel
	border.rect_position = Vector2(1, 1) * -new_size/2
	border.rect_size = Vector2(1, 1) * new_size
	
	# Set positions of the 4 red ColorRects that show beyond the border
	rect1.rect_position.y = -new_size/2 - rect1.rect_size.y
	rect2.rect_position.y = floor(new_size/2) # flooring prevents a visual bug
	rect3.rect_position.x = floor(new_size/2) # flooring prevents a visual bug
	rect4.rect_position.x = -new_size/2 - rect4.rect_size.x
	
	border_size = new_size


func set_score(new_score: int) -> void:
	score = new_score
	score_label.text = "Score: " + str(score)


func freeze(t: float) -> void:
	# Freeze game for 't' seconds
	get_tree().paused = true
	yield(get_tree().create_timer(t), "timeout")
	get_tree().paused = false
