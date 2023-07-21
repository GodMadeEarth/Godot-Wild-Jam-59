extends VBoxContainer

signal timer_stopped
@export var time = 0
var timer_on = false

# Called when the node enters the scene tree for the first time.
func _ready():
	timer_stopped.connect(GlobalData.countdown_stoppped)
	time =time*60
	pass # Replace with function body.


# Counts down the time and updates the text
func _process(delta):
	if timer_on:
		time-=delta
		
		var miliseconds = fmod(time,1)*1000
		var seconds = fmod(time,60)
		var minuits = fmod(time,60*60) / 60
		
		var parsed_time = "%2d:%02d:%3d"%[minuits,seconds,miliseconds]
		$Label2.text = parsed_time
		if miliseconds <= 0:
			timer_on = false
			emit_signal("timer_stopped")
	pass

