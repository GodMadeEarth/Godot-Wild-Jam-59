extends Node2D
@onready var train_cart = preload("res://sences/Trains/train_cart.tscn")
@export var speed:int = 100
var rotation_speed:float = PI*1.5
var rotation_direction:= 0.0 : set = set_dir, get = get_dir
@onready var last_cart = self
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move_straight(delta)
	if Input.is_action_just_pressed("ui_down"):
		print("made cart")
		add_cart()

func move_arc(delta):
	if Input.is_action_pressed("Move_L"):
		set_dir(-0.05)
	if Input.is_action_pressed("Move_R"):
		set_dir(0.05)

	
	var velocity = (Vector2.UP.rotated(rotation) * speed*delta) 
	rotation = rotation+(rotation_direction*rotation_speed*delta)
	position += velocity
	
func move_straight(delta):
	if Input.is_action_pressed("Move_L"):
		set_dir(-1)
		rotation = rotation+(rotation_direction*rotation_speed*delta)
	if Input.is_action_pressed("Move_R"):
		set_dir(1)
		rotation = rotation+(rotation_direction*rotation_speed*delta)
	
	var velocity = (Vector2.UP.rotated(rotation) * speed*delta) 
	position += velocity


func add_cart():
	var cart = train_cart.instantiate()
	var last_cart_joint = last_cart.get_node("PinJoint2D")

	get_parent().add_child(cart)
	cart.global_position = last_cart_joint.global_position
	cart.rotation = last_cart.rotation
	last_cart_joint.node_b = cart.get_path()
	print(last_cart.rotation)
	last_cart = cart
	
	print(last_cart.rotation)

func set_dir(ajustment:float):
	rotation_direction+=ajustment
	if rotation_direction+ajustment > 1:
		rotation_direction = 1
	elif rotation_direction+ajustment < -1:
		rotation_direction = -1
		
func get_dir():
	return rotation_direction