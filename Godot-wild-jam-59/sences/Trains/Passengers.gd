extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_area_entered(area):
	var stations:Array[Node] = area.get_parent().get_parent().get_children()
	stations.erase(area.get_parent())
	
	if area.get_parent() is RigidBody2D:
		pass
	
	for passenger in get_children():
		if not passenger.visible:
			passenger.visible = true
			passenger.modulate = stations.pick_random().modulate
		
		if passenger.modulate == area.get_parent().modulate:
			passenger.visible = false
