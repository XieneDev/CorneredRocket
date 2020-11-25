extends Control


onready var select_sfx := $SelectSFX
onready var screenshake_button := $VBoxContainer/Screenshake
onready var fullscreen_button := $VBoxContainer/Fullscreen


signal leave


func _ready() -> void:
	visible = false
	set_process(false)


func start() -> void:
	visible = true
	screenshake_button.grab_focus()
	fullscreen_button.text = "Fullscreen: On" if OS.window_fullscreen else "Fullscreen: Off"


func _on_Screenshake_pressed() -> void:
	Globals.screenshake = not Globals.screenshake
	screenshake_button.text = "Screenshake: On" if Globals.screenshake else "Screenshake: Off"
	select_sfx.play()


func _on_Fullscreen_pressed() -> void:
	fullscreen_button.text = "Fullscreen: Off" if OS.window_fullscreen else "Fullscreen: On"
	OS.window_fullscreen = !OS.window_fullscreen
	select_sfx.play()


func leave() -> void:
	emit_signal("leave")
	visible = false


func _on_Back_pressed() -> void:
	leave()
	select_sfx.play()
