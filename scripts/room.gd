extends RigidBody2D

var size 

func make_room(_pos, _size):
	position = _pos
	size = _size
	var s = RectangleShape2D.new()
	s.custom_solver_bias = .75
	s.extents = size
	$CollisionShape2D.shape = s
	
func collisionEnable(enable: bool):
	if enable == true:
		$CollisionShape2D.disabled = false
	if enable == false:
		$CollisionShape2D.disabled = true
