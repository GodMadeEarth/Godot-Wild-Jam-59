extends MarginContainer

var train_head:Train_Head
var stat_sheet:Dictionary

func setup():
	stat_sheet = train_head.dashCooldownStats
	$upgrade_button.emit_signal("update_ui",$upgrade_button)
	pass # Replace with function body.
