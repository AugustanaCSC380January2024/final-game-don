extends Control


func _on_retry_pressed():
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/menu.tscn") 
	



func _on_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn") 
