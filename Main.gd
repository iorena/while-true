extends Node2D
enum {FORWARD, TURN_LEFT, TURN_RIGHT, WAIT, WELD}
const FORWARD_ACTION_TEXT = "Move forward"
const TURN_LEFT_ACTION_TEXT = "Turn left"
const TURN_RIGHT_ACTION_TEXT = "Turn right"
const WAIT_ACTION_TEXT = "Wait"
const WELD_ACTION_TEXT = "Weld"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready(): 
	$Player.toggle_act()
	$Player.action_buffer = [WELD, WAIT, TURN_RIGHT, TURN_RIGHT]
	set_action_texts($Player.action_buffer)
	

func set_action_texts(action_buffer):
	for i in range(1, 5): $Player.clear_action_index(i)
	for i in range(1, 5):
		$Player.set_action_text(i, get_action_text(action_buffer[i - 1]))

func get_action_text(action_name):
	if action_name == FORWARD:
		return FORWARD_ACTION_TEXT
	elif action_name == TURN_LEFT:
		return TURN_LEFT_ACTION_TEXT
	elif action_name == TURN_RIGHT:
		return TURN_RIGHT_ACTION_TEXT
	elif action_name == WAIT:
		return WAIT_ACTION_TEXT
	elif action_name == WELD:
		return WELD_ACTION_TEXT

func _on_TVTimer_timeout():
	$BottomPanel/ScrollContainer/VBoxContainer/LogText.text += "News anchor on TV: Not much to report today. The city is free of terrorism! \n"
	#$BottomPanel/ScrollContainer.scroll_vertical = $BottomPanel/ScrollContainer.get_v_scrollbar().max_value - 1
	$TVTimer.wait_time = randi() % 10 + 15
	$TVTimer.start()
	

func _on_PlotTimer_timeout():
	$BottomPanel/ScrollContainer/VBoxContainer/LogText.text += "Factory announcer: Robot 312, move to room 7 to continue your duties.\n"
	$Player.action_buffer = [TURN_RIGHT, FORWARD, FORWARD, TURN_LEFT]
	set_action_texts($Player.action_buffer)
	
func _on_PlotTimer2_timeout():
	$Player.action_buffer = [FORWARD, FORWARD, FORWARD, FORWARD]
	set_action_texts($Player.action_buffer)


func _on_PlotTimer3_timeout():
	$Player.action_buffer = []
	set_action_texts([])
	# dialogue with terrorist
