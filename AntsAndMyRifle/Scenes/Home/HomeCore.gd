extends Node

var m_context

export(int) var ant_wait_cd = 0
export(int) var ant_go_cd = 0
export(int) var ant_eat_cd = 0
export(int) var ant_back_cd = 0
# get_box_capacity()
# get_ant_capacity()
# get_ant_count()
# get_box_count()
# set_ant_count()
# set_ant_count()
# get_ant_born_ratio_increase(ant_cnt)
# box_spawned(inst_id)
# box_die(inst_id)
# ant_spawned(inst_id)
# ant_state_changed(inst_id, old_state, new_state, target_box_id)
# ant_die(inst_id)

var m_ant_states = []
var m_ant_id_counter = 0
# [id, step, cd, target_box_id, max_cd]
var m_ant_born_ratio = 0.0
var m_box_states = []
var m_box_id_counter = 0
var m_gacha_cd = 0

func setup(context):
	m_context = context
	if context == null:
		return
	m_ant_id_counter = 0
	m_box_id_counter = 0
	for i in range(0, m_context.get_box_count()):
		spawn_box()
	for i in range(0, m_context.get_ant_count()):
		spawn_ant()
	
func spawn_ant():
	m_ant_states.append([m_ant_id_counter, 0, ant_wait_cd, null, ant_wait_cd])
	m_context.set_ant_count(len(m_ant_states))
	m_context.ant_spawned(m_ant_id_counter)
	m_ant_id_counter += 1
	
func process_ants():
	for ant in m_ant_states:
		if ant[2] > 0:
			ant[2] -= 1
		if ant[2] == 0:
			var old_state = ant[1]
			if ant[1] == 0:
				var box_id = null
				for b in m_box_states:
					var occupied = false
					for a in m_ant_states:
						if a[3] == b:
							occupied = true
							break
					if !occupied:
						box_id = b
				if box_id != null and (len(m_ant_states) < m_context.get_ant_capacity() or m_ant_born_ratio < 0.98):
					ant[1] = 1
					ant[2] = ant_go_cd
					ant[3] = box_id
					ant[4] = ant_go_cd
				else:
					ant[2] = ant_wait_cd
			elif ant[1] == 1:
				ant[1] = 2
				ant[2] = ant_eat_cd
				ant[4] = ant_eat_cd
			elif ant[1] == 2:
				var add_ratio = m_context.get_ant_born_ratio_increase(len(m_ant_states))
				var new_ratio = add_ratio + m_ant_born_ratio
				while (new_ratio > 1.0):
					if (m_context.get_ant_capacity() > len(m_ant_states)):
						spawn_ant()
						new_ratio -= 1.0
					else:
						new_ratio = 0.99
				for b in m_box_states:
					if b == ant[3]:
						m_box_states.erase(b)
						m_context.set_box_count(len(m_box_states))
						m_context.box_die(ant[3])
						break
				m_ant_born_ratio = new_ratio
				ant[1] = 3
				ant[2] = ant_back_cd
				ant[4] = ant_back_cd
			else:
				ant[1] = 0
				ant[2] = ant_wait_cd
				ant[3] = null
				ant[4] = ant_wait_cd
			if old_state != ant[1]:
				m_context.ant_state_changed(ant[0], old_state, ant[1], ant[3])
	
func step():
	if m_context == null:
		return
	process_ants()
	if m_gacha_cd > 0:
		m_gacha_cd -= 1

func can_spawn_box():
	return len(m_box_states) < m_context.get_box_capacity()
	
func set_gacha_cd(cd):
	m_gacha_cd = cd
	
func spawn_box():
	if !can_spawn_box():
		return false
	m_box_states.append(m_box_id_counter)
	m_context.box_spawned(m_box_id_counter)
	m_box_id_counter += 1
	m_context.set_box_count(len(m_box_states))

func get_killable_ant_id():
	for ant in m_ant_states:
		if ant.step == 0:
			return ant[0]
	return null

func kill_ant():
	var ant_id = get_killable_ant_id()
	if ant_id == null:
		return
	for ant in m_ant_states:
		if ant[0] == ant_id:
			m_ant_states.erase(ant)
			m_context.set_ant_count(len(m_ant_states))
	pass

func get_ant_states():
	return m_ant_states

func get_box_states():
	return m_box_states
	
func get_ant_born_ratio():
	return m_ant_born_ratio

func get_gacha_cd():
	return m_gacha_cd
