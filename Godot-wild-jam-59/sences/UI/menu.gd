extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$Settings.get_node("MarginContainer/VBoxContainer/exit btm").button_up.connect(_on_exit_btm_up)
	var tween = create_tween()
	tween.tween_property($Node2D,"position",Vector2(633,200),1)
#	tween.tween_property($Node2D,"rotation",0,1)
	tween.tween_property($Node2D,"position",Vector2(633,100),1)
	tween.set_loops()
	tween.play()
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
	pass # Replace with function body.


func _on_quit_button_up():
	get_tree().quit()
	pass # Replace with function body.

func _on_exit_btm_up():
	$"menu btn container/quit".disabled = false
	$"menu btn container/start".disabled = false
