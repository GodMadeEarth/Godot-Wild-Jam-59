extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$Settings.get_node("MarginContainer/VBoxContainer/exit btm").button_up.connect(_on_settings_exit_btm_up)
	$"how to play window".get_node("VBoxContainer/exit btm").button_up.connect(_on_htp_exit_btm_up)
	var tween = create_tween()
	var buttons_tween = create_tween().set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property($Node2D,"position",Vector2(633,200),1)
#	tween.tween_property($Node2D,"rotation",0,1)
	tween.tween_property($Node2D,"position",Vector2(633,100),1)
	tween.set_loops()
	tween.play()
	buttons_tween.tween_property($"menu btn container","position",Vector2(145,390),1)
	buttons_tween.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _on_start_button_up():
	get_tree().change_scene_to_file("res://sences/game.tscn")
	pass # Replace with function body.


func _on_settings_button_up():
	$Settings.visible = true
	$"menu btn container/quit".disabled = true
	$"menu btn container/start".disabled = true
	$"menu btn container/How to play".disabled = true
	$"menu btn container/settings".disabled = true
	pass # Replace with function body.

func _on_how_to_play_button_up():
	$"how to play window".visible = true
	$"menu btn container/quit".disabled = true
	$"menu btn container/start".disabled = true
	$"menu btn container/How to play".disabled = true
	$"menu btn container/settings".disabled = true
	pass # Replace with function body.

func _on_quit_button_up():
	get_tree().quit()
	pass # Replace with function body.

func _on_settings_exit_btm_up():
	$"menu btn container/quit".disabled = false
	$"menu btn container/start".disabled = false
	$"menu btn container/How to play".disabled = false
	$"menu btn container/settings".disabled = false

func _on_htp_exit_btm_up():
	$"menu btn container/quit".disabled = false
	$"menu btn container/start".disabled = false
	$"menu btn container/How to play".disabled = false
	$"menu btn container/settings".disabled = false
