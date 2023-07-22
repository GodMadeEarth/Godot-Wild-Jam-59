extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalData.game_over.connect(show_score)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_return_btm_button_up():
	get_tree().change_scene_to_file("res://sences/UI/menu.tscn")
	pass # Replace with function body.

func show_score():
	visible = true
	$"VBoxContainer/Current score".text = "Score: "+str(GlobalData.score)
	pass
