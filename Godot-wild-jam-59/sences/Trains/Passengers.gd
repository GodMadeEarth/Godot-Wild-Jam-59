extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func manage_passengers(area):
	var stations:Array[Node] = area.get_parent().get_parent().get_children()
	stations.erase(area.get_parent())
	
	for passenger in get_children():
		if not passenger.visible:
			passenger.visible = true
			passenger.modulate = stations.pick_random().modulate
		
		if passenger.modulate == area.get_parent().modulate:
			passenger.visible = false


func _on_area_2d_area_entered(area):
	if area.get_parent() is Train_Head and area.get_parent().is_dashing: 
		var cart_index = get_parent().get_parent().get_children().find(get_parent())
		var train:Train_Head = get_parent().get_parent().get_child(0)
		train.remove_cart(cart_index)
		get_parent().queue_free()
	
	elif area.get_parent() is Train_Station: manage_passengers(area)
