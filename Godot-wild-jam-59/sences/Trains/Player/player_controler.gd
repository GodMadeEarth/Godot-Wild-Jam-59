extends Node2D
@onready var train_head = $"Train head"

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	for i in 3:
		train_head.add_cart()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	lisen_for_controles(delta)
	pass

func lisen_for_controles(delta):
	if train_head.lock_controls:
		return
	#Movement controls
	if Input.is_action_pressed("Move_L"):
		train_head.set_dir(-1)
		train_head.rotation = train_head.rotation+(train_head.rotation_direction*train_head.rotation_speed*delta)
	if Input.is_action_pressed("Move_R"):
		train_head.set_dir(1)
		train_head.rotation = train_head.rotation+(train_head.rotation_direction*train_head.rotation_speed*delta)
	# Dashing 
	if Input.is_action_just_pressed("Dash"):
		train_head.dash()
	# Testing controles up arrow remove cart , down arrow to add a cart
#	if Input.is_action_just_pressed("ui_down"):
#		print("made cart")
#		train_head.add_cart()
#	if Input.is_action_just_pressed("ui_up"):
#		train_head.remove_cart(4)

func _on_train_head_points_recived(points):
	GlobalData.score = points
	pass # Replace with function body.

func _on_train_head_money_recived(money):
	GlobalData.money = money
	pass # Replace with function body.
