extends CharacterBody2D
class_name Train_Head

@onready var train_cart = preload("res://sences/Trains/train_cart.tscn")

var rotation_direction:= 0.0 : set = set_dir, get = get_dir

@onready var last_cart = self
@export var cart_spacing = 32

var can_dash = true
var is_dashing = false


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
	
	pass # Replace with function body.

func _physics_process(delta):
	
	move_straight(delta)
	
func move_arc(delta):

	velocity = (Vector2.UP.rotated(rotation) * speed*delta) 
	rotation = rotation+(rotation_direction*rotation_speed*delta)
	position += velocity
	
func move_straight(_delta):
	velocity = (Vector2.UP.rotated(rotation) * (speed + (0 if !is_dashing else dash_speed))) 
	
	move_and_slide()

func add_cart():
	var last_cart_joint = last_cart.get_node("PinJoint2D")
	var cart = train_cart.instantiate()

	get_parent().add_child(cart)
	cart.is_connected_to_head = true
	cart.global_position = last_cart_joint.global_position + last_cart.global_position.direction_to(last_cart_joint.global_position) * cart_spacing
	cart.rotation = last_cart.rotation
	cart.head = last_cart
	last_cart_joint.node_b = cart.get_path()
	print(last_cart.rotation)
	last_cart = cart
	
	print(train_length)

# index 0 can never be accessed since it's the head.
func remove_cart(index:int):
	if get_parent().get_children().size()-1 <= index or index <= 1 or !(get_parent().get_children()[index] is Train_Cart):
		print("Invalid index",index)
		print(get_parent().get_children().size() )
		return 
	
	var new_head_cart = get_parent().get_children()[index].head
	new_head_cart.get_node("PinJoint2D").node_b = ""
	get_parent().get_children()[index].is_connected_to_head = false
	get_parent().get_children()[index].emit_signal("disable_tail")

	last_cart = new_head_cart
	get_parent().get_children()[index].head = null
	#Updates the base value when ever carts are lost
	var length = 0
	for i in get_parent().get_children():
		if i is Train_Cart and i.is_connected_to_head:
			length+=1
	trainLenghtStats["Base Value"] = length
	print("Cart remoeved at INDEX: ",index, last_cart)
	
func dash():
	if can_dash and !is_dashing:
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
