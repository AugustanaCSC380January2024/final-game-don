extends Control

var one_player_mode = false
var two_player_mode = false
var resume = false

signal player_mode_selected()

func _on_player_pressed():
	print("One player mode pressed")
	one_player_mode = true
	emit_signal("player_mode_selected")
	print("One player mode selected")

func _on_player_2_pressed():
	two_player_mode = true
	emit_signal("player_mode_selected")


func _on_exit_pressed():
	get_tree().quit()


func _on_resume_pressed():
	pass # Replace with function body.
