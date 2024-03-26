extends CanvasLayer

@export var default_seconds = 30
@export var default_minutes = 1

@onready var background_music = $BackgroundMusic

var seconds
var minutes
var max_seconds
var current_seconds
var timer_is_playing = false
var edit_menu_visible = false

signal play_timer

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get the length of the music
	if background_music.stream:
		var stream_length = background_music.stream.get_length()
		default_minutes = int(stream_length / 60)
		default_seconds = int(fmod(stream_length, 60))
	
	reset_remaining_time_label()
	
	$SpinBoxMinutes.get_line_edit().context_menu_enabled = false
	$SpinBoxMinutes.value = default_minutes
	$SpinBoxSeconds.get_line_edit().context_menu_enabled = false
	$SpinBoxSeconds.value = default_seconds
	$SpinBoxMinutes.visible = false
	$SpinBoxSeconds.visible = false
	$MinutesLabel.visible = false
	$SecondsLabel.visible = false

	# Calculate the total seconds
	max_seconds = default_minutes * 60 + default_seconds
	current_seconds = max_seconds
	#$CircularProgressBar.set_max_value(current_seconds)
	$CircularProgressBar.set_value(calculate_equivalent_progress(current_seconds))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func reset_timer():
	seconds = default_seconds
	minutes = default_minutes
	# Calculate the total seconds
	max_seconds = default_minutes * 60 + default_seconds
	current_seconds = max_seconds

func reset_remaining_time_label():
	## Resets the value of the label
	var minutes_str = str(default_minutes) if default_minutes >= 10 else "0" + str(default_minutes)
	var seconds_str = str(default_seconds) if default_seconds >= 10 else "0" + str(default_seconds)
	$RemainingTime.text = minutes_str + ":" + seconds_str

func stop_timer():
	## Stops the timer, sets as 'false' the timer_is_playing flag and also
	## the property paused in the timer
	timer_is_playing = false
	$Timer.paused = false
	$Timer.stop()
	$CircularProgressBar.set_value(calculate_equivalent_progress(max_seconds))
	background_music.stop()
	
func calculate_equivalent_progress(value):
	return (value * 100) / max_seconds

func _on_play_button_pressed():	
	if $Timer.is_paused():
		$Timer.paused = false
		background_music.stream_paused = false
		timer_is_playing = true
	else:
		if !timer_is_playing:
			timer_is_playing = true
			reset_timer()
			$Timer.start()
			background_music.play()

func _on_timer_timeout():	
	if seconds == 0:
		if minutes > 0:
			minutes -= 1
			seconds == 60
		else:
			$Timer.stop()
			background_music.stop()
	elif seconds > 0:
		seconds -= 1
	current_seconds -= 1
	
	var minutes_str = str(minutes) if minutes >= 10 else "0" + str(minutes)
	var seconds_str = str(seconds) if seconds >= 10 else "0" + str(seconds)
	$RemainingTime.text = minutes_str + ":" + seconds_str
	$CircularProgressBar.set_value(calculate_equivalent_progress(current_seconds))


func _on_pause_button_pressed():
	timer_is_playing = false
	$Timer.paused = true
	background_music.stream_paused = true


func _on_stop_button_pressed():
	stop_timer()
	reset_remaining_time_label()


func _on_edit_button_pressed():
	## Toggles the spinboxes (visible and editable) between true and false
	$SpinBoxMinutes.visible = !$SpinBoxMinutes.visible
	$SpinBoxMinutes.editable = !$SpinBoxMinutes.editable
	$SpinBoxSeconds.visible = !$SpinBoxSeconds.visible
	$SpinBoxSeconds.editable = !$SpinBoxSeconds.editable 
	
	$MinutesLabel.visible = !$MinutesLabel.visible
	$SecondsLabel.visible = !$SecondsLabel.visible
	
	# Check if the edit menu is not visible and stops the timer in this case
	if !edit_menu_visible:
		stop_timer()		
	
	# Toggle the value of 'edit_menu_visible'
	edit_menu_visible = !edit_menu_visible


func _on_spin_box_minutes_value_changed(value):
	default_minutes = $SpinBoxMinutes.value
	reset_remaining_time_label()


func _on_spin_box_seconds_value_changed(value):
	default_seconds = $SpinBoxSeconds.value
	reset_remaining_time_label()


func _on_volume_slider_drag_ended(value_changed):
	background_music.volume_db = $VolumeSlider.value
	print($VolumeSlider.value)
