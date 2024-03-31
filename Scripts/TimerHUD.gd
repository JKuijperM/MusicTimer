extends CanvasLayer

@export var default_seconds = 30
@export var default_minutes = 1
@export var alert_seconds = 5

# AudioStreamPlayer
@onready var background_music: AudioStreamPlayer = $BackgroundMusic
@onready var alert_sound: AudioStreamPlayer = $AlertSound
# SpinBox
@onready var sb_minutes: SpinBox = $MarginContainer/VBoxContainer2/VBoxContainer2/HBoxContainer3/VBoxContainer/SpinBoxMinutes
@onready var sb_seconds: SpinBox = $MarginContainer/VBoxContainer2/VBoxContainer2/HBoxContainer3/VBoxContainer2/SpinBoxSeconds
# Label
@onready var minutes_label: Label = $MarginContainer/VBoxContainer2/VBoxContainer2/HBoxContainer3/VBoxContainer/MinutesLabel
@onready var seconds_label: Label = $MarginContainer/VBoxContainer2/VBoxContainer2/HBoxContainer3/VBoxContainer2/SecondsLabel
@onready var until_end_sec_label: Label = $MarginContainer/VBoxContainer2/VBoxContainer2/HBoxContainer5/UntilEndSecondsLabel
# Checkbox
@onready var until_end_sec_cb: CheckBox = $MarginContainer/VBoxContainer2/VBoxContainer2/HBoxContainer5/UntilEndSecondsCB
# Slider
@onready var volume_music_slider: Slider = $MarginContainer/VBoxContainer2/VBoxContainer2/HBoxContainer2/VolumeMusicSlider
@onready var volume_sound_slider: Slider = $MarginContainer/VBoxContainer2/VBoxContainer2/HBoxContainer4/VolumeSoundSlider
# Control
@onready var settings_menu: Control = $SettingsMenu
@onready var circular_progress_bar: Control = $MarginContainer/VBoxContainer2/CircularProgressBar
# MarginContainer
@onready var margin_container: MarginContainer = $MarginContainer

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
	
	# Initialize the status of the edit components
	sb_minutes.get_line_edit().context_menu_enabled = false
	sb_minutes.value = default_minutes
	sb_seconds.get_line_edit().context_menu_enabled = false
	sb_seconds.value = default_seconds
	sb_minutes.visible = false
	sb_seconds.visible = false
	minutes_label.visible = false
	seconds_label.visible = false
	until_end_sec_cb.visible = false
	until_end_sec_label.visible = false

	# Calculate the total seconds
	max_seconds = default_minutes * 60 + default_seconds
	current_seconds = max_seconds
	#$CircularProgressBar.set_max_value(current_seconds)
	circular_progress_bar.set_value(calculate_equivalent_progress(current_seconds))


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
	circular_progress_bar.set_remining_time(minutes_str + ":" + seconds_str)

func stop_timer():
	## Stops the timer, sets as 'false' the timer_is_playing flag and also
	## the property paused in the timer
	timer_is_playing = false
	$Timer.paused = false
	$Timer.stop()
	circular_progress_bar.set_value(calculate_equivalent_progress(max_seconds))
	background_music.stop()
	
func calculate_equivalent_progress(value):
	return (value * 100) / max_seconds

func play_music():
	if background_music.stream:
		if until_end_sec_cb.button_pressed:
			var start_from_second = background_music.stream.get_length() - \
			(default_minutes * 60 + default_seconds)
			background_music.play(start_from_second)
		else:
			background_music.play()
	

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
			play_music()

func _on_timer_timeout():	
	if seconds == 0:
		if minutes > 0:
			minutes -= 1
			seconds = 59
		else:
			stop_timer()
			reset_remaining_time_label()
	elif seconds > 0:
		seconds -= 1
		if seconds == alert_seconds and minutes == 0:
			alert_sound.play()
	current_seconds -= 1
	
	var minutes_str = str(minutes) if minutes >= 10 else "0" + str(minutes)
	var seconds_str = str(seconds) if seconds >= 10 else "0" + str(seconds)
	circular_progress_bar.set_remining_time(minutes_str + ":" + seconds_str)
	circular_progress_bar.set_value(calculate_equivalent_progress(current_seconds))


func _on_pause_button_pressed():
	timer_is_playing = false
	$Timer.paused = true
	background_music.stream_paused = true


func _on_stop_button_pressed():
	stop_timer()
	reset_remaining_time_label()


func _on_edit_button_pressed():
	## Toggles the spinboxes (visible and editable) between true and false
	sb_minutes.visible = !sb_minutes.visible
	sb_minutes.editable = !sb_minutes.editable
	sb_seconds.visible = !sb_seconds.visible
	sb_seconds.editable = !sb_seconds.editable 
	
	minutes_label.visible = !minutes_label.visible
	seconds_label.visible = !seconds_label.visible
	until_end_sec_cb.visible = !until_end_sec_cb.visible
	until_end_sec_label.visible = !until_end_sec_label.visible
	
	
	# Check if the edit menu is not visible and stops the timer in this case
	if !edit_menu_visible:
		stop_timer()		
	
	# Toggle the value of 'edit_menu_visible'
	edit_menu_visible = !edit_menu_visible


func _on_spin_box_minutes_value_changed(value):
	default_minutes = sb_minutes.value
	reset_remaining_time_label()


func _on_spin_box_seconds_value_changed(value):
	default_seconds = sb_seconds.value
	reset_remaining_time_label()


func _on_exit_button_pressed():
	get_tree().quit()


func _on_settings_button_pressed():
	margin_container.visible = false
	settings_menu.set_process(true)
	settings_menu.visible = true


func _on_volume_music_slider_value_changed(value):
	background_music.volume_db = value


func _on_volume_sound_slider_value_changed(value):
	alert_sound.volume_db = value


func _on_settings_menu_back_settings_menu():
	margin_container.visible = true
	settings_menu.visible = false
	
	reset_timer()
	reset_remaining_time_label()


func _on_settings_menu_selected_music_file():
	print(settings_menu.music_path)
	background_music.stream = load(settings_menu.music_path)
	
