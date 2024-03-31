extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_value(value):
	$Panel.material.set_shader_parameter("value", value)
	
func set_remining_time(txt):
	$RemainingTime.text = txt 
