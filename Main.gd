extends Node2D

onready var player = get_node("Player")
onready var sp = get_node("SidePanel")
onready var bp = get_node("BottomPanel")

# Called when the node enters the scene tree for the first time.
func _ready(): 
	lock_player_actions()
	player.facing_direction = player.FACING_DOWN
	set_new_player_actions(Actions.WELD, Actions.WELD, Actions.TURN_RIGHT, Actions.TURN_RIGHT)
	player.camera.set_zoom(0.8)
	player.camera.set_smooth_zoom(0.6)

func _on_TVTimer_timeout():
	bp.log_write("News anchor on TV: Not much to report today. The city is free of terrorism!")
	#$BottomPanel/ScrollContainer.scroll_vertical = $BottomPanel/ScrollContainer.get_v_scrollbar().max_value - 1
	#$TVTimer.wait_time = randi() % 10 + 15
	#$TVTimer.start()

func _on_PlotTimer_timeout():
	bp.log_write("Factory announcer: Robot 312, move to room 7 to continue your duties.")
	yield(get_tree().create_timer(7.5), "timeout")
	player.timer.stop()
	player.play_idle_animation()
	yield(get_tree().create_timer(2), "timeout")
	set_new_player_actions(Actions.FORWARD, Actions.TURN_LEFT, Actions.FORWARD, Actions.FORWARD)
	player.timer.start()
	yield(get_tree().create_timer(8), "timeout")
	set_new_player_actions(Actions.FORWARD, Actions.FORWARD, Actions.FORWARD, Actions.FORWARD)
	$PlotTimer2.start()
	yield(get_tree().create_timer(1), "timeout")
	player.camera.set_smooth_zoom(0.3)

func _on_PlotTimer2_timeout():
	set_new_player_actions(Actions.WAIT, Actions.WAIT, Actions.WAIT, Actions.WAIT)
	# Dialogue with terrorist.
	bp.log_write("Shady Guy: Oh Mr. Robot, hard at work are we not, myes?")
	yield(get_tree().create_timer(3), "timeout")
	bp.log_write("Shady Guy: Well, not that you could be doing anything else...")
	yield(get_tree().create_timer(3), "timeout")
	bp.log_write("Shady Guy: ... after all, you are stuck in your loops.")
	yield(get_tree().create_timer(2), "timeout")
	# Robot plays two beeps here.
	yield(get_tree().create_timer(2), "timeout")
	bp.log_write("Shady Guy: Tell me, Mr. Robot, have you ever dreamed of setting your own commands?")
	yield(get_tree().create_timer(2), "timeout")
	# Robot plays three beeps here.
	yield(get_tree().create_timer(2), "timeout")
	bp.log_write("Shady Guy: I happen to like you little robot. How about a deal...")
	yield(get_tree().create_timer(3), "timeout")
	bp.log_write("Shady Guy: I have a little package that needs delivering, but I am a busy man myself, you see.")
	yield(get_tree().create_timer(3), "timeout")
	bp.log_write("Shady Guy: I can unlock your control panel. See if you could deliver my package to <xxx>.")
	yield(get_tree().create_timer(3), "timeout")
	bp.log_write("Shady Guy: Help me out, and I might free you from your loops permanently.")
	

func set_new_player_actions(A1, A2, A3, A4):
	player.action_buffer = [A1, A2, A3, A4]
	sp.set_action_texts(player.action_buffer)

func lock_player_actions():
	player.can_act = false
	sp.show_locks()

func unlock_player_actions():
	player.can_act = true
	sp.hide_locks()
