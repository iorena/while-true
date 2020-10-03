extends KinematicBody2D

var speed = 128
var tile_size = 32

var last_position = Vector2()
var target_position = Vector2()
var movedir = Vector2()

const MOVING_RIGHT = 0
const MOVING_DOWN = 1
const MOVING_LEFT = 2
const MOVING_UP = 3

var moving_to = MOVING_RIGHT # right, down, left, up

func cartesian_to_isometric(vector):
	return Vector2(vector.x - vector.y, (vector.x + vector.y) / 2)

# Might be useful?
func isometric_to_cartesian(vector):
	var x = (vector.x + 2 * vector.y) / 2
	return Vector2(x, x - vector.x)

func isometric_distance(pos1, pos2):
	var val = 2 * (pos2.y - pos1.y)
	return sqrt(val * val + pos2.x - pos1.x)

# Called when the node enters the scene tree for the first time.
func _ready():
	position = position.snapped(cartesian_to_isometric(Vector2.ONE * tile_size))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Movement
	position += speed * movedir * delta
	
	if isometric_distance(position, last_position) >= tile_size - speed * delta:
		position = target_position
		animate_movement(false)
	
	# Idle
	if position == target_position:
		get_movedir()
		if movedir != Vector2.ZERO: animate_movement(true)
		last_position = position
		target_position += movedir * tile_size

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

func get_movedir():
	var LEFT = Input.is_action_pressed("ui_left")
	var RIGHT = Input.is_action_pressed("ui_right")
	var UP = Input.is_action_pressed("ui_up")
	var DOWN = Input.is_action_pressed("ui_down")
	
	movedir.x = -int(LEFT) + int(RIGHT)
	movedir.y = -int(UP) + int(DOWN)
	
	if movedir.x != 0 && movedir.y != 0:
		movedir = Vector2.ZERO
	else:
		# Store move direction for animation.
		if LEFT: moving_to = MOVING_LEFT
		elif RIGHT: moving_to = MOVING_RIGHT
		elif UP: moving_to = MOVING_UP
		else: moving_to = MOVING_DOWN
	
	movedir = cartesian_to_isometric(movedir)
