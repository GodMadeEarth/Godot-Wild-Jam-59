extends Control

@onready var items_cotainer =  $"purchest window"/HBoxContainer
@export var train_head:Train_Head
# Called when the node enters the scene tree for the first time.
func _ready():
	$"Info HUD/Game timer".timer_on = true
	$"purchest window".visible = false
	GlobalData.update_money.connect(update_money)
	GlobalData.update_score.connect(update_score)
#	$"Info HUD".train_head = train_head
	for item in items_cotainer.get_children():
		item.get_child(0).mouse_entered.connect(display_tool_tip)
		item.get_child(0).mouse_exited.connect(hide_tool_tip)
		item.get_child(0).update_ui.connect(update_ui)
		item.train_head = train_head
		item.setup()
	pass # Replace with function body.

func display_tool_tip():
	$"purchest window"/tool_tip_box.visible = true
	print("Is visable")
	pass
	
func hide_tool_tip():
	$"purchest window"/tool_tip_box.visible = false	
	print("Now invisable")
	pass

func _on_button_pressed():
	$"purchest window".visible = !$"purchest window".visible
	pass # Replace with function body.

func update_button_info():
	for button in $"purchest window"/HBoxContainer.get_children():
		button.emit_signal("update_ui",button)

func update_ui(button):
	$"purchest window"/tool_tip_box/MarginContainer/Label.text = button.description

	pass

func update_money():
	$"Info HUD/score and money/VBoxContainer/MarginContainer/Money".text = "Money: "+str(GlobalData.money)
	pass
func update_score():
	$"Info HUD/score and money/VBoxContainer/MarginContainer/Score".text = "Score: "+str(GlobalData.score)
	pass
