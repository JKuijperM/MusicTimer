extends CanvasLayer
@export var default_seconds = 30
@export var default_minutes = 1
var seconds
var minutes
var timer_is_playing = false
signal play_timer

# Called when the node enters the scene tree for the first time.
func _ready():
	$RemainingTime.text = str(default_minutes) + ":" + str(default_seconds)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func reset_timer():
	seconds = default_seconds
	minutes = default_minutes


func _on_play_button_pressed():
	
	if $Timer.is_paused():
		$Timer.paused = false
	else:
		if !timer_is_playing:
			timer_is_playing = true
			reset_timer()
			$Timer.start()

func _on_timer_timeout():	
	if seconds == 0:
		if minutes > 0:
			minutes -= 1
			seconds == 60
	seconds -= 1
		
	$RemainingTime.text = str(minutes) + ":" + str(seconds)


func _on_pause_button_pressed():
	timer_is_playing = false
	$Timer.paused = true


func _on_stop_button_pressed():
	timer_is_playing = false
	$Timer.paused = false
	$Timer.stop()
