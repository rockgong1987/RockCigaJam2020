extends Node2D

var m_context
# on_back_pressed()
# on_battle_confirmed(battle_id)
# get_battle_count()
# get_battle_info(battle_id)
export(PackedScene) var level_button = null

onready var m_detail_panel = $DetailPanel
onready var m_mask = $Mask
onready var m_detail_panel_title = $DetailPanel/Title
onready var m_detail_panel_desc = $DetailPanel/Desc
var m_detail_panel_on = false
var m_cur_battle_id = null

func setup(context):
	m_context = context
	if context == null:
		return
	m_detail_panel_on = false
	m_detail_panel.visible = false
	m_mask.visible = false
	for id in m_context.get_battle_count():
		var inst = level_button.instance()
		var container = get_node("Levels/L" + str(id))
		if container == null:
			container = $Levels/LD
		container.add_child(inst)
		inst.position = Vector2.ZERO
		inst.setup(self, id)
		
func get_bg_ps(battle_id):
	return null
func battle_button_pressed(battle_id):
	if m_detail_panel_on:
		return
	var info = m_context.get_battle_info(battle_id)
	m_detail_panel_title.text = info[0]
	m_detail_panel_desc.text = info[1]
	m_detail_panel.visible = true
	m_mask.visible = true
	m_detail_panel_on = true
	m_cur_battle_id = battle_id
	pass

func _on_Back_pressed():
	m_context.on_back_pressed()
	pass # Replace with function body.


func _on_NG_pressed():
	m_detail_panel_on = false
	m_detail_panel.visible = false
	m_mask.visible = false
	pass # Replace with function body.


func _on_OK_pressed():
	m_context.on_battle_confirmed(m_cur_battle_id)
	pass # Replace with function body.
