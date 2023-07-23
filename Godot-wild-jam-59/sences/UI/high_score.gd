extends Control

var score_saver = SaveHighScore.new()

func _ready():
	GlobalData.game_over.connect(show_score)
	pass # Replace with function body.

func _on_return_btm_button_up():
	get_tree().change_scene_to_file("res://sences/UI/menu.tscn")
	pass # Replace with function body.

func show_score():
	visible = true
	score_saver.update_highscore()
	score_saver.save()
	var high_scores = score_saver.hightscores
	var rank = "1st"
	var i = high_scores.size()
	for score in high_scores:
		var score_lable = Label.new()
		match i:
			1:
				rank = "1st: "
			2:
				rank = "2nd: "
			3:
				rank = "3rd: "
			_:
				rank = str(i)+"th: "
		score_lable.text =  rank+str(score)
		$"VBoxContainer/Current score".add_sibling(score_lable)
		i-=1
#	for i in high_scores.size():
#		var score_lable = Label.new()
#		match i:
#			0:
#				rank = "1st: "
#			1:
#				rank = "2nd: "
#			2:
#				rank = "3rd: "
#			_:
#				rank = str(i)+"th: "
#		score_lable.text =  rank+str(high_scores[i])
#		$"VBoxContainer/Current score".add_sibling(score_lable)
#
	$"VBoxContainer/Current score".text = "Score: "+str(GlobalData.score)
	print(high_scores)
	pass
