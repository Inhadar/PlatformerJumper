extends Area2D

export var keep_moving = false



func _ready():
	if !keep_moving:
		$Platform/Sprite/AnimatedSprite.stop()
		$Platform/Sprite/AnimatedSprite.hide()
	else:
		$Platform/Sprite/AnimatedSprite.show()
		$Platform/Sprite/AnimatedSprite.play("default")


#func _ready():
	#$Glass.z_index = 2
	#$Glass.modulate =Color(1, 1, 1, 0.7)
func _physics_process(delta):
	if $Platform/Coll.disabled == true:
#		$Glass.show()
		$Platform/Sprite.modulate = Color(0.45, 0.45, 0.45)
		#$Platform/Sprite.hide()
	else:
#		$Glass.hide()
		$Platform/Sprite.modulate = Color(1,1,1)
		#$Platform/Sprite.show()
