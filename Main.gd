extends Node2D

onready var player = get_node("Player")
onready var sp = get_node("SidePanel")

# Called when the node enters the scene tree for the first time.
func _ready(): 
	lock_player_actions()
	set_new_player_actions(Actions.WELD, Actions.WAIT, Actions.TURN_RIGHT, Actions.TURN_RIGHT)

func _on_TVTimer_timeout():
	$BottomPanel/ScrollContainer/VBoxContainer/LogText.text += "News anchor on TV: Not much to report today. The city is free of terrorism! \n"
	#$BottomPanel/ScrollContainer.scroll_vertical = $BottomPanel/ScrollContainer.get_v_scrollbar().max_value - 1
	$TVTimer.wait_time = randi() % 10 + 15
	$TVTimer.start()
	

func _on_PlotTimer_timeout():
	$BottomPanel/ScrollContainer/VBoxContainer/LogText.text += "Factory announcer: Robot 312, move to room 7 to continue your duties.\n"
	set_new_player_actions(Actions.TURN_RIGHT, Actions.FORWARD, Actions.FORWARD, Actions.TURN_LEFT)
	
func _on_PlotTimer2_timeout():
	set_new_player_actions(Actions.FORWARD, Actions.FORWARD, Actions.FORWARD, Actions.FORWARD)


func _on_PlotTimer3_timeout():
	set_new_player_actions(Actions.WAIT, Actions.WAIT, Actions.WAIT, Actions.WAIT)
	# dialogue with terrorist

func set_new_player_actions(A1, A2, A3, A4):
	player.action_buffer = [A1, A2, A3, A4]
	sp.set_action_texts(player.action_buffer)

func lock_player_actions():
	player.can_act = false
	sp.show_locks()

func unlock_player_actions():
	player.can_act = true
	sp.hide_locks()
