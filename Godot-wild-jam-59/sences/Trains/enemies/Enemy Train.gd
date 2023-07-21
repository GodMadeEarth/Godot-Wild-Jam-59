extends Node2D
@onready var train_head:Train_Head = $"Train head"
@onready var ray:RayCast2D = $"Train head/RayCast2D"
# Called when the node enters the scene tree for the first time.
enum train_states {WONDER,CHASE,DASH,AVOID}
var active_state:train_states = train_states.WONDER
var target_pos:Vector2

func _ready():
	randomize()
	for i in range(2):
		train_head.add_cart()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
#	if sensor():
#		global_position = Vector2(1715,2292)
	state_manager()
	state_machine(delta)
#	train_head.set_dir(-1)
#	train_head.rotation = train_head.rotation+(train_head.rotation_direction*train_head.rotation_speed*delta)
	pass

func sensor():
	if ray.is_colliding()==true:
		return ray.get_collider()
	else:
		return null
	
func state_manager():
	var collider = sensor()
	if collider:
		if collider is Train_Cart:
			active_state = train_states.DASH
		elif collider is Train_Station or collider is Train_Head:
			active_state = train_states.CHASE
		elif sensor() is StaticBody2D:
			active_state = train_states.WONDER
	elif collider == null:
		active_state = train_states.WONDER
	pass
	
	
	
func state_machine(delta):
	var look_dir = 0
	match active_state:
		train_states.WONDER:
			if $Timer.is_stopped():
				look_dir = randi_range(-1,1)
				while look_dir == 0:
					look_dir = randi_range(-1,1)
				$Timer.start(0.5)
			train_head.rotation_direction = look_dir
			train_head.rotation = train_head.rotation+(train_head.rotation_direction*train_head.rotation_speed*delta)
#			print("Looking at: "+str(look_dir))
			pass
		train_states.CHASE:
			train_head.rotation_direction = 0
			pass
		train_states.DASH:
			train_head.dash()
		train_states.AVOID:
			while look_dir == 0:
				look_dir = randi_range(-1,1)

			train_head.rotation_direction = look_dir
			train_head.rotation = train_head.rotation+(train_head.rotation_direction*train_head.rotation_speed*delta)
			pass
#	print("Looking at: "+str(look_dir))
#	print("Current state: "+str(active_state))
	pass
