extends Control

@onready var music_text = $MarginContainer/VBoxContainer/Music/music
@onready var music_slider = $"MarginContainer/VBoxContainer/Music/music slider"
@onready var sound_text = $MarginContainer/VBoxContainer/sound/sound
@onready var sound_slider = $"MarginContainer/VBoxContainer/sound/sound slider"
# Called when the node enters the scene tree for the first time.
func _ready():
	music_text.text = "Music: "+str(music_slider.value)
	sound_text.text = "Sound: "+str(sound_slider.value)
	pass # Replace with function body.




func _on_music_slider_value_changed(value):
	music_text.text = "Music: "+str(value)
	print(value)
	pass # Replace with function body.


func _on_sound_slider_value_changed(value):
	sound_text.text = "Sound: "+str(value)
	print(value)
	pass # Replace with function body.


func _on_exit_btm_button_up():
	visible = false
	pass # Replace with function body.
