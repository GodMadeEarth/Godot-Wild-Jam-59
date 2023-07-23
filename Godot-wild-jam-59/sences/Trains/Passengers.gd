extends Node2D

signal points_gained(points:int)
signal money_gained(money:int)
@export var point_value:int = 5
@export var bonus_multiplyer:float = 3.0
@export var money_value = 3
@onready var bump = $"../AudioStreamPlayer2D"

func _ready():
	pass # Replace with function body.

func manage_passengers(area):
	var stations:Array[Node] = area.get_parent().get_parent().get_children()
	stations.erase(area.get_parent())
	var color_matches = 0
	var bonus = 0
	
	for passenger in get_children():
		if not passenger.visible:
			bump.play()
			passenger.visible = true
			passenger.modulate = stations.pick_random().modulate
			emit_signal("money_gained",money_value)
		if passenger.modulate == area.get_parent().modulate:
			color_matches+=1
			emit_signal("points_gained",point_value)
			passenger.visible = false
			
	if color_matches >= floor(get_children().size()/2):
		bonus = round((point_value*bonus_multiplyer)*color_matches)
		emit_signal("points_gained",bonus)

func _on_area_2d_area_entered(area):
	if area.get_parent() is Train_Station:
		manage_passengers(area)
