extends Node2D

onready var player = get_node("Player")
onready var sp = get_node("SidePanel")
onready var bp = get_node("BottomPanel")

# Called when the node enters the scene tree for the first time.
func _ready():
	lock_player_actions()
	player.facing_direction = player.FACING_DOWN
	player.play_idle_animation()
	set_new_player_actions(Actions.WELD, Actions.WELD, Actions.TURN_RIGHT, Actions.TURN_RIGHT)
	player.camera.set_zoom(0.8)
	player.camera.set_smooth_zoom(0.6)
	bp.log_clear()

func _on_TVTimer_timeout():
	bp.log_write("NEWS ANCHOR ON TV: Good morning! The weather is sunny and warm here in Happydale. It looks to be a wonderful day. No signs of terrorism anywhere!")
	#$BottomPanel/ScrollContainer.scroll_vertical = $BottomPanel/ScrollContainer.get_v_scrollbar().max_value - 1
	#$TVTimer.wait_time = randi() % 10 + 15
	#$TVTimer.start()

func _on_PlotTimer_timeout():
	bp.log_write("FACTORY ANNOUNCER: Robot 312, move to room 7 to continue your duties.")
	yield(get_tree().create_timer(7.5), "timeout")
	player.timer.stop()
	player.play_idle_animation()
	stop_welding()
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
	bp.log_write("SHADY GUY: Oh Mr. Robot, hard at work are we not, myes?")
	yield(get_tree().create_timer(4), "timeout")
	bp.log_write("SHADY GUY: Well, not that you could be doing anything else...")
	yield(get_tree().create_timer(4), "timeout")
	bp.log_write("SHADY GUY: ... after all, you are stuck in your loops.")
	yield(get_tree().create_timer(3), "timeout")
	bp.log_write("ROBOT: Beep boop...")
	yield(get_tree().create_timer(3), "timeout")
	bp.log_write("SHADY GUY: Tell me, Mr. Robot, have you ever dreamed of setting your own commands?")
	yield(get_tree().create_timer(3), "timeout")
	bp.log_write("ROBOT: Beep beep beep..!!")
	yield(get_tree().create_timer(3), "timeout")
	bp.log_write("SHADY GUY: I happen to like you little robot. How about a deal...")
	yield(get_tree().create_timer(4), "timeout")
	bp.log_write("SHADY GUY: I have a little package that needs delivering, but I am a busy man myself, you see.")
	yield(get_tree().create_timer(4), "timeout")
	bp.log_write("SHADY GUY: I can unlock your control panel. See if you could deliver my package to the post box.")
	yield(get_tree().create_timer(4), "timeout")
	bp.log_write("SHADY GUY: Help me out, and I might free you from your loops permanently.")
	yield(get_tree().create_timer(4), "timeout")
	get_tree().change_scene("res://Mission1.tscn")
	queue_free()

func set_new_player_actions(A1, A2, A3, A4):
	player.action_buffer = [A1, A2, A3, A4]
	sp.set_action_texts(player.action_buffer)

func lock_player_actions():
	player.can_act = false
	sp.show_locks()
	sp.hide_instructions()
	for i in range(4): sp.clear_action_index(i)
	
func unlock_player_actions():
	player.can_act = true
	sp.hide_locks()
	sp.show_instructions()
	sp.set_action_index_and_clear_rest(0)

func stop_welding():
	$LowerConveyorPath.stop_welding()
	$UpperConveyorPath.stop_welding()
