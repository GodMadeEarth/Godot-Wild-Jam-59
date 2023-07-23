extends Control
@onready var start_btm =$"MarginContainer/menu btn container/start"
@onready var settings_btm =$"MarginContainer/menu btn container/settings"
@onready var htp_btm =$"MarginContainer/menu btn container/How to play"
@onready var quit_btm =$"MarginContainer/menu btn container/quit"
# Called when the node enters the scene tree for the first time.
func _ready():
	$Settings.get_node("MarginContainer/VBoxContainer/exit btm").button_up.connect(_on_settings_exit_btm_up)
	$"how to play window".get_node("VBoxContainer/exit btm").button_up.connect(_on_htp_exit_btm_up)
	
	# Animates the menu buttons
	var buttons_tween = create_tween().set_trans(Tween.TRANS_ELASTIC)
	buttons_tween.tween_property($MarginContainer,"position",Vector2(40,460),1)
	buttons_tween.play()
	pass # Replace with function body.

func _on_start_button_up():
	get_tree().change_scene_to_file("res://sences/game.tscn")
	pass # Replace with function body.

func _on_settings_button_up():
	$Settings.visible = true

	quit_btm.disabled = true
	start_btm.disabled = true
	htp_btm.disabled = true
	settings_btm.disabled = true
	pass # Replace with function body.

func _on_how_to_play_button_up():
	$"how to play window".visible = true
	quit_btm.disabled = true
	start_btm.disabled = true
	htp_btm.disabled = true
	settings_btm.disabled = true
	pass # Replace with function body.

func _on_quit_button_up():
	get_tree().quit()
	pass # Replace with function body.

func _on_settings_exit_btm_up():
	quit_btm.disabled = false
	start_btm.disabled = false
	htp_btm.disabled = false
	settings_btm.disabled = false

func _on_htp_exit_btm_up():
	quit_btm.disabled = false
	start_btm.disabled = false
	htp_btm.disabled = false
	settings_btm.disabled = false
