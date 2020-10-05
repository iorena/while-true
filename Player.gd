extends KinematicBody2D

# Player globals
var speed = 32
var tile_size = 32

# Available actions
enum {FORWARD, TURN_LEFT, TURN_RIGHT, WAIT, WELD}
const FORWARD_ACTION_TEXT = "Move forward"
const TURN_LEFT_ACTION_TEXT = "Turn left"
const TURN_RIGHT_ACTION_TEXT = "Turn right"
const WAIT_ACTION_TEXT = "Wait"
const WELD_ACTION_TEXT = "Weld"

var can_act = true

# Action buffer
var action_buffer = []
var action_number = 0
var modify_action = 0

# Movement-related variables
enum {MOVING_RIGHT, MOVING_DOWN, MOVING_LEFT, MOVING_UP}
var moving_to = MOVING_DOWN # right, down, left, up
var movedir = Vector2.ZERO
var last_position = Vector2()
var target_position = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Camera2D.zoom.x = 0.6
	$Camera2D.zoom.y = 0.6
	position = position.snapped(Isometric.cartesian_to_isometric(Vector2.ONE * tile_size))
	last_position = position
	target_position = position
	


func toggle_act():
	for i in range(1, 5):
		get_parent().get_node("SidePanel/Lock" + String(i)).visible = can_act
	can_act = !can_act

func action_light():
	get_parent().get_node("SidePanel/Light" + String(action_number + 1)).play("blink")
	for i in range(action_number) + range(action_number + 1, 4): 
		get_parent().get_node("SidePanel/Light" + String(i + 1)).play("idle")

func _on_ActionTimer_timeout():
	action_light()
	var action = action_buffer[action_number]
	if action == FORWARD:
		move_forward()
	elif action == TURN_LEFT:
		yield(get_tree().create_timer(0.5), "timeout")
		turn_left()
		animate_movement(false)
	elif action == TURN_RIGHT:
		yield(get_tree().create_timer(0.5), "timeout")
		turn_right()
		animate_movement(false)
	elif action == WELD:
		weld()
	elif action == WAIT:
		animate_movement(false)
	action_number += 1
	if action_number == action_buffer.size(): action_number = 0

func set_action_text(idx, text):
	get_parent().get_node("SidePanel/Action" + String(idx)).text = text

func modify_action_text(text): set_action_text(modify_action + 1, text)

func set_action_index_and_clear_rest(idx): 
	get_parent().get_node("SidePanel/Selected" + String(idx)).visible_characters = -1
	for i in range(1, idx) + range(idx + 1, 5): clear_action_index(i)

func clear_action_index(idx): 
	get_parent().get_node("SidePanel/Selected" + String(idx)).visible_characters = 0

func modify_action_index():
	if can_act:
		if Input.is_key_pressed(KEY_1): 
			modify_action = 0
			set_action_index_and_clear_rest(1)
		elif Input.is_key_pressed(KEY_2): 
			modify_action = 1
			set_action_index_and_clear_rest(2)
		elif Input.is_key_pressed(KEY_3): 
			modify_action = 2
			set_action_index_and_clear_rest(3)
		elif Input.is_key_pressed(KEY_4): 
			modify_action = 3
			set_action_index_and_clear_rest(4)

func modify_action():
	if can_act:
		if Input.is_action_pressed("ui_up"): 
			action_buffer[modify_action] = FORWARD
			modify_action_text(FORWARD_ACTION_TEXT)
		elif Input.is_action_pressed("ui_left"): 
			action_buffer[modify_action] = TURN_LEFT
			modify_action_text(TURN_LEFT_ACTION_TEXT)
		elif Input.is_action_pressed("ui_right"): 
			action_buffer[modify_action] = TURN_RIGHT
			modify_action_text(TURN_RIGHT_ACTION_TEXT)

func move_forward():
	if moving_to == MOVING_RIGHT: movedir = Isometric.RIGHT
	elif moving_to == MOVING_DOWN: movedir = Isometric.DOWN
	elif moving_to == MOVING_LEFT: movedir = Isometric.LEFT
	else: movedir = Isometric.UP
	animate_movement(true)
	last_position = position
	target_position += movedir * tile_size

func turn_left():
	if moving_to == MOVING_RIGHT: moving_to = MOVING_UP
	elif moving_to == MOVING_DOWN: moving_to = MOVING_RIGHT
	elif moving_to == MOVING_LEFT: moving_to = MOVING_DOWN
	else: moving_to = MOVING_LEFT

func turn_right():
	if moving_to == MOVING_RIGHT: moving_to = MOVING_DOWN
	elif moving_to == MOVING_DOWN: moving_to = MOVING_LEFT
	elif moving_to == MOVING_LEFT: moving_to = MOVING_UP
	else: moving_to = MOVING_RIGHT
	
func weld():
	if moving_to == MOVING_DOWN:
		$AnimatedSprite.play("weld_down")
	elif moving_to == MOVING_UP:
		$AnimatedSprite.play("weld_up")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	modify_action_index()
	modify_action()
	
	# Movement, if movedir is set.
	if movedir != Vector2.ZERO:
		position += speed * movedir * delta
		if Isometric.isometric_distance(position, last_position) >= tile_size - speed * delta:
			position = target_position
			movedir = Vector2.ZERO

func animate_movement(moving):
	# Play movement animation based on move direction
	if moving:
		if moving_to == MOVING_RIGHT:
			$AnimatedSprite.play("move_right")
		elif moving_to == MOVING_DOWN:
			$AnimatedSprite.play("move_down")
		elif moving_to == MOVING_LEFT:
			$AnimatedSprite.play("move_left")
		else:
			$AnimatedSprite.play("move_up")
	# Play idle animation based on last direction moved to
	else: 
		if moving_to == MOVING_RIGHT:
			$AnimatedSprite.play("idle_right")
		elif moving_to == MOVING_DOWN:
			$AnimatedSprite.play("idle_down")
		elif moving_to == MOVING_LEFT:
			$AnimatedSprite.play("idle_left")
		else:
			$AnimatedSprite.play("idle_up")
