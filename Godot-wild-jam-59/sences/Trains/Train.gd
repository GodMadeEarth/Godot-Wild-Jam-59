extends CharacterBody2D
class_name Train_Head
signal points_recived(points)
signal money_recived(money)
signal dash_started
signal dash_ended
signal dash_is_ready
const  train_cart = preload("res://sences/Trains/train_cart.tscn")

var rotation_direction:float= 0.0 : set = set_dir, get = get_dir
var new_velocity:Vector2=Vector2(0.0,0.0)
@onready var last_cart:PhysicsBody2D = self
@export var cart_spacing:int = 32
var pintjoint_connected_notifier:int=0

var can_dash:bool = true
var is_dashing:bool = false
var lock_controls = false

@export var rotationStats:Dictionary = {
	"Base Value" : PI/1.5,
	"Increment Value By" : 1,
	"Base Cost" : 12,
	"Increment Cost By" : 6,
	"Total Purchaces" : 0
}
@export var speedStats:Dictionary = {
	"Base Value" : 400,
	"Increment Value By" : 50,
	"Base Cost" : 12,
	"Increment Cost By" : 6,
	"Total Purchaces" : 0
}
@export var dashDuriationStats:Dictionary = {
	"Base Value" : 0.5,
	"Increment Value By" : 0.2,
	"Base Cost" : 12,
	"Increment Cost By" : 6,
	"Total Purchaces" : 0
}
@export var dashCooldownStats:Dictionary = {
	"Base Value" : 2,
	"Increment Value By" : -0.2,
	"Base Cost" : 12,
	"Increment Cost By" : 6,
	"Total Purchaces" : 0
}
@export var dashSpeedStats:Dictionary = {
	"Base Value" : 900,
	"Increment Value By" : 100,
	"Base Cost" : 12,
	"Increment Cost By" : 6,
	"Total Purchaces" : 0
}
@export var trainLenghtStats:Dictionary = {
	"Base Value" : 0,
	"Increment Value By" : 1,
	"Base Cost" : 12,
	"Increment Cost By" : 6,
	"Total Purchaces" : 0
}

var rotation_speed:float:
	get:
		return rotationStats["Base Value"] + (rotationStats["Increment Value By"] * rotationStats["Total Purchaces"])

var speed:int:
	get:
		return speedStats["Base Value"] + (speedStats["Increment Value By"] * speedStats["Total Purchaces"])

var dash_duration:float:
	get:
		return dashDuriationStats["Base Value"] + (dashDuriationStats["Increment Value By"] * dashDuriationStats["Total Purchaces"])

var dash_cooldown:float:
	get:
		return dashCooldownStats["Base Value"] + (dashCooldownStats["Increment Value By"] * dashCooldownStats["Total Purchaces"])

var dash_speed:int:
	get:
		return dashSpeedStats["Base Value"] + (dashSpeedStats["Increment Value By"] * dashSpeedStats["Total Purchaces"])

var train_length:int:
	get:
		return trainLenghtStats["Base Value"] + (trainLenghtStats["Increment Value By"] * trainLenghtStats["Total Purchaces"])

func _ready():
	GlobalData.game_over.connect(stop_train)
	set_physics_process(true)
	$dash_cooldown.wait_time = dash_cooldown

func _physics_process(delta):	
	move_straight(delta)
	
func move_arc(delta):
	velocity = (Vector2.UP.rotated(rotation) * speed*delta) 
	rotation = rotation+(rotation_direction*rotation_speed*delta)
	position += velocity
	
func move_straight(_delta):
	new_velocity = (Vector2.UP.rotated(rotation) * (speed + (0 if !is_dashing else dash_speed))) 
	set_velocity(new_velocity)
	move_and_slide()
	new_velocity=velocity

func add_cart():
	var last_cart_joint:PinJoint2D = last_cart.get_node("PinJoint2D")
	var cart = train_cart.instantiate()
	cart.is_connected_to_head = true
	dash_started.connect(cart.show_dash_effect)
	dash_ended.connect(cart.hide_dash_effect)
	cart.get_node("Passengers").money_gained.connect(money_changed)
	cart.get_node("Passengers").points_gained.connect(score_changed)
	get_parent().add_child(cart)
	cart.global_position = last_cart_joint.global_position + last_cart.global_position.direction_to(last_cart_joint.global_position) * cart_spacing
	cart.rotation = last_cart.rotation
	pintjoint_connected_notifier=pintjoint_connected_notifier+1
	print(str(pintjoint_connected_notifier))
	
	last_cart_joint.node_b = cart.get_path()
	last_cart = cart

func relocate_carts(node:Train_Cart):
	if node is Train_Cart:
		node.reparent.call_deferred($"../dead carts")
		node.is_connected_to_head = false
		node.set_collision_layer_value(1,false)
		dash_started.disconnect(node.show_dash_effect)
		dash_ended.disconnect(node.hide_dash_effect)
		node.get_node("Passengers").money_gained.disconnect(money_changed)
		node.get_node("Passengers").points_gained.disconnect(score_changed)
		if node.get_node("PinJoint2D").node_b.is_empty():
			return false
		relocate_carts(get_parent().get_node(node.get_node("PinJoint2D").node_b))
		
# index 0 can never be accessed since it's the head.
func remove_cart(index:int):
	if get_parent().get_children().size()-1 < index or index <= 3 or !(get_parent().get_children()[index] is Train_Cart):
		print("Invalid index: ",index,get_parent().get_children().size())
		return 
	
	var removed_cart:Train_Cart = get_parent().get_children()[index]
	relocate_carts(removed_cart)
	
	await get_tree().process_frame
	last_cart = get_parent().get_children()[get_parent().get_children().size()-1]

	print("Test ",last_cart," of parent ",get_parent())
	last_cart.get_node("PinJoint2D").node_b = ""
	
	#Updates the base value when ever carts are lost
	var length = 0
	for i in get_parent().get_children():
		if i is Train_Cart and i.is_connected_to_head:
			length+=1
	trainLenghtStats["Base Value"] = length

#	print("Cart remoeved at INDEX: ",removed_cart," <-----Was the cart that was removed) (Now the last cart-------> ", last_cart)
	
func dash():
	if can_dash==true && is_dashing==false:
		print("DASHING!!!")
		emit_signal("dash_started")
		$"ramming effect".visible = true
		can_dash = false
		is_dashing = true
		$dash_timer.start(dash_duration)
		$dash_cooldown.start(dash_cooldown)
		await $dash_cooldown.timeout
#		get_tree().create_timer(dash_cooldown).timeout
		can_dash = true
		emit_signal("dash_is_ready")

	pass

func set_dir(ajustment:float):
	rotation_direction+=ajustment
	if rotation_direction+ajustment > 1:
		rotation_direction = 1
	elif rotation_direction+ajustment < -1:
		rotation_direction = -1
		
func get_dir():
	return rotation_direction

func _on_dash_timer_timeout():
	is_dashing = false
	$"ramming effect".visible = false
	emit_signal("dash_ended")
	pass # Replace with function body.

func score_changed(points):
	emit_signal("points_recived",points)
	
func money_changed(money):
	emit_signal("money_recived",money)

func stop_train():
	lock_controls = true
	speedStats["Base Value"] = 0
	
