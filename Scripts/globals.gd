extends Node


var screenshake := true
var music := true

onready var options_menu := OptionsMenu.get_child(0)


func _ready() -> void:
	set_process(false)
	if OS.get_name() == "HTML5":
		# Remove the Escape button as a pausing button on Web
		InputMap.action_erase_event("ui_pause", InputMap.get_action_list("ui_pause")[0])
