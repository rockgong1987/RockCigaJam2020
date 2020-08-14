extends Node2D

var m_context = null
# get_bg_ps()
# get_player_ps()
# get_ant_ps()
# get_ant_home_ps()
# get_box_ps()
# get_drone_ps()
# get_attr_hp() 
# add_attr_hp()
# get_attr_atk()
# add_attr_atk()
# get_attr_spd()
# add_attr_spd()
# get_attr_skl()
# add_attr_skl()
# get_gun_thr()
# add_gun_thr()
# get_gun_dbl()
# add_gun_dbl()
# get_gun_tpl()
# add_gun_tpl()
# get_boom_atk()
# add_boom_atk()
# get_boom_rng()
# add_boom_atk()
# get_boom_count()
# receive_boom()
# get_exp()
# get_level()
# get_exp_need_to_upgrade()
# get_gold()
# get_part()
# get_gacha_price()
# gacha()
# can_get_box()
# get_box_home_level()
# get_ant_home_level()
# get_box_home_upgrade_price()
# get_ant_home_upgrade_price()
# -- forward
# get_box_capacity()
# get_ant_capacity()
# get_ant_count()
# get_box_count()
# set_ant_count()
# set_ant_count()

onready var m_home_core = $HomeCore
onready var m_player_position = $PlayerPos
onready var m_ant_home_position = $AntHomePos
onready var m_bg_container = $BGContainer

onready var m_player_exp_label = $HUD/PlayerExp
onready var m_player_gold_label = $HUD/PlayerGold
onready var m_player_part_label = $HUD/PlayerPart

onready var m_update_panel = $UpgradePanel

var m_timer = 0.0
var m_step = 1.0 / 60.0

var m_player_inst = null
var m_box_insts = []
var m_ant_insts = []

func setup(context):
	m_context = context
	if context == null:
		return
	m_home_core.setup(self)
	var ps = m_context.get_bg_ps()
	var inst = null
	if ps != null:
		inst = ps.instance()
		m_bg_container.add_child(inst)
		inst.position = Vector2.ZERO
	ps = m_context.get_player_ps()
	m_player_inst = null
	if ps != null:
		m_player_inst = ps.instance()
		m_player_position.add_child(m_player_inst)
		m_player_inst.position = Vector2.ZERO
	refresh_hud()
	pass

func refresh_hud():
	m_player_exp_label.text = str(m_context.get_exp()) + " / " + str(m_context.get_exp_need_to_upgrade()) + " LV." + str(m_context.get_level())
	m_player_gold_label.text = str(m_context.get_gold())
	m_player_part_label.text = str(m_context.get_part())
	pass

func _process(delta):
	if m_context == null:
		return;
	m_timer += delta
	while m_timer > m_step:
		m_home_core.step()
		m_timer -= m_step

func box_spawned(inst_id):
	pass
func box_die(inst_id):
	pass
func ant_spawned(inst_id):
	var ant_ps = m_context.get_ant_ps()
	if ant_ps != null:
		var inst = ant_ps.instance()
		m_ant_home_position.add_child(inst)
		inst.position = Vector2.ZERO
	pass
func ant_state_changed(inst_id, old_state, new_state, target_box_id):
	pass
func ant_die(inst_id):
	pass

func get_box_capacity():
	return m_context.get_box_capacity()
func get_ant_capacity():
	return m_context.get_ant_capacity()
func get_ant_count():
	return m_context.get_ant_count()
func get_box_count():
	return m_context.get_box_count()
func set_ant_count(val):
	m_context.set_ant_count(val)
func set_box_count(val):
	m_context.set_box_count(val)
func get_ant_born_ratio_increase(ant_cnt):
	return m_context.get_ant_born_ratio_increase(ant_cnt)


func _on_UpgradeSwitch_pressed():
	m_update_panel.visible = !m_update_panel.visible
	pass # Replace with function body.
