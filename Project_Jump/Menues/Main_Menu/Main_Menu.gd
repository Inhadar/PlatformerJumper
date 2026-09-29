extends CanvasLayer

var tween = Tween.new()
const SHINE_TIME = 1
#onready var sprite = $Menu/Control/Levels

func _ready():
	
	add_child(tween)
	

func _on_Shine_Loop_timeout():
	$Shine_Loop.wait_time = 5
	for sprite in $Menu/Control.get_children():
		
		tween.interpolate_property(sprite.material, "shader_param/shine_progress", 
		1.0, 0.0, SHINE_TIME, Tween.TRANS_SINE, Tween.EASE_IN)
		tween.interpolate_property(sprite.material, "shader_param/shine_size", 
		0.13, 0.01, SHINE_TIME * 0.75, Tween.TRANS_CUBIC, Tween.EASE_IN, 
		SHINE_TIME * .25)
		
		"""
		tween.interpolate_property(sprite.material, "shader_param/shine_progress", 
		0.0, 1.0, SHINE_TIME, Tween.TRANS_SINE, Tween.EASE_OUT, SHINE_TIME)
		tween.interpolate_property(sprite.material, "shader_param/shine_size", 
		null, 0.13, SHINE_TIME * 0.75, Tween.TRANS_CUBIC, Tween.EASE_OUT, 
		SHINE_TIME * .25 + SHINE_TIME)
		"""
	tween.start()






func _on_Button_pressed():
	get_tree().change_scene("res://Level_Page/Level_Sets.tscn")

func _on_Quit_pressed():
	get_tree().quit()

func _on_Shop_pressed():
	Globals.pre_scene = "res://Menues/Main_Menu/Main_Menu.tscn"
	get_tree().change_scene("res://Shop_Page/Shop.tscn")


