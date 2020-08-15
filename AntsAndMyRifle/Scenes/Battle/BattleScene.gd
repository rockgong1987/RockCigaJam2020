extends Node2D

var m_context
# get_bg_ps()
# get_player_ps()
# get_enemy_ps(type_id)
# get_player_bullet_ps()
# get_enemy_bullet_ps()
# get_enemy_total_count()
# battle_result(win)
# ----forward
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
# get_enemy_attack_bullet_speed(type_id)
# get_enemy_attack_cd(type_id)
# get_enemy_attack_pre(type_id)
# get_enemy_move_speed(type_id)
# get_main_spawn_enemy(step_cnt)
# player_use_boom()
export(float) var pos_linear_weight = 0.0
export(float) var bullet_y_offset = 0.0

onready var m_battle_core = $BattleCore
onready var m_player_pos = $PlayerPos

var m_timer = 0.0
var m_step = 1.0 / 60.0

var m_player_inst = null
var m_enemy_insts = []
var m_player_bullet_insts = []
var m_enemy_bullet_insts = []
var m_kill_counter = 0

func setup(context):
	m_context = context
	if context == null:
		return
	m_battle_core.setup(self)
	var bg_ps = m_context.get_bg_ps()
	if bg_ps != null:
		var inst = bg_ps.instance()
		self.add_child(inst)
		inst.position = Vector2.ZERO
	var player_ps = m_context.get_player_ps()
	if player_ps != null:
		var inst = player_ps.instance()
		self.add_child(inst)
		inst.position = linear_pos(0)
		
func update_insts():
	for bi in m_player_bullet_insts:
		var bullets = m_battle_core.get_bullets_pos()
		var bullet = null
		for b in bullets:
			if b[0] == bi[0]:
				bullet = b
				break
		if bullet != null:
			bi[1].position = linear_pos(bullet[1]) + Vector2(0, bullet_y_offset)
	for ei in m_enemy_insts:
		var enemies = m_battle_core.get_enemy_states()
		var enemy = null
		for e in enemies:
			if e[0] == ei[0]:
				enemy = e
				break
		if enemy != null:
			ei[1].position = linear_pos(enemy[3])
	for bi in m_enemy_bullet_insts:
		var bullets = m_battle_core.get_enemy_bullets_pos()
		var bullet = null
		for b in bullets:
			if b[0] == bi[0]:
				bullet = b
				break
		if bullet != null:
			bi[1].position = linear_pos(bullet[2]) + Vector2(0, bullet_y_offset)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	m_timer += delta
	while (m_timer > m_step):
		m_timer -= m_step
		m_battle_core.step(0)
	update_insts()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func linear_pos(pos):
	return Vector2(m_player_pos.position.x + pos * pos_linear_weight, m_player_pos.position.y)

# -- scene used
func player_bullet_spawned(inst_id):
	var b_ps = m_context.get_player_bullet_ps()
	if b_ps != null:
		var inst = b_ps.instance()
		self.add_child(inst)
		m_player_bullet_insts.append([inst_id, inst])
	pass
func player_bullet_die(inst_id):
	for b in m_player_bullet_insts:
		if b[0] == inst_id:
			b[1].queue_free()
			break
func enemy_spawned(inst_id):
	var type_id = null
	var enemies = m_battle_core.get_enemy_states()
	for e in enemies:
		if e[0] == inst_id:
			type_id = e[1]
			break
	var e_ps = m_context.get_enemy_ps(type_id)
	if e_ps != null:
		var inst = e_ps.instance()
		self.add_child(inst)
		m_enemy_insts.append([inst_id, inst])
	pass
func enemy_bullet_spawned(inst_id):
	print("enemy_bullet_spawned : ", inst_id)
	var b_ps = m_context.get_enemy_bullet_ps()
	if b_ps != null:
		var inst = b_ps.instance()
		self.add_child(inst)
		m_enemy_bullet_insts.append([inst_id, inst])
	pass
func enemy_bullet_die(inst_id):
	print("enemy_bullet_die : ", inst_id)
	for b in m_enemy_bullet_insts:
		if b[0] == inst_id:
			b[1].queue_free()
			break
	pass
func enemy_damaged(inst_id, dmg):
	pass
func enemy_die(inst_id):
	m_kill_counter += 1
	for b in m_enemy_insts:
		if b[0] == inst_id:
			b[1].queue_free()
			break
	if m_context.get_enemy_total_count() <= m_kill_counter:
		m_context.battle_result(true)
	pass
func player_damaged(inst_id, dmg):
	pass
func player_die():
	m_context.battle_result(false)
	pass

# -- forward
func get_player_max_hp():
	return m_context.get_player_max_hp()
func get_player_max_cd():
	return m_context.get_player_max_cd()
func get_player_atk():
	return m_context.get_player_atk()
func get_player_crit_prob():
	return m_context.get_player_crit_prob()
func get_player_double_prob():
	return m_context.get_player_double_prob()
func get_player_triple_prob():
	return m_context.get_player_triple_prob()
func get_player_boom_count():
	return m_context.get_player_boom_count()
func get_player_boom_radius():
	return m_context.get_player_boom_radius()
func get_player_boom_damage():
	return m_context.get_player_boom_damage()
func get_enemy_atk(type_id):
	return m_context.get_enemy_atk(type_id)
func get_enemy_max_hp(type_id):
	return m_context.get_enemy_max_hp(type_id)
func get_enemy_radius(type_id):
	return m_context.get_enemy_radius(type_id)
func get_enemy_attack_range(type_id):
	return m_context.get_enemy_attack_range(type_id)
func get_enemy_attack_bullet_speed(type_id):
	return m_context.get_enemy_attack_bullet_speed(type_id)
func get_enemy_attack_cd(type_id):
	return m_context.get_enemy_attack_cd(type_id)
func get_enemy_attack_pre(type_id):
	return m_context.get_enemy_attack_pre(type_id)
func get_enemy_move_speed(type_id):
	return m_context.get_enemy_move_speed(type_id)
func get_main_spawn_enemy(step_cnt):
	return m_context.get_main_spawn_enemy(step_cnt)
func player_use_boom():
	return m_context.player_use_boom()
