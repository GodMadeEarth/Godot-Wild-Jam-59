extends CharacterBody2D
class_name Train_Head

@onready var train_cart = preload("res://sences/Trains/train_cart.tscn")
@export var speed:int = 100
var rotation_speed:float = PI/1.5
var rotation_direction:= 0.0 : set = set_dir, get = get_dir
@onready var last_cart = self
@export var cart_spacing = 32
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move_straight(delta)
	
func move_arc(delta):

	var velocity = (Vector2.UP.rotated(rotation) * speed*delta) 
	rotation = rotation+(rotation_direction*rotation_speed*delta)
	position += velocity
	
func move_straight(delta):
	velocity = (Vector2.UP.rotated(rotation) * speed) 
	
	move_and_slide()

func add_cart():
	var cart = train_cart.instantiate()
	var last_cart_joint = last_cart.get_node("PinJoint2D")
	get_parent().add_child(cart)
	cart.global_position = last_cart_joint.global_position + last_cart.global_position.direction_to(last_cart_joint.global_position) * cart_spacing
	cart.rotation = last_cart.rotation
	last_cart_joint.node_b = cart.get_path()
	print(last_cart.rotation)
	last_cart = cart
	
	print(last_cart.rotation)

# index 0 can never be accessed since it's the head.
func remove_cart(index:int):
	if get_parent().get_children().size()-1 <= index or index <= 0:
		print("Invalid index")
		print(get_parent().get_children().size() )
		return 
	var new_head_cart = get_parent().get_children()[index-1]
	new_head_cart.get_node("PinJoint2D").node_b = ""
	last_cart = new_head_cart
		

	pass
	

func set_dir(ajustment:float):
	rotation_direction+=ajustment
	if rotation_direction+ajustment > 1:
		rotation_direction = 1
	elif rotation_direction+ajustment < -1:
		rotation_direction = -1
		
func get_dir():
	return rotation_direction
