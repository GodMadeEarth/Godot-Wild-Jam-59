extends Node2D
@onready var train_head:Train_Head = $"Train head"


func _ready():
	for i in range(3):
		train_head.add_cart()
	pass # Replace with function body.



func _process(delta):
	train_head.set_dir(-1)
	train_head.rotation = train_head.rotation+(train_head.rotation_direction*train_head.rotation_speed*delta)
	pass
