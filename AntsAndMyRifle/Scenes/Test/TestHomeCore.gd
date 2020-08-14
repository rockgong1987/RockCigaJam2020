extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var m_home_core = $HomeCore

onready var m_bcap_label = $Control/BCapLabel
onready var m_acap_label = $Control/ACapLabel
onready var m_bcnt_label = $Control/BCntLabel
onready var m_acnt_label = $Control/ACntLabel
onready var m_output = $Control/Output

export(int) var box_capacity = 0
export(int) var ant_capacity = 0
export(int) var box_count = 0
export(int) var ant_count = 0

var m_box_capacity = 0
var m_ant_capacity = 0
var m_box_count = 0
var m_ant_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	m_box_capacity = box_capacity
	m_ant_capacity = ant_capacity
	m_box_count = box_count
	m_ant_count = ant_count
	m_home_core.setup(self)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_box_capacity():
	return m_box_capacity
func get_ant_capacity():
	return m_ant_capacity
func get_box_count():
	return m_box_count
func get_ant_count():
	return m_ant_count
func set_box_count(val):
	m_box_count = val
	m_bcnt_label.text = str(val)
	pass
func set_ant_count(val):
	m_ant_count = val
	m_acnt_label.text = str(val)
	pass
func get_ant_born_ratio_increase(ant_cnt):
	return 0.2
	pass
func box_spawned(inst_id):
	print("box_spawned : ", inst_id)
	pass
func box_die(inst_id):
	print("box_die : ", inst_id)
	pass
func ant_spawned(inst_id):
	print("ant_spawned : ", inst_id)
	pass
func ant_state_changed(inst_id, old_state, new_state, target_box_id):
	print("ant_state_changed : ", [inst_id, old_state, new_state, target_box_id])
	pass
func ant_die(inst_id):
	print("ant_die : ", inst_id)
	pass


func _on_BCapUp_pressed():
	m_box_capacity += 1
	m_bcap_label.text = str(m_box_capacity)
	pass # Replace with function body.


func _on_BCapDown_pressed():
	m_box_capacity -= 1
	m_bcap_label.text = str(m_box_capacity)
	pass # Replace with function body.


func _on_ACapUp_pressed():
	m_ant_capacity += 1
	m_acap_label.text = str(m_ant_capacity)
	pass # Replace with function body.


func _on_ACapDown_pressed():
	m_ant_capacity -= 1
	m_acap_label.text = str(m_ant_capacity)
	pass # Replace with function body.


func _on_BCntUp_pressed():
	m_box_count += 1
	m_bcnt_label.text = str(m_box_count)
	pass # Replace with function body.


func _on_BCntDown_pressed():
	m_box_count -= 1
	m_bcnt_label.text = str(m_box_count)
	pass # Replace with function body.


func _on_ACntUp_pressed():
	m_ant_count += 1
	m_acnt_label.text = str(m_ant_count)
	pass # Replace with function body.


func _on_ACntDown_pressed():
	m_ant_count -= 1
	m_acnt_label.text = str(m_ant_count)
	pass # Replace with function body.


func _on_Step_pressed():
	m_home_core.step()
	m_output.text = ""
	appendlog("=============================")
	appendlog(m_home_core.get_box_states())
	appendlog(m_home_core.get_ant_states())
	appendlog(m_home_core.get_ant_born_ratio())
	pass # Replace with function body.

func appendlog(content):
	m_output.text = m_output.text + str(content) + "\n"
