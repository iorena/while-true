extends Node2D

onready var log_text = get_node("ScrollContainer/VBoxContainer/LogText")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func log_write(text):
	log_text.text += text
	log_newline()

func log_newline(): log_text.text += "\n"
