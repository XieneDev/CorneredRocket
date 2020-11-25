extends Control


onready var play_button := $VBoxContainer/Play
onready var options_button := $VBoxContainer/Options
onready var quit_button := $VBoxContainer/Quit


func _ready() -> void:
	play_button.grab_focus()
	
	# Disable Quit button on Web
	if OS.get_name() == "HTML5":
		quit_button.visible = false


func _process(delta: float) -> void:
	# Move the stars on the background
	$ParallaxBackground.scroll_offset.x += 40*delta
	$ParallaxBackground.scroll_offset.y += 20*delta


func _on_Play_pressed() -> void:
	get_tree().change_scene("res://Scenes/Node2D.tscn")
	Globals.options_menu.select_sfx.play()


func _on_Options_pressed() -> void:
	visible = false
	Globals.options_menu.start()
	Globals.options_menu.connect("leave", self, "leave_options")
	Globals.options_menu.select_sfx.play()


func leave_options() -> void:
	visible = true
	options_button.grab_focus()
	Globals.options_menu.disconnect("leave", self, "leave_options")


func _on_Quit_pressed() -> void:
	get_tree().quit()


func _on_YT_pressed() -> void:
	OS.shell_open("https://www.youtube.com/channel/UC5ZQIuHGBrYmnSwtgTBHgxA")
	Globals.options_menu.select_sfx.play()


func _on_Itch_pressed() -> void:
	OS.shell_open("https://xienedev.itch.io/")
	Globals.options_menu.select_sfx.play()


func _on_Twitter_pressed() -> void:
	OS.shell_open("https://twitter.com/XieneDev")
	Globals.options_menu.select_sfx.play()
