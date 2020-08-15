extends Node2D
var m_context = null
var m_battle_id
# get_bg_ps(battle_id)
# battle_button_pressed(battle_id)

var m_mouse_in = false

func setup(context, battle_id):
	m_context = context
	if context == null:
		return
	m_battle_id = battle_id
	var ps = m_context.get_bg_ps(battle_id)
	if ps != null:
		var inst = ps.instance()
		add_child(inst)
		inst.position = Vector2.ZERO

func _on_Button_pressed():
	m_context.battle_button_pressed(m_battle_id)
	pass # Replace with function body.
