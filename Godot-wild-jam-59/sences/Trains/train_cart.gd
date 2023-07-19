extends RigidBody2D

class_name Train_Cart
signal disable_tail
var is_connected_to_head = false
var head = null
func _on_area_2d_area_entered(area):
	if area.get_parent() is Train_Head and area.get_parent().is_dashing: 
		print(get_parent().get_child(0))
		var train:Train_Head = get_parent().get_child(0)
		
		if is_connected_to_head:
			await train.remove_cart(get_index())
		queue_free()
	pass # Replace with function body.

func _on_disable_tail():
	if !$PinJoint2D.node_b.is_empty():
		get_parent().get_node($PinJoint2D.node_b).emit_signal("disable_tail")
		is_connected_to_head = false
	pass # Replace with function body.
