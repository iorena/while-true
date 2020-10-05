extends KinematicBody2D

onready var sp = get_parent().get_node("SidePanel")
onready var bp = get_parent().get_node("BottomPanel")
onready var camera = $Camera2D
onready var timer = $ActionTimer

# Player globals.
var speed = 32
var tile_size = 32
var can_act = false
var dead = false
var holding_box = false

# Action buffer.
var action_buffer = []
var action_number = 0
var modify_action_number = 0

# Store robot's current facing direction.
# Will be used to determine correct animations etc.
enum {FACING_RIGHT, FACING_DOWN, FACING_LEFT, FACING_UP}
var facing_direction = FACING_DOWN

const IDLE_ANIMATIONS = [["idle_right", "idle_right_box"], ["idle_down", "idle_down_box"], ["idle_left", "idle_left_box"], ["idle_up", "idle_up_box"]]
const MOVE_ANIMATIONS = [["move_right", "move_right_box"], ["move_down", "move_down_box"], ["move_left", "move_left_box"], ["move_up", "move_up_box"]]
const ELECTROCUTE_ANIMATIONS = [["die_right", "die_right_box"], ["die_down", "die_down_box"], ["die_left", "die_left_box"], ["die_up", "die_up_box"]]
const MOVEDIRS = [Isometric.RIGHT, Isometric.DOWN, Isometric.LEFT, Isometric.UP]

# Movement-related variables.
var movedir = Vector2.ZERO
var last_position = Vector2()
var target_position = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	play_idle_animation()
	position = position.snapped(Isometric.cartesian_to_isometric(Vector2.ONE * tile_size))
	last_position = position
	target_position = position

# Set action number to next action.
func increment_action_number(): action_number = (action_number + 1) % 4

func _on_ActionTimer_timeout():
	sp.play_action_light(action_number)
	var action = action_buffer[action_number]
	increment_action_number()
	if action == Actions.FORWARD:
		move_forward()
		if not dead:
			play_movement_animation()
		else:
			play_electrocute_animation()
			yield(get_tree().create_timer(1), "timeout")
			get_parent().restart_scene()
			
		return
	elif action == Actions.TURN_LEFT:
		yield(get_tree().create_timer(0.5), "timeout")
		turn_left()
	elif action == Actions.TURN_RIGHT:
		yield(get_tree().create_timer(0.5), "timeout")
		turn_right()
	elif action == Actions.WELD:
		play_weld_animation()
		return
	play_idle_animation()

func get_action_index_from_input():
	if !can_act: return
	if Input.is_key_pressed(KEY_1): 
		modify_action_number = 0
		sp.set_action_index_and_clear_rest(0)
	elif Input.is_key_pressed(KEY_2): 
		modify_action_number = 1
		sp.set_action_index_and_clear_rest(1)
	elif Input.is_key_pressed(KEY_3): 
		modify_action_number = 2
		sp.set_action_index_and_clear_rest(2)
	elif Input.is_key_pressed(KEY_4): 
		modify_action_number = 3
		sp.set_action_index_and_clear_rest(3)

func get_action_type_from_input():
	if !can_act: return
	if Input.is_action_pressed("ui_up"): 
		action_buffer[modify_action_number] = Actions.FORWARD
		sp.set_action_text(modify_action_number, Actions.FORWARD_ACTION_TEXT)
	elif Input.is_action_pressed("ui_left"): 
		action_buffer[modify_action_number] = Actions.TURN_LEFT
		sp.set_action_text(modify_action_number, Actions.TURN_LEFT_ACTION_TEXT)
	elif Input.is_action_pressed("ui_right"): 
		action_buffer[modify_action_number] = Actions.TURN_RIGHT
		sp.set_action_text(modify_action_number, Actions.TURN_RIGHT_ACTION_TEXT)

# Set movedir and position info for _process(delta).
func move_forward():
	movedir = MOVEDIRS[facing_direction]
	last_position = position
	target_position += movedir * tile_size
	var collision = get_parent().get_node("Map/Collision")
	var cell_position = objects.world_to_map(target_position)
	var cell = objects.get_cell(cell_position[0] - 1, cell_position[1] - 1)
	if cell != -1:
		target_position = last_position
	if cell == 1:
		dead = true

func turn_left(): facing_direction = (facing_direction + 3) % 4
func turn_right(): facing_direction = (facing_direction + 1) % 4

# Make sure panels follow player.
func place_panels():
	bp.position = position
	sp.position = position
	bp.scale = camera.zoom
	sp.scale = camera.zoom

# Move player towards movedir.
func process_movement(delta):
	position += speed * movedir * delta
	# Snap to grid.
	if Isometric.isometric_distance(position, last_position) >= tile_size - speed * delta:
		position = target_position
		movedir = Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if camera.zooming_in_process(): camera.process_zoom(delta)
	get_action_index_from_input()
	get_action_type_from_input()
	if movedir != Vector2.ZERO: process_movement(delta)
	place_panels()

func play_weld_animation():
	if facing_direction == FACING_DOWN: $AnimatedSprite.play("weld_down")
	elif facing_direction == FACING_UP: $AnimatedSprite.play("weld_up")
func play_idle_animation(): $AnimatedSprite.play(IDLE_ANIMATIONS[facing_direction][int(holding_box)])
func play_movement_animation(): $AnimatedSprite.play(MOVE_ANIMATIONS[facing_direction][int(holding_box)])
func play_electrocute_animation(): $AnimatedSprite.play(ELECTROCUTE_ANIMATIONS[facing_direction][int(holding_box)])
