extends Control

func _ready():
	pass
	
	


func _on_resume_pressed():
	visible = false 
	get_tree().paused = false


func _on_save_pressed():
	Global.save_data()
	print("Saved to file")


func _on_quit_pressed():
	get_tree().paused = false
	get_tree().quit()


func _on_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
