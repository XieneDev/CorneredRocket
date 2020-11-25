extends Control


onready var restart_button = $VBoxContainer/Restart
onready var quit_button = $VBoxContainer/Quit


func _ready() -> void:
	set_process(false)
	
	# Disable Quit button on Web
	if OS.get_name() == "HTML5":
		quit_button.visible = false


func start() -> void:
	visible = true
	restart_button.grab_focus()


func _on_Restart_pressed() -> void:
	visible = false
	get_tree().current_scene.restart()
	Globals.options_menu.select_sfx.play()


func _on_MainMenu_pressed() -> void:
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
	Globals.options_menu.select_sfx.play()


func _on_Quit_pressed() -> void:
	get_tree().quit()
