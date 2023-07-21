extends Node

signal update_score
signal update_money

var countdown_timer:Countdown_Timer

var score:int = 0:
	set(bonus): 
		score += bonus
		emit_signal("update_score")
var money:int = 0 :
	set(bonus): 
		money += bonus
		emit_signal("update_money")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func countdown_stoppped():
	print("The count down has stopped!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
