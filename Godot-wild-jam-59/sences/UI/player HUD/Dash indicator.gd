extends Control

var time = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if get_node("../..").train_head:
		var train_head  = get_node("../..").train_head
		var timer:Timer = train_head.get_node("dash_cooldown")
		if train_head.can_dash:
			$TextureProgressBar.max_value = fmod(timer.wait_time,60)
			$TextureProgressBar.value = 0
			$Label.text = "Dash Ready"
		else:
			$TextureProgressBar.value = fmod(timer.time_left,60)
			$Label.text = "Cooldown\n %2d:%2d"%[fmod(timer.time_left,60),fmod(timer.time_left,1)*100]

