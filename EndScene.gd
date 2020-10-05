extends Node2D

onready var player = get_node("Player")
onready var sp = get_node("SidePanel")
onready var bp = get_node("BottomPanel")


# Called when the node enters the scene tree for the first time.
func _ready():
	unlock_player_actions()
	bp.log_clear()
	player.facing_direction = player.FACING_DOWN
	player.play_idle_animation()
	set_new_player_actions(Actions.TURN_RIGHT, Actions.TURN_RIGHT, Actions.TURN_RIGHT, Actions.TURN_RIGHT)
	player.camera.set_zoom(0.8)
	player.camera.set_smooth_zoom(0.6)


func set_new_player_actions(A1, A2, A3, A4):
	player.action_buffer = [A1, A2, A3, A4]
	sp.set_action_texts(player.action_buffer)

func unlock_player_actions():
	player.can_act = true
	sp.hide_locks()
	sp.set_action_index_and_clear_rest(0)


func _on_EndTimer_timeout():
	player.camera.set_smooth_zoom(0.1)
	for i in range(40):
		$Map/Darkness.color.a += 0.05
		yield(get_tree().create_timer(0.1), "timeout")
	queue_free()


func _on_TVTimer_timeout():
	$BottomPanel.log_write("TV ANNOUNCER: A horrific explosion happened at Roboware Industries this morning. The police are investigating the event.")
