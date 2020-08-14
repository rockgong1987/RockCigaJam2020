extends Node2D

var m_context
# get_bg_ps()
# get_player_ps()
# get_enemy_ps(type_id)
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

onready var m_battle_core = $BattleCore
onready var m_player_pos = $PlayerPos

var m_timer = 0.0
var m_step = 1.0 / 60.0

var m_player_inst = null
var m_enemy_insts = []
var m_player_bullet_insts = []
var m_enemy_bullet_insts = []

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

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	m_timer += delta
	while (m_timer > m_step):
		m_timer -= m_step
		m_battle_core.step(0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func linear_pos(pos):
	return Vector2(m_player_pos.position.x + pos * pos_linear_weight, m_player_pos.position.y)

# -- scene used
func enemy_spawned(inst_id):
	pass
func enemy_bullet_spawned(inst_id):
	pass
func enemy_damaged(inst_id, dmg):
	pass
func enemy_die(inst_id):
	pass
func player_damaged(inst_id, dmg):
	pass
func player_die():
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
