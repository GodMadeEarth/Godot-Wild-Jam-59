extends CharacterBody2D
class_name Train_Head

const  train_cart = preload("res://sences/Trains/train_cart.tscn")

var rotation_direction:float= 0.0 : set = set_dir, get = get_dir
var new_velocity:Vector2=Vector2(0.0,0.0)
@onready var last_cart:PhysicsBody2D = self
@export var cart_spacing:int = 32
var pintjoint_connected_notifier:int=0

var can_dash:bool = true
var is_dashing:bool = false


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
# Remember to add this as an upgrade
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
	set_physics_process(true)

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

	get_parent().add_child(cart)
	cart.global_position = last_cart_joint.global_position + last_cart.global_position.direction_to(last_cart_joint.global_position) * cart_spacing
	cart.rotation = last_cart.rotation
	pintjoint_connected_notifier=pintjoint_connected_notifier+1
	print(str(pintjoint_connected_notifier))
	
	last_cart_joint.node_b = cart.get_path()
	print(last_cart.rotation)
	if last_cart is Train_Cart:
		last_cart.get_node("ColorRect").visible = false
	last_cart = cart
	if last_cart is Train_Cart:
		last_cart.get_node("ColorRect").visible = true
	print(train_length)

func deep_delete(node:Train_Cart):
	if node is Train_Cart:
		node.reparent.call_deferred($"../dead carts")
		node.is_connected_to_head = false
		node.set_collision_layer_value(1,false)
		if node.get_node("PinJoint2D").node_b.is_empty():
			return false
		deep_delete(get_parent().get_node(node.get_node("PinJoint2D").node_b))
		

# index 0 can never be accessed since it's the head.
func remove_cart(index:int):
	if get_parent().get_children().size()-1 <= index or index <= 2 or !(get_parent().get_children()[index] is Train_Cart):
		print("Invalid index: ",index)
		return 
	
	var removed_cart:Train_Cart = get_parent().get_children()[index]
	deep_delete(removed_cart)
	
	if last_cart is Train_Cart:
		last_cart.get_node("ColorRect").visible = false
	await get_tree().process_frame
	last_cart = get_parent().get_children()[get_parent().get_children().size()-1]
	if last_cart is Train_Cart:
		last_cart.get_node("ColorRect").visible = true
	
#	removed_cart.emit_signal("disable_tail")
	print("Test ",last_cart," of parent ",get_parent())
	last_cart.get_node("PinJoint2D").node_b = ""
	
#	for i in get_parent().get_children():
#		if i is Train_Cart:
#			if i.get_node("PinJoint2D").node_b == removed_cart.get_path():
#				get_parent().get_node(i)

				
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
		can_dash = false
		is_dashing = true
		$dash_timer.start(dash_duration)
		await get_tree().create_timer(dash_cooldown).timeout
		can_dash = true
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
	pass # Replace with function body.
