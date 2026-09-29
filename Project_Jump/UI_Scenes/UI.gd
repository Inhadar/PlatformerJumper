extends CanvasLayer



onready var Player = get_tree().current_scene.get_node("Player")
var star_permission = true
func _ready():
	update_ui_star("")
	
	#$Pause_area/Pause_button.connect("focus_entered",self,"Mouse_enter")
	#$Pause_area/Pause_button.connect("focus_exited",self,"Mouse_exit")
	
	#$Pause_area/Pause_button.connect("button_down",self,"Button_Down")
	#$Pause_area/Pause_button.connect("mouse_exited",self,"Mouse_exit")
	
	for gob in $Game_over_menu/Buttons.get_children():
		gob.get_node("TextureButton").connect("pressed",self,gob.name)
	for pmb in $Pause_area/Pause_menu.get_children():
		pmb.connect("pressed",self,pmb.name)



func Resume():
	Unpaused()
func Restart():
	get_tree().reload_current_scene()
func Menu():
	get_tree().change_scene("res://Menues/Main_Menu/Main_Menu.tscn")
func Next():
	get_tree().change_scene(Globals.next_level)
func Shop():
	Globals.pre_scene = "res://Level_sets/"+Globals.curren_level_set +"/"+  get_tree().current_scene.name + ".tscn"
	get_tree().change_scene("res://Shop_Page/Shop.tscn")


func You_win():
	$Blur.show()
	var star_time = 0
	$Test_Label.hide()
	$Coin.hide()
	$Pause_area.hide()
	$Game_over_menu/You_Win.text = "You Win!"
	$Game_over_menu/Control/Level_number.text = str(int(Globals.current_level)-1) 
	$Game_over_menu/Coins.text = "Coins: " + str(Globals.coin)
	$Game_over_menu.show()
	for star in $Game_over_menu/Stars_Bar.get_children():
		if Globals.curren_level_set in Globals.collected_star.keys():
			if get_tree().current_scene.name in Globals.collected_star[Globals.curren_level_set].keys():
				if star.name in Globals.collected_star[Globals.curren_level_set][get_tree().current_scene.name]:

					if !star.name in Globals.current_old_collected_star:
						#if len(Globals.collected_star[Globals.curren_level_set][get_tree().current_scene.name])<3:
						star_time += 0.3
						ott(star_time,star)
						#print(star.name)
					else:
						star.modulate = Color(1,1,1)
						
func You_lose():
	$Blur.show()
	var star_time = 0
	$Test_Label.hide()
	$Coin.hide()
	$Pause_area.hide()
	$Game_over_menu/Buttons/Next.hide()
	$Game_over_menu/You_Win.text = "You Lose!"
	$Game_over_menu/Control/Level_number.text = str(int(Globals.current_level)-1) 
	$Game_over_menu/Coins.text = "Coins: " + str(Globals.coin)
	$Game_over_menu.show()
	for star in $Game_over_menu/Stars_Bar.get_children():
		if Globals.curren_level_set in Globals.collected_star.keys():
			if get_tree().current_scene.name in Globals.collected_star[Globals.curren_level_set].keys():
				if star.name in Globals.collected_star[Globals.curren_level_set][get_tree().current_scene.name]:
					star_time += 0.2
					ott(star_time,star)
					
func ott(time,obj):
	var new_timer = Timer.new()
	new_timer.one_shot =true
	new_timer.wait_time = time 
	add_child(new_timer)
	new_timer.connect("timeout",self,"_OTT",[obj])
	new_timer.start()
func _OTT(obj):
	obj.modulate = Color(1,1,1)

func Paused():
	$Blur.show()
	if Globals.pause == false:
		Globals.pause = true
	$Test_Label.hide()
	$Coin.hide()
	#Pause Level name
	$Pause_area/Pause_button.hide()
	$Pause_area/Pause_menu.show()
	$TouchScreenButton.hide()
func Unpaused():
	
	$Blur.hide()
	Globals.pause = false
	$Test_Label.show()
	$Coin.show()
	#Pause level name
	$Pause_area/Pause_button.show()
	$Pause_area/Pause_menu.hide()
	$TouchScreenButton.show()



func update_ui_star(now_collected_star):
	for ui_star in $Score_Bar/stars.get_children():
		if Globals.collected_star.get(Globals.curren_level_set) != null:
			if Globals.collected_star[Globals.curren_level_set].get(get_tree().current_scene.name) != null:
				if ui_star.name in Globals.collected_star[Globals.curren_level_set][get_tree().current_scene.name]:
					ui_star.modulate = Color(1,1,1)
		if ui_star.name == now_collected_star:
			ui_star.modulate = Color(1,1,1)
			
			
			
func _on_TouchScreenButton_pressed():
	#if Player.is_inside_tree():
	Player.touched = true
	if Globals.pause == false and Player.on_floor: #if you turn off Player.on_floor// 
		if Player.move_permision == true:#//When touched screen Player start move on air
			Player.jump_permision = true
		Player.move_permision = true
		pass
	if Globals.pause == true and Globals.game_over ==false:
		Globals.pause = false
func _on_TouchScreenButton_released():
	#if Player.is_inside_tree():
		Player.touched = false


func _on_new_character_Anim_animation_finished(anim_name):
	$TouchScreenButton.show()
	$Blur.hide()
	get_parent().get_node("Player").move_permision = true
	get_parent().get_node("Player").jump_permision = true
