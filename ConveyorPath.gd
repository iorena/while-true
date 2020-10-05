extends Path2D

onready var follow = []
var speed = 16
var weld_offset = 0
var despawn_offset = 0
var spawn = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)

func init(wo, s):
	weld_offset = wo
	despawn_offset = max(0, 512 - weld_offset)
	spawn = s

func _process(delta):
	for i in range(follow.size()):
		follow[i].set_offset(follow[i].get_offset() + speed * delta)
		var offset = follow[i].get_offset()
		if offset >= weld_offset: follow[i].get_node("Item").weld()
		var diff = offset - (weld_offset + 512 + despawn_offset)
		if diff >= 0:
			follow[i].set_offset(spawn + diff)
			follow[i].get_node("Item").unweld()

func stop_welding():
	for i in range(follow.size()): follow[i].get_node("Item").stop_welding()
