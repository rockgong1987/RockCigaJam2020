extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var m_battle_core = $BattleCore
onready var m_boom_input = $Panel/BoomInput
onready var m_output = $Panel/Output

export(int) var boom_count = 0

var m_boom_cnt = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	m_battle_core.setup(self)
	m_boom_input.text = "0"
	m_boom_cnt = boom_count
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StepButton_pressed():
	m_battle_core.step(int(m_boom_input.text))
	m_boom_input.text = "0"
	m_output.text = ""
	_on_PrintStateButton_pressed()
	pass # Replace with function body.

func append_log(content):
	m_output.text = m_output.text + content + "\n"

func _on_PrintStateButton_pressed():
	append_log("========================================")
	append_log("STEP : " + str(m_battle_core.get_main_step()))
	append_log("[Player]")
	append_log("\tHP = " + str(m_battle_core.get_player_hp()))
	append_log("\tCD = " + str(m_battle_core.get_player_cd()))
	append_log("\tBLT = " + str(m_battle_core.get_bullets_pos()))
	append_log("[Enemy]")
	var enemy_list = m_battle_core.get_enemy_states()
	for e in enemy_list:
		append_log("\t" + str(e))
	append_log("[Enemy Bullet]")
	var enemy_bullets = m_battle_core.get_enemy_bullets_pos()
	for b in enemy_bullets:
		append_log("\t" + str(b))

func get_player_max_hp():
	return 200
func get_player_max_cd():
	return 10
func get_player_atk():
	return 5
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
		return 20
	elif type_id == 1:
		return 10
	elif type_id == 2:
		return 50
	else:
		return 100
func get_enemy_radius(type_id):
	if type_id == 3:
		return 50
	return 3
func get_enemy_attack_range(type_id):
	if type_id == 0:
		return 1
	elif type_id == 1:
		return 20
	elif type_id == 2:
		return 1
	else:
		return 100
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
		return 3
	elif type_id == 2:
		return 0
	return 10

func get_enemy_move_speed(type_id):
	if type_id == 0:
		return 3
	elif type_id == 1:
		return 3
	elif type_id == 2:
		return 10
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
func player_bullet_spawned(inst_id):
	print("player bullect : ", inst_id)
func player_bullet_die(inst_id):
	print("player_bullect_die", inst_id)
func enemy_spawned(inst_id):
	print("enemy spawned : ", inst_id)
func enemy_bullet_spawned(inst_id):
	print("enemy bullet spawned : ", inst_id)
func enemy_bullet_die(inst_id):
	print("enemy bullet die", inst_id)
func enemy_damaged(inst_id, dmg):
	print("damaged : ", inst_id, dmg)
func enemy_die(inst_id):
	print("die : ", inst_id)
func player_damaged(inst_id, dmg):
	print("player damaged : ", inst_id, dmg)
func player_die():
	print("player die")
