extends Node2D
@onready var train_head = $"Train head"


func _ready():

	pass # Replace with function body.



func _process(delta):
	lisen_for_controles(delta)

	pass
func lisen_for_controles(delta):
	#Movement controls
	if Input.is_action_pressed("Move_L"):
		train_head.rotation_direction = -1
		train_head.rotation = train_head.rotation+(train_head.rotation_direction*train_head.rotation_speed*delta)
	if Input.is_action_pressed("Move_R"):
		train_head.rotation_direction = 1
		train_head.rotation = train_head.rotation+(train_head.rotation_direction*train_head.rotation_speed*delta)

	# Dashing
	if Input.is_action_just_pressed("Dash"):
		train_head.dash()
	# Testing controles
	if Input.is_action_just_pressed("ui_down"):
		print("made cart")
		train_head.add_cart()
	if Input.is_action_just_pressed("ui_up"):
		print("Cart removed")
		var rand_index = randi_range(1,get_children().size()-1)
		train_head.remove_cart(1)
