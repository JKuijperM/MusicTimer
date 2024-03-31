class_name SettingsMenu
extends Control

@onready var back_button: Button = $MarginContainer/VBoxContainer/BackButton
@onready var file_dialog: FileDialog = $FileDialog
@onready var music_line_edit: LineEdit = $MarginContainer/VBoxContainer/HBoxContainer/BacgroundMusicLineEdit

var music_path: String

signal back_settings_menu
signal selected_music_file

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)

func _on_back_button_pressed():
	back_settings_menu.emit()
	set_process(false)


func _on_select_music_button_pressed():
	file_dialog.popup()


func _on_file_dialog_file_selected(path):
	music_line_edit.text = path.split('/')[-1]
	music_path = path
	
	selected_music_file.emit()
	
