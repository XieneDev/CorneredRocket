extends Control


onready var resume_button := $VBoxContainer/Resume
onready var options_button := $VBoxContainer/Options
onready var quit_button := $VBoxContainer/Quit


signal leave


func _ready():
	visible = false
	set_process(false)
	
	# Disable Quit button on Web
	if OS.get_name() == "HTML5":
		quit_button.visible = false


func _process(_delta: float):
	if Input.is_action_just_pressed("ui_pause"):
		Globals.options_menu.leave()
		leave()


func start() -> void:
	visible = true
	resume_button.grab_focus()
	set_process(true)


func leave() -> void:
	get_tree().paused = false
	visible = false
	set_process(false)


func _on_Resume_pressed() -> void:
	leave()
	Globals.options_menu.select_sfx.play()


func _on_Options_pressed() -> void:
	$VBoxContainer.visible = false
	Globals.options_menu.start()
	Globals.options_menu.connect("leave", self, "leave_options")
	Globals.options_menu.select_sfx.play()


func leave_options() -> void:
	$VBoxContainer.visible = true
	options_button.grab_focus()
	Globals.options_menu.disconnect("leave", self, "leave_options")


func _on_Quit_pressed() -> void:
	get_tree().quit()
