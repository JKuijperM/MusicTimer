extends Control

var seconds
var minutes
var default_seconds = 30
var default_minutes = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	reset_timer()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	if seconds == 0:
		if minutes > 0:
			minutes -= 1
			seconds == 60
	seconds -= 1	
		
	$Label.text = str(minutes) + ":" + str(seconds)


func reset_timer():
	seconds = default_seconds
	minutes = default_minutes
