extends Node

export(PackedScene) var home_scene_ps = null
export(PackedScene) var map_scene_ps = null
export(PackedScene) var battle_scene_ps = null
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var m_title_panel = $Title
onready var m_game_data = $GameData
onready var m_player_data = $PlayerData

onready var m_home_container = $HomeContainer
onready var m_map_container = $MapContainer
onready var m_battle_container = $BattleContainer

onready var m_setting_entry_button = $Setting/Entry
onready var m_setting_entry_panel = $Setting/Panel
onready var m_back_to_title_dialog = $BackToTitleDialog
onready var m_quit_dialog = $QuitDialog

var m_home_scene_inst
var m_map_scene_inst
var m_battle_scene_inst

# for battle
var m_battle_id = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Exit_pressed():
	m_quit_dialog.popup_centered()
	pass # Replace with function body.

func _on_Enter_pressed():
	m_home_scene_inst = home_scene_ps.instance()
	m_home_container.add_child(m_home_scene_inst)
	m_home_scene_inst.setup(self)
	m_title_panel.visible = false
	m_setting_entry_button.visible = true
	pass # Replace with function body.

# -- home intefaces
func get_home_bg_ps():
	return load("res://Scenes/Home/Background/BG_0.tscn")
	pass
func get_home_player_ps():
	return load("res://Scenes/Home/HomePlayer.tscn")
	pass
func get_ant_ps():
	return load("res://Scenes/Home/HomeAnt.tscn")
	pass
func get_ant_home_ps():
	return load("res://Scenes/Home/HomeAntHome.tscn")
	pass
func get_box_ps():
	return load("res://Scenes/Home/HomeBox.tscn")
	pass
func get_drone_ps():
	return load("res://Scenes/Home/HomeDrone.tscn")
	pass
func get_attr_hp():
	return m_game_data.hp_weight * m_player_data.hp_level + m_game_data.hp_bias + m_game_data.level_add_hp * m_player_data.player_level
func add_attr_hp():
	m_player_data.hp_level += 1
func get_attr_atk():
	return m_game_data.atk_weight * m_player_data.atk_level + m_game_data.atk_bias + m_game_data.level_add_atk * m_player_data.player_level
func add_attr_atk():
	m_player_data.atk_level += 1
func get_attr_spd():
	return m_game_data.spd_weight * m_player_data.spd_level + m_game_data.spd_bias + m_game_data.level_add_spd * m_player_data.player_level
func add_attr_spd():
	m_player_data.spd_level += 1
func get_attr_skl():
	return m_game_data.skl_weight * m_player_data.skl_level + m_game_data.skl_bias + m_game_data.level_add_skl * m_player_data.player_level
func add_attr_skl():
	m_player_data.skl_level += 1
func get_gun_thr():
	return m_player_data.gun_thr
func add_gun_thr():
	m_player_data.gun_thr += 1
func get_gun_dbl():
	return m_player_data.gun_dbl
func add_gun_dbl():
	m_player_data.gun_dbl += 1
func get_gun_tpl():
	return m_player_data.gun_tpl
func add_gun_tpl():
	m_player_data.gun_tpl += 1
func get_boom_atk():
	return m_player_data.boom_atk
func add_boom_atk():
	m_player_data.boom_atk += 1
func get_boom_rng():
	return m_player_data.boom_rng
func add_boom_rng():
	m_player_data.boom_rng += 1
func get_boom_count():
	return m_player_data.boom_count
func receive_boom():
	m_player_data.boom_count += 1
func get_exp():
	return m_player_data.player_exp
func get_level():
	return m_player_data.player_level
func get_exp_need_to_upgrade():
	if m_player_data.player_level < 0 or m_player_data.player_level < len(m_game_data.level_up_need_exp):
		return 0
	return m_game_data.level_up_need_exp[m_player_data.player_level]
func get_gold():
	return m_player_data.gold
func get_part():
	return m_player_data.part
func get_gacha_price():
	return m_game_data.gacha_price
func gacha():
	if m_game_data.gacha_price > m_player_data.gold:
		return false
	m_player_data.gold -= m_game_data.gacha_price
	m_home_scene_inst.spawn_box_inst(true)
	return true
func can_get_box():
	var box_level = m_player_data.box_level
	var box_count = m_player_data.box_count
	var box_capacity = m_game_data.box_level_capacity[box_level]
	return box_count < box_capacity
func get_empty_box():
	m_home_scene_inst.spawn_box_inst(false)
	return true
func get_box_home_level():
	return m_player_data.box_level
func get_ant_home_level():
	return m_player_data.and_level
func get_box_home_upgrade_price():
	return m_game_data.box_upgrade_price(m_player_data.box_level)
func get_ant_home_upgrade_price():
	return m_game_data.ant_upgrade_price(m_player_data.ant_level)
func home_battle_pressed():
	if m_map_scene_inst != null:
		m_map_scene_inst.queue_free()
	m_map_scene_inst = map_scene_ps.instance()
	m_map_container.add_child(m_map_scene_inst)
	m_map_scene_inst.position = Vector2.ZERO
	m_map_scene_inst.setup(self)
# -- forward
func get_box_capacity():
	return m_game_data.box_level_capacity[m_player_data.box_level]
func get_ant_capacity():
	return m_game_data.ant_level_capacity[m_player_data.ant_level]
func get_ant_count():
	return m_player_data.ant_count
func get_box_count():
	return m_player_data.box_count
func set_ant_count(val):
	m_player_data.ant_count = val
func set_box_count(val):
	m_player_data.box_count = val
func get_ant_born_ratio_increase(ant_cnt):
	return 0.7

# == map

func on_back_pressed():
	if m_map_scene_inst != null:
		m_map_scene_inst.queue_free()
		m_map_scene_inst = null
func on_battle_confirmed(battle_id):
	m_battle_id = battle_id
	if m_home_scene_inst != null:
		m_home_scene_inst.queue_free()
		m_home_scene_inst = null
	if m_map_scene_inst != null:
		m_map_scene_inst.queue_free()
		m_map_scene_inst = null
	if m_battle_scene_inst != null:
		m_battle_scene_inst.queue_free()
	m_battle_scene_inst = battle_scene_ps.instance()
	m_battle_container.add_child(m_battle_scene_inst)
	m_battle_scene_inst.position = Vector2.ZERO
	m_battle_scene_inst.setup(self)
	pass
func get_battle_count():
	return len(m_game_data.levels)
func get_battle_info(battle_id):
	return [m_game_data.levels[battle_id][0], m_game_data.levels[battle_id][1]]

# == battle

func get_bg_ps():
	return load("res://Scenes/Home/Background/BG_0.tscn")
func get_player_ps():
	return load("res://Scenes/Home/HomePlayer.tscn")
func get_enemy_ps(type_id):
	return load("res://Scenes/Battle/Enemies/Enemy_0.tscn")
func get_player_bullet_ps():
	return load("res://Scenes/Battle/Bullets/PB_0.tscn")
func get_enemy_bullet_ps():
	return load("res://Scenes/Battle/Bullets/EB_0.tscn")
func battle_result(win):
	if m_battle_scene_inst != null:
		m_battle_scene_inst.queue_free()
		m_battle_scene_inst = null
	if m_home_scene_inst != null:
		m_home_scene_inst.queue_free()
	m_home_scene_inst = home_scene_ps.instance()
	m_home_container.add_child(m_home_scene_inst)
	m_home_scene_inst.position = Vector2.ZERO
	m_home_scene_inst.setup(self)
# ----forward
func get_player_max_hp():
	return get_attr_hp()
func get_player_max_cd():
	return 100 # TODO
func get_player_atk():
	return get_attr_atk()
func get_player_crit_prob():
	return 0.0
func get_player_double_prob():
	return 0.0
func get_player_triple_prob():
	return 0.0
func get_player_boom_count():
	return m_player_data.boom_count
func get_player_boom_radius():
	return 100 # TODO
func get_player_boom_damage():
	return 100 # TODO
func get_enemy_atk(type_id):
	return 100 # TODO
func get_enemy_max_hp(type_id):
	return 100 # TODO
func get_enemy_radius(type_id):
	return 500
func get_enemy_attack_range(type_id):
	return 1000 * type_id + 2
func get_enemy_attack_bullet_speed(type_id):
	return 100 * type_id + 2
func get_enemy_attack_cd(type_id):
	return 500
func get_enemy_attack_pre(type_id):
	return 100
func get_enemy_move_speed(type_id):
	return 100
func get_main_spawn_enemy(step_cnt):
	if step_cnt > 1000:
		return null
	if step_cnt % 200:
		return 0
	return null
func player_use_boom():
	if m_player_data.boom_count > 0:
		m_player_data.boom_count -= 1


func _on_Entry_pressed():
	m_setting_entry_panel.visible = true
	pass # Replace with function body.


func _on_ResumeButton_pressed():
	m_setting_entry_panel.visible = false
	pass # Replace with function body.


func _on_TitleButton_pressed():
	m_back_to_title_dialog.popup_centered()
	pass # Replace with function body.


func _on_BackToTitleDialog_confirmed():
	if m_home_scene_inst != null:
		m_home_scene_inst.queue_free()
		m_home_scene_inst = null
	if m_map_scene_inst != null:
		m_map_scene_inst.queue_free()
		m_map_scene_inst = null
	if m_battle_scene_inst != null:
		m_battle_scene_inst.queue_free()
		m_battle_scene_inst = null
	m_setting_entry_button.visible = false
	m_title_panel.visible = true
	m_setting_entry_panel.visible = false
	pass # Replace with function body.


func _on_QuitDialog_confirmed():
	get_tree().quit()
	pass # Replace with function body.
