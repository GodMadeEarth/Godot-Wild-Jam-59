extends Node


signal update_score
signal update_money
signal game_over

var sound_volume = 1.0:
	set(volume):
		sound_volume = (volume/100)

var music_volume = 1.0:
	set(volume):
		music_volume = (volume/100)
		
var score:int = 0:
	set(bonus): 
		score += bonus
		emit_signal("update_score")

var money:int = 0 :
	set(bonus): 
		money += bonus
		emit_signal("update_money")

func _ready():
	pass # Replace with function body.

func countdown_stoppped():
	emit_signal("game_over")
	print("The count down has stopped!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
