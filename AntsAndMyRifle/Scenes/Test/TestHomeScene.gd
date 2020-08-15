extends Node

export(PackedScene) var bg_ps
export(PackedScene) var p_ps
export(PackedScene) var b_ps
export(PackedScene) var a_ps
export(PackedScene) var ah_ps
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var m_home_scene = $HomeScene

var ant_cnt = 3
var box_cnt = 12
# Called when the node enters the scene tree for the first time.
func _ready():
	m_home_scene.setup(self)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func get_exp():
	return 150
func get_level():
	return 10
func get_exp_need_to_upgrade():
	return 2350
func get_gold():
	return 1001
func get_part():
	return 550

func get_home_bg_ps():
	return bg_ps
func get_home_player_ps():
	return p_ps
func get_ant_ps():
	return a_ps
func get_ant_home_ps():
	return ah_ps
func get_box_ps():
	return b_ps
func get_drone_ps():
	return p_ps

func get_box_capacity():
	return 10
func get_ant_capacity():
	return 5
func get_ant_count():
	return ant_cnt
func get_box_count():
	return box_cnt
func set_ant_count(val):
	ant_cnt = val
func set_box_count(val):
	box_cnt = val
func get_ant_born_ratio_increase(ant_cnt):
	return 0.2
