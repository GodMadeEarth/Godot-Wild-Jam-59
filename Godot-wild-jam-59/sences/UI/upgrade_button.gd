extends TextureButton

signal update_ui(button)
@export var item_name = "ITEM"
@export var description = "Place holder text is here because placer holder text looks nice"
@onready var price_text =  $upgrade_button/VBoxContainer/price
@onready var item_text = $upgrade_button/VBoxContainer/item_name


# Called when the node enters the scene tree for the first time.
func _ready():
	item_text.text = item_name
	pass # Replace with function body.

func _on_mouse_entered():
	emit_signal("update_ui",self)
	pass # Replace with function body.

func _on_update_ui(button):
	price_text.text = "$"+str(get_parent().stat_sheet["Base Cost"] +(get_parent().stat_sheet["Increment Cost By"] * get_parent().stat_sheet["Total Purchaces"]))
	item_text.text = item_name
	pass # Replace with function body.

func _on_pressed():
	get_parent().stat_sheet["Total Purchaces"]+= 1
	_on_update_ui(self)
	pass # Replace with function body.
