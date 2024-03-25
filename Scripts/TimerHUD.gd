extends CanvasLayer
@export var default_seconds = 30
@export var default_minutes = 1
var seconds
var minutes
var total_seconds
var timer_is_playing = false
signal play_timer

var edit_menu_visible = false

# Called when the node enters the scene tree for the first time.
func _ready():
	reset_remaining_time_label()
	
	$SpinBoxMinutes.get_line_edit().context_menu_enabled = false
	$SpinBoxMinutes.value = default_minutes
	$SpinBoxSeconds.get_line_edit().context_menu_enabled = false
	$SpinBoxSeconds.value = default_seconds
	# Calculate the total seconds
	total_seconds = default_minutes * 60 + default_seconds
	$CircularProgressBar.set_max_value(total_seconds)
	$CircularProgressBar.set_value(total_seconds)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func reset_timer():
	seconds = default_seconds
	minutes = default_minutes
	# Calculate the total seconds
	total_seconds = default_minutes * 60 + default_seconds

func reset_remaining_time_label():
	## Resets the value of the label
	$RemainingTime.text = str(default_minutes) + ":" + str(default_seconds)

func stop_timer():
	## Stops the timer, sets as 'false' the timer_is_playing flag and also
	## the property paused in the timer
	timer_is_playing = false
	$Timer.paused = false
	$Timer.stop()

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
	total_seconds -= 1
	$RemainingTime.text = str(minutes) + ":" + str(seconds)
	$CircularProgressBar.set_value(total_seconds)


func _on_pause_button_pressed():
	timer_is_playing = false
	$Timer.paused = true


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
