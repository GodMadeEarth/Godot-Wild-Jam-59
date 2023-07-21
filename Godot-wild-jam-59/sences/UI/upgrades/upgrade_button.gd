extends TextureButton
signal payment_made
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

func _on_update_ui(_button):
	price_text.text = "$"+str(get_current_price())
	item_text.text = item_name
	pass # Replace with function body.

func _on_pressed():
	var current_pricing:int = get_current_price()
	if GlobalData.money - current_pricing >= 0:
		get_parent().stat_sheet["Total Purchaces"]+= 1
		GlobalData.money = -current_pricing
		print(get_parent().stat_sheet["Base Cost"] )
		emit_signal("payment_made")
	_on_update_ui(self)
	pass # Replace with function body.

func get_current_price(): 
	return get_parent().stat_sheet["Base Cost"] +(get_parent().stat_sheet["Increment Cost By"] * get_parent().stat_sheet["Total Purchaces"])
	
