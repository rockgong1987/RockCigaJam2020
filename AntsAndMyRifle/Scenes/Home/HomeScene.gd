extends Node2D

var m_context = null
# get_home_bg_ps()
# get_home_player_ps()
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
# get_empty_box()
# can_get_box()
# get_box_home_level()
# get_ant_home_level()
# get_box_home_upgrade_price()
# get_ant_home_upgrade_price()
# home_battle_pressed()
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
onready var m_box_container = $BoxPos
onready var m_box_spawn_pos = $BoxSpawnPos

onready var m_player_exp_label = $HUD/PlayerExp
onready var m_player_gold_label = $HUD/PlayerGold
onready var m_player_part_label = $HUD/PlayerPart
onready var m_ant_born_ratio = $HUD/AntBornRatio
onready var m_gacha_cd_label = $HUD/GachaCD

onready var m_update_panel = $UpgradePanel

var m_timer = 0.0
var m_step = 1.0 / 60.0

var m_player_inst = null
var m_box_insts = []
var m_ant_insts = []

var m_waiting_box = null

func setup(context):
	m_context = context
	if context == null:
		return
	m_home_core.setup(self)
	var ps = m_context.get_home_bg_ps()
	var inst = null
	if ps != null:
		inst = ps.instance()
		m_bg_container.add_child(inst)
		inst.position = Vector2.ZERO
	ps = m_context.get_home_player_ps()
	m_player_inst = null
	if ps != null:
		m_player_inst = ps.instance()
		m_player_position.add_child(m_player_inst)
		m_player_inst.position = Vector2.ZERO
	ps = m_context.get_ant_home_ps()
	if ps != null:
		inst = ps.instance()
		m_ant_home_position.add_child(inst)
		inst.position = Vector2.ZERO
	refresh_hud()
	pass

func refresh_hud():
	m_player_exp_label.text = str(m_context.get_exp()) + " / " + str(m_context.get_exp_need_to_upgrade()) + " LV." + str(m_context.get_level())
	m_player_gold_label.text = str(m_context.get_gold())
	m_player_part_label.text = str(m_context.get_part())
	pass
	
func process_ants():
	var ant_states = m_home_core.get_ant_states()
	for a in m_ant_insts:
		var state = null
		for s in ant_states:
			if s[0] == a[0]:
				state = s
				break
		if state != null:
			if state[1] == 0:
				a[1].position = Vector2(a[0] * 10, -2 * a[0])
				a[2] = a[1].global_position
			elif state[1] == 1:
				var box_id = state[3]
				var b = null
				for bo in m_box_insts:
					if bo[0] == box_id:
						b = bo[1]
						break
				a[3] = b.global_position
				var t = state[2] * 1.0 / state[4]
				var y_offset = -sin(t * PI) * 100
				a[1].global_position = Vector2(t * a[2].x + (1 - t) * a[3].x, t * a[2].y + (1 - t) * a[3].y + y_offset)
			elif state[1] == 2:
				var box_id = state[3]
				var b = null
				for bo in m_box_insts:
					if bo[0] == box_id:
						b = bo[1]
						break
				a[1].global_position = b.global_position
			elif state[1] == 3:
				var t = state[2] * 1.0 / state[4]
				var y_offset = -sin(t * PI) * 100
				a[1].global_position = Vector2(t * a[3].x + (1 - t) * a[2].x, t * a[3].y + (1 - t) * a[2].y + y_offset)
	pass

func _process(delta):
	if m_context == null:
		return;
	m_timer += delta
	while m_timer > m_step:
		m_home_core.step()
		m_timer -= m_step
	process_ants()
	m_ant_born_ratio.text = str(m_home_core.get_ant_born_ratio())
	m_gacha_cd_label.text = str(m_home_core.get_gacha_cd())
	
func spawn_box_inst(high):
	var ps = m_context.get_box_ps()
	if ps != null:
		if m_waiting_box != null:
			m_waiting_box.queue_free()
		m_waiting_box = ps.instance()
		m_waiting_box.setup(high)
		m_box_container.add_child(m_waiting_box)
		m_waiting_box.global_position = m_box_spawn_pos.global_position

func box_spawned(inst_id):
	var inst = m_waiting_box
	if inst == null:
		var box_ps = m_context.get_box_ps()
		if box_ps != null:
			inst = box_ps.instance()
	else:
		m_waiting_box = null
	if inst != null:
		m_box_container.add_child(inst)
		inst.position = Vector2.ZERO
		m_box_insts.append([inst_id, inst])
		inst.setup(false)
	pass
func box_die(inst_id):
	for b in m_box_insts:
		if b[0] == inst_id:
			b[1].queue_free()
			m_box_insts.erase(b)
			break
	pass
func ant_spawned(inst_id):
	var ant_ps = m_context.get_ant_ps()
	if ant_ps != null:
		var inst = ant_ps.instance()
		m_ant_home_position.add_child(inst)
		inst.position = Vector2.ZERO
		m_ant_insts.append([inst_id, inst, Vector2.ZERO, Vector2.ZERO])
	pass
func ant_state_changed(inst_id, old_state, new_state, target_box_id):
	pass
func ant_die(inst_id):
	for a in m_ant_insts:
		if a[0] == inst_id:
			a[1].queue_free()
			m_ant_insts.erase(a)
			break
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


func _on_Battle_pressed():
	m_context.home_battle_pressed()
	pass # Replace with function body.


func _on_BoxActiveZone_body_entered(body):
	print(body.name)
	if body is RigidBody2D:
		m_home_core.spawn_box()
	pass # Replace with function body.


func _on_ReqSupply_pressed():
	if !m_context.can_get_box():
		return
	if m_home_core.get_gacha_cd() > 0:
		return
	if m_context.gacha():
		m_home_core.set_gacha_cd(500)
	pass # Replace with function body.


func _on_ReqBox_pressed():
	if !m_context.can_get_box():
		return
	if m_home_core.get_gacha_cd() > 0:
		return
	if m_context.get_empty_box():
		m_home_core.set_gacha_cd(500)
	pass # Replace with function body.
