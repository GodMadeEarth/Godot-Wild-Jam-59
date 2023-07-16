extends Node2D
@onready var train_head:Train_Head = $"Train head"

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(2):
		train_head.add_cart()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	train_head.set_dir(-1)
	train_head.rotation = train_head.rotation+(train_head.rotation_direction*train_head.rotation_speed*delta)
	pass
