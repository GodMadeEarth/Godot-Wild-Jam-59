extends Node2D
@onready var train_head:Train_Head = $"Train head"
@onready var rays:Array[Node] = $"Train head".get_children()
# Called when the node enters the scene tree for the first time.
enum train_states {WONDER,CHASE,DASH,AVOID}
var active_state:train_states = train_states.WONDER
var target_pos:Vector2

func _ready():
	randomize()
	for i in randi_range(3,10):
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
	var results = []
	for ray in rays:
		if ray is RayCast2D:
			if ray.is_colliding()==true:
				if ray.get_collider() is Train_Cart and ray.get_collider().get_parent().get_node("Train head") != train_head:
					results.append(Train_Cart)
				
				elif ray.get_collider() is Train_Head and ray.get_collider() != train_head:
					results.append(Train_Head)
				
				elif ray.get_collider() is TileMap or ray.get_collider().get_parent() is Train_Station:
					if ray.get_collider().is_in_group("entrance"):
						results.append(Area2D)
					else:
						results.append(StaticBody2D)
					
				else:
					results.append(null)
			else:
				results.append(null)
	return results
	
func state_manager():
	var colliders = sensor()
	
	active_state = train_states.WONDER

		
	if colliders.has(Train_Cart) or colliders.has(Train_Head) or colliders.has(Area2D):
		active_state = train_states.CHASE
		
		if colliders[2] == Train_Cart:
			active_state = train_states.DASH
	
	if colliders.has(StaticBody2D):
		active_state = train_states.AVOID
		
	
	


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
			var colliders = sensor()
			train_head.rotation_direction = 0
			if colliders[0] == Train_Cart: train_head.rotation_direction = -1
			if colliders[1] == Train_Cart: train_head.rotation_direction = -0.1
			if colliders[2] == Train_Cart: train_head.rotation_direction = 0
			if colliders[3] == Train_Cart: train_head.rotation_direction = 0.1
			if colliders[4] == Train_Cart: train_head.rotation_direction = 1
			
			train_head.rotation = train_head.rotation+(train_head.rotation_direction*train_head.rotation_speed*delta)
			pass
		train_states.DASH:
			train_head.dash()
		train_states.AVOID:
			var colliders = sensor()
			train_head.rotation_direction = 0
			if colliders[0] == StaticBody2D: train_head.rotation_direction = 0.1
			if colliders[1] == StaticBody2D: train_head.rotation_direction = 1

			if colliders[3] == StaticBody2D: train_head.rotation_direction = -1
			if colliders[4] == StaticBody2D: train_head.rotation_direction = -0.1

			if colliders[2] == StaticBody2D: train_head.rotation_direction = randi_range(-1,1) + train_head.rotation_direction * 5

#			train_head.rotation_direction = look_dir
			train_head.rotation = train_head.rotation+(train_head.rotation_direction*train_head.rotation_speed*delta)
			pass
#	print("Looking at: "+str(look_dir))
#	print("Current state: "+str(active_state))
	pass
