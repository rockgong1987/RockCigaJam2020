extends Node

export(PackedScene) var player_ps = null
export(PackedScene) var bg_ps = null
export(PackedScene) var enemy_ps = null
export(PackedScene) var pb_ps = null
export(PackedScene) var eb_ps = null

var m_boom_cnt = 5

onready var m_battle_scene = $BattleScene

# Called when the node enters the scene tree for the first time.
func _ready():
	m_battle_scene.setup(self)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_bg_ps():
	return bg_ps
func get_player_ps():
	return player_ps
func get_enemy_ps(type_id):
	return enemy_ps
func get_player_bullet_ps():
	return pb_ps
func get_enemy_bullet_ps():
	return eb_ps
func battle_result(win):
	if win:
		print("WIN")
	else:
		print("LOSE")
	pass
func get_player_max_hp():
	return 200
func get_player_max_cd():
	return 100
func get_player_atk():
	return 5000
func get_player_crit_prob():
	return 0.1
func get_player_double_prob():
	return 0.1
func get_player_triple_prob():
	return 0.1
func get_player_boom_count():
	return m_boom_cnt
func get_player_boom_radius():
	return 5
func get_player_boom_damage():
	return 20
func get_enemy_atk(type_id):
	if type_id == 0:
		return 10
	else:
		return 20
func get_enemy_max_hp(type_id):
	if type_id == 0:
		return 200
	elif type_id == 1:
		return 100
	elif type_id == 2:
		return 500
	else:
		return 1000
func get_enemy_radius(type_id):
	if type_id == 3:
		return 500
	return 800
func get_enemy_attack_range(type_id):
	if type_id == 0:
		return 1
	elif type_id == 1:
		return 5000
	elif type_id == 2:
		return 1
	else:
		return 10000
func get_enemy_attack_cd(type_id):
	if type_id == 0:
		return 10
	elif type_id == 1:
		return 20
	elif type_id == 2:
		return 10
	else:
		return 10
	
func get_enemy_attack_pre(type_id):
	if type_id == 0:
		return 3
	elif type_id == 1:
		return 3
	elif type_id == 2:
		return 3
	else:
		return 3
		
func get_enemy_attack_bullet_speed(type_id):
	if type_id == 0:
		return 0
	elif type_id == 1:
		return 100
	elif type_id == 2:
		return 0
	return 100

func get_enemy_move_speed(type_id):
	if type_id == 0:
		return 30
	elif type_id == 1:
		return 30
	elif type_id == 2:
		return 100
	elif type_id == 3:
		return 0
	
func get_main_spawn_enemy(step_cnt):
	if step_cnt == 0:
		return 0
	elif step_cnt == 5:
		return 1
	elif step_cnt == 10:
		return 2
	elif step_cnt == 10:
		return 3
	return null
func player_use_boom():
	m_boom_cnt -= 1
	pass
func enemy_spawned(inst_id):
	print("enemy spawned : ", inst_id)
func enemy_bullet_spawned(inst_id):
	print("enemy bullet spawned : ", inst_id)
func enemy_damaged(inst_id, dmg):
	print("damaged : ", inst_id, dmg)
func enemy_die(inst_id):
	print("die : ", inst_id)
func player_damaged(inst_id, dmg):
	print("player damaged : ", inst_id, dmg)
func player_die():
	print("player die")
