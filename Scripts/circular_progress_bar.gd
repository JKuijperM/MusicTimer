extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_value(value):
	$TextureProgressBar.value = value	
		
func set_min_value(value):
	$TextureProgressBar.min_value = value
	
func set_max_value(value):
	$TextureProgressBar.max_value = value
