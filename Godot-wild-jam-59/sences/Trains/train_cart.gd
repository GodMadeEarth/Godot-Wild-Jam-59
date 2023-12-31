extends RigidBody2D

class_name Train_Cart
var is_connected_to_head = false

func _ready():
	$"drop off".volume_db *= GlobalData.sound_volume
	$pickup.volume_db *= GlobalData.sound_volume
	$AudioStreamPlayer2D2.volume_db *= GlobalData.sound_volume
	pass
func _on_area_2d_area_entered(area):
	if area.get_parent() is Train_Head and area.get_parent().is_dashing: 
		if is_connected_to_head and not get_parent().get_node("Train head").is_dashing:
			var personal_train_head = get_parent().get_node("Train head")
			await personal_train_head.remove_cart(get_index())
		elif !is_connected_to_head:
			
			var train:Train_Head = area.get_parent()
			for i in $Passengers.get_children():
				if i.visible:
					
					train.emit_signal("money_recived",$Passengers.money_value)
			$AudioStreamPlayer2D2.play()
			train.emit_signal("points_recived",$Passengers.point_value)
			await $AudioStreamPlayer2D2.finished
			queue_free()
	pass # Replace with function body.

func hide_dash_effect():
	$"ramming effect".visible = false
	
func show_dash_effect():
	$"ramming effect".visible = true
