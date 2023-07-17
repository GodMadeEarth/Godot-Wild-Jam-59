extends RigidBody2D

class_name Train_Cart
var is_connected_to_head = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_area_entered(area):
	if area.get_parent() is Train_Head and area.get_parent().is_dashing: 
		var train:Train_Head = get_parent().get_child(0)
		if is_connected_to_head:
			train.remove_cart(get_index())
		queue_free()
	pass # Replace with function body.
