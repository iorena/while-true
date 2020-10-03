extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready(): 
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TVTimer_timeout():
	$BottomPanel/ScrollContainer/VBoxContainer/LogText.text += "News anchor on TV: Not much to report today. The city is free of terrorism! \n"
	print($BottomPanel/ScrollContainer.get_v_scrollbar().max_value)
	#$BottomPanel/ScrollContainer.scroll_vertical = $BottomPanel/ScrollContainer.get_v_scrollbar().max_value - 1
	$TVTimer.wait_time = randi() % 10 + 5
	$TVTimer.start()
	
