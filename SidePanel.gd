extends Node2D

onready var SP_Actions = [$Action1, $Action2, $Action3, $Action4]
onready var SP_Selected = [$Selected1, $Selected2, $Selected3, $Selected4]
onready var SP_locks = [$Lock1, $Lock2, $Lock3, $Lock4]
onready var SP_lights = [$Light1, $Light2, $Light3, $Light4]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_action_texts(action_buffer):
	for i in range(4): set_action_text(i, Actions.Texts[action_buffer[i]])

func set_action_text(idx, text):
	SP_Actions[idx].text = text

func set_action_index_and_clear_rest(idx): 
	SP_Selected[idx].visible_characters = -1
	for i in range(idx) + range(idx + 1, 4): clear_action_index(i)

func clear_action_index(idx): 
	SP_Selected[idx].visible_characters = 0

func show_locks():
	for i in range(4): SP_locks[i].visible = true

func hide_locks():
	for i in range(4): SP_locks[i].visible = false

func show_instructions(): 
	$Instructions.visible = true
	$InstructionsDetailed.visible = true
func hide_instructions(): 
	$Instructions.visible = false
	$InstructionsDetailed.visible = false

func play_action_light(idx):
	play_blink_animation(idx)
	for i in range(idx) + range(idx + 1, 4): play_idle_animation(i)

func play_blink_animation(idx): SP_lights[idx].play("blink")
func play_idle_animation(idx): SP_lights[idx].play("idle")
