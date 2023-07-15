extends Node2D

@export var speed:int = 100
var rotation_speed:float = PI/2
var rotation_direction:= 0.0 : set = set_dir, get = get_dir

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move(delta)

func move(delta):
	if Input.is_action_pressed("Move_L"):
		set_dir(-0.05)
	if Input.is_action_pressed("Move_R"):
		set_dir(0.05)

	
	var velocity = (Vector2.UP.rotated(rotation) * speed*delta) 
	rotation = rotation+(rotation_direction*rotation_speed*delta)
	position += velocity


func set_dir(ajustment:float):
	rotation_direction+=ajustment
	if rotation_direction+ajustment > 1:
		rotation_direction = 1
	elif rotation_direction+ajustment < -1:
		rotation_direction = -1
		
#	if rotation_direction+ajustment < 1 or rotation_direction+ajustment < -1:
#		rotation_direction+=ajustment
	print(rotation_direction)
	
func get_dir():
	return rotation_direction
