extends Node2D

onready var player = get_node("Player")
onready var sp = get_node("SidePanel")
onready var bp = get_node("BottomPanel")

# Called when the node enters the scene tree for the first time.
func _ready():
	player.position = $Map/Floor.map_to_world(Vector2(-9, -6))
	player.position.y += $Player.tile_size / 2
	player.dead = false
	player.mission_complete = false
	player.holding_box = true
	player.colliding = 0
	player.facing_direction = player.FACING_RIGHT
	player.play_idle_animation()
	unlock_player_actions()
	set_new_player_actions(Actions.FORWARD, Actions.FORWARD, Actions.FORWARD, Actions.FORWARD)
	player.camera.set_zoom(0.6)
	bp.log_clear()

func complete_mission():
	print("you have completed the mission!")
	#get_root().change_scene("res://???")

func restart_scene():
	for i in range(10):
		$Map/Darkness.color.a += 0.1
		yield(get_tree().create_timer(0.1), "timeout")
	get_tree().reload_current_scene()

func set_new_player_actions(A1, A2, A3, A4):
	player.action_buffer = [A1, A2, A3, A4]
	sp.set_action_texts(player.action_buffer)

func unlock_player_actions():
	player.can_act = true
	sp.hide_locks()
	sp.set_action_index_and_clear_rest(0)
