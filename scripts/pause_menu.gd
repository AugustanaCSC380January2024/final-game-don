extends Control
@onready var save_file
func _ready():
	save_file = Global.get_global_data()
	$Resume.grab_focus()


func _on_resume_pressed():
	visible = false 
	get_tree().paused = false


func _on_save_pressed():
	if save_file.level_num <=3:
		Global.save_data()
	


func _on_quit_pressed():
	get_tree().paused = false
	get_tree().quit()


func _on_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
