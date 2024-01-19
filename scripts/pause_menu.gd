extends Control

func _ready():
	pass

func _on_resume_pressed():
	visible = false 


func _on_save_pressed():
	Global.save_data()
	print("Saved to file")


func _on_quit_pressed():
	get_tree().quit()
