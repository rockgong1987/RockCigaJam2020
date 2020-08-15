extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(float) var time = 0.0
var m_timer = 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	m_timer = 0.0
	$Particles2D.emitting = true
	$Particles2D2.emitting = true
	pass # Replace with function body.

func _process(delta):
	m_timer += delta
	if m_timer > time:
		queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
