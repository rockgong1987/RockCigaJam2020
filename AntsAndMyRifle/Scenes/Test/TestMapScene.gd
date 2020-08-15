extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var m_map_scene = $MapScene

# Called when the node enters the scene tree for the first time.
func _ready():
	m_map_scene.setup(self)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func on_back_pressed():
	print("back pressed")
func on_battle_confirmed(battle_id):
	print("battle confirmed : ", battle_id)
func get_battle_count():
	return 9
func get_battle_info(battle_id):
	return ["Level " + str(battle_id), "This is Level " + str(battle_id)]
