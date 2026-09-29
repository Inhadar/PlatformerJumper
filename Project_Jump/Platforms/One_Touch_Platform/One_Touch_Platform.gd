extends StaticBody2D


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		var timer = Timer.new()
		add_child(timer)
		timer.wait_time = 0.5
		timer.connect("timeout",self,"_Timeout")
		timer.start()
		
func _Timeout():
	queue_free()
