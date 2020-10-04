extends KinematicBody2D

# Player globals
var speed = 32
var tile_size = 32

# Available actions
enum {FORWARD, TURN_LEFT, TURN_RIGHT}

# Action buffer
var action_buffer = [FORWARD, FORWARD, FORWARD, FORWARD]
var action_number = 0
var modify_action = 0

# Movement-related variables
enum {MOVING_RIGHT, MOVING_DOWN, MOVING_LEFT, MOVING_UP}
var moving_to = MOVING_RIGHT # right, down, left, up
var movedir = Vector2.ZERO
var last_position = Vector2()
var target_position = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	position = position.snapped(Isometric.cartesian_to_isometric(Vector2.ONE * tile_size))
	last_position = position
	target_position = position

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
		turn_left()
	elif action == TURN_RIGHT:
		turn_right()
	else:
		print("Unknown action.")
	action_number += 1
	if action_number == action_buffer.size(): action_number = 0

func modify_action_text(text):
	get_parent().get_node("SidePanel/Action" + String(modify_action + 1)).text = text

func set_action_index_and_clear_rest(idx): 
	get_parent().get_node("SidePanel/Selected" + String(idx)).visible_characters = -1
	for i in range(1, idx) + range(idx + 1, 5): clear_action_index(i)

func clear_action_index(idx): 
	get_parent().get_node("SidePanel/Selected" + String(idx)).visible_characters = 0

func modify_action_index():
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
	if Input.is_action_pressed("ui_up"): 
		action_buffer[modify_action] = FORWARD
		modify_action_text("Move forward")
	elif Input.is_action_pressed("ui_left"): 
		action_buffer[modify_action] = TURN_LEFT
		modify_action_text("Turn left")
	elif Input.is_action_pressed("ui_right"): 
		action_buffer[modify_action] = TURN_RIGHT
		modify_action_text("Turn right")

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
	else:
		animate_movement(false)

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
