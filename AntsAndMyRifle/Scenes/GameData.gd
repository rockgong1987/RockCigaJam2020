extends Node

var hp_weight = 273
var hp_bias = 210
var atk_weight = 3
var atk_bias = 6
var spd_weight = 4
var spd_bias = 9
var skl_weight = 1
var skl_bias = 10

var level_add_hp = 20
var level_add_atk = 1
var level_add_spd = 1
var level_add_skl = 1

var gacha_price = 100
var exp_per_ant = 100

var test_data = [
	["hello", "world", 100],
	["bye", "cruel", 200]
]

var level_up_need_exp = [0, 100, 200]

var levels = [
	["Abandoned Workshop", "Level of Danger : 0. An abandoned workshop."],
	["City Hospital", "Level of Danger : 1. Nobody is there."],
	["People's Park", "Level of Danger : 2. Looking for someone ?"],
	["Gym", "Level of Danger : 3. An abandoned gym."],
	["Primary School", "Level of Danger : 4. No students any more."],
	["Office", "Level of Danger : 5. Get rid of it."],
	["Bank", "Level of Danger : 6. High risk, high reward."],
	["Police Office", "Level of Danger : 7. Get away from it quickly."],
	["???", "Unknown Object get out from the Data Center.This may be a disaster."]
]

var box_level_capacity = [
	0,
	5,
	10,
	15
]

var ant_level_capacity = [
	0,
	5,
	10,
	15
]
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
