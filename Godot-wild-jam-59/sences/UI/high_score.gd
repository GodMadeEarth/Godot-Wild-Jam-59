extends Control



func _ready():
	GlobalData.game_over.connect(show_score)
	pass # Replace with function body.

func _on_return_btm_button_up():
	get_tree().change_scene_to_file("res://sences/UI/menu.tscn")
	pass # Replace with function body.

func show_score():
	visible = true
	$"VBoxContainer/Current score".text = "Score: "+str(GlobalData.score)
	pass
