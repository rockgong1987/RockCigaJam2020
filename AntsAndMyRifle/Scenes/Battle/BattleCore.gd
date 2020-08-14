extends Node

var m_context = null
# get_player_max_hp()
# get_player_max_cd()
# get_player_atk()
# get_player_crit_prob()
# get_player_double_prob()
# get_player_triple_prob()
# get_player_boom_count()
# get_player_boom_radius()
# get_player_boom_damage()
# get_enemy_atk(type_id)
# get_enemy_max_hp(type_id)
# get_enemy_radius(type_id)
# get_enemy_attack_range(type_id)
# get_enemy_attack_cd(type_id)
# get_enemy_attack_pre(type_id)
# get_enemy_move_speed(type_id)
# get_main_spawn_enemy(step_cnt)
# player_use_boom()
# enemy_spawned(inst_id)
# enemy_damaged(inst_id, dmg)
# enemy_die(inst_id)
# player_damaged(inst_id, dmg)
# player_die()
# ...

export(int) var enemy_save_zone_length = 0
export(int) var boom_max_process = 0
export(int) var bullet_speed = 1
export(int) var player_radius = 1

var m_main_step_counter = 0
var m_enemy_id_counter = 0
var m_enemy_bullet_id_counter = 0
var m_player_hp = 0
var m_player_cd = 0
var m_player_bullets_pos = []
var m_enemy_bullets_pos = []
var m_boom_process = 0
var m_boom_target_pos = 0

var m_enemy_states = []
# [inst_id(0), type_id(1), hp(2), pos(3), attacking(4), attack_cd(5), attack_pre(6)]
# ...

func _ready():
	pass

func setup(context):
	if m_context != null:
		print("[BattleCore] already setup")
		return
	m_context = context
	m_player_hp = context.get_player_max_hp()
	m_player_cd = 0
	m_main_step_counter = 0
	m_enemy_id_counter = 1
	
func get_enemy(inst_id):
	for enemy in m_enemy_states:
		if enemy[0] == inst_id:
			return enemy
	return null

func damage_enemy(inst_id, dmg):
	var enemy = get_enemy(inst_id)
	if enemy != null:
		enemy[2] -= dmg
		m_context.enemy_damaged(inst_id, dmg)
		if enemy[2] <= 0:
			m_enemy_states.erase(inst_id)
			m_context.enemy_die(inst_id)
	pass

func do_boom():
	var min_x = m_boom_target_pos - m_context.get_player_boom_radius()
	var max_x = m_boom_target_pos + m_context.get_player_boom_radius()
	for enemy in m_enemy_states:
		if min_x < enemy[3].pos - m_context.get_enemy_radius(enemy[1]) and max_x < enemy[3].pos + m_context.get_enemy_radius(enemy[1]):
			damage_enemy(enemy[0], m_context.get_player_boom_damage())
			
func do_shot():
	m_player_bullets_pos.append(0)
	pass
	
func process_bullet(index):
	if index < 0 or index >= len(m_player_bullets_pos):
		return false;
	var old_pos = m_player_bullets_pos[index]
	var new_pos = old_pos + bullet_speed
	var enemy_list = []
	for e in m_enemy_states:
		if old_pos < e[3] + m_context.get_enemy_radius(e[1]) and new_pos > e[3] - m_context.get_enemy_radius(e[1]):
			enemy_list.append(e)
	var hit_enemy = null
	for e in enemy_list:
		if hit_enemy == null:
			hit_enemy = e
		else:
			if e[3] - m_context.get_enemy_radius(e[1]) < hit_enemy[3] - m_context.get_enemy_radius(e[1]):
				hit_enemy = e
	if hit_enemy != null:
		damage_enemy(hit_enemy[0], m_context.get_player_atk())
		return true
	m_player_bullets_pos[index] = new_pos
	return false

func process_bullets():
	if m_player_cd == 0:
		m_player_cd = m_context.get_player_max_cd()
		m_player_bullets_pos.append(0)
	var index = 0
	while (index < len(m_player_bullets_pos)):
		if (process_bullet(index)):
			m_player_bullets_pos.remove(index)
			index -= 1
		index += 1

func damage_player(enemy_inst_id):
	var enemy = get_enemy(enemy_inst_id)
	if enemy != null:
		var dmg = m_context.get_enemy_atk(enemy[1])
		m_context.player_damaged(enemy_inst_id, dmg)
		if m_player_hp > dmg:
			m_player_hp -= dmg
		else:
			m_player_hp = 0
			m_context.player_die()
		
func process_enemy():
	for e in m_enemy_states:
		if e[4] == 0:
			var speed = m_context.get_enemy_move_speed(e[1])
			if e[3] - player_radius - m_context.get_enemy_radius(e[1]) - m_context.get_enemy_attack_range(e[1]) > speed:
				e[3] -= speed
			else:
				e[3] = player_radius + m_context.get_enemy_radius(e[1]) + m_context.get_enemy_attack_range(e[1])
				e[4] = 1
				e[6] = m_context.get_enemy_attack_pre(e[1])
		else:
			if e[5] > 0:
				e[5] -= 1
			elif e[6] > 0:
				e[6] -= 1
			else:
				damage_player(e[0])
				e[5] = m_context.get_enemy_attack_cd(e[1])
		
func process_spawn_enemy():
	var enemy_type_id = m_context.get_main_spawn_enemy(m_main_step_counter)
	if enemy_type_id != null:
		m_enemy_states.append([m_enemy_id_counter, enemy_type_id, m_context.get_enemy_max_hp(enemy_type_id), 100, 0, 0, 0])
		m_context.enemy_spawned(m_enemy_id_counter)
		m_enemy_id_counter += 1

func step(boom_pos):
	if m_context == null:
		return
	process_enemy()
	process_spawn_enemy()
	if boom_pos > 0 and m_boom_process == 0 and m_context.get_player_boom_count() > 0:
		m_boom_target_pos = boom_pos
		m_boom_process = boom_max_process
	if m_boom_process > 0:
		m_boom_process -= 1
		if m_boom_process == 0:
			do_boom()
	if m_player_cd > 0:
		m_player_cd -= 1
		if m_player_cd == 0:
			m_player_cd = m_context.get_player_max_cd()
			do_shot()
	process_bullets()
	m_main_step_counter += 1
	
func get_player_hp():
	return m_player_hp

func get_player_cd():
	return m_player_cd

func get_enemy_states():
	return m_enemy_states
	
func get_bullets_pos():
	return m_player_bullets_pos
	
func get_main_step():
	return m_main_step_counter
