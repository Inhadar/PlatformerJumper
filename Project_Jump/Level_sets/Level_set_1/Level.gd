extends Node



func _ready():
	Globals.load_data()
	Globals.current_old_collected_star.clear()
	Globals.game_over = false
	Globals.pause =true
	$TileMap.z_index = 10
	$Back.queue_free()####!!!!!!!!!
	$Level.queue_free()####!!!!!!!!!
	$Level2.queue_free()####!!!!!!!!!
	$ColorRect.queue_free()####!!!!!!!!!
	
	
	
	
	$Player/Sprite.texture = load("res://Project_jump/Players/Player"+ str(Globals.current_character+1) +".png")#$Player.character_set[Globals.current_character]
	$Player/Sprite/Sprite2.texture = load("res://Project_jump/Players/Player"+ str(Globals.current_character+1) +".png")#$Player.character_set[Globals.current_character]
	
	
	Globals.for_now_coin = Globals.coin
	
	if CheckpointS.last_position != null:
		$Player.global_position = CheckpointS.last_position
	
	Globals.for_now_collected_star.clear()
	
	
	$Level.text = Globals.curren_level_set + "/" +get_tree().current_scene.name
	$Back.connect("focus_entered",self,"_on_Back_mouse_entered")
	$Back.connect("focus_exited",self,"_on_Back_mouse_exited")
	
	for star in $Areas/Star_set.get_children():
		if Globals.curren_level_set in Globals.collected_star.keys():
			if get_tree().current_scene.name in Globals.collected_star[Globals.curren_level_set].keys():
				if star.name in Globals.collected_star[Globals.curren_level_set][get_tree().current_scene.name]:
					star.queue_free()
	
	
	$UI/Pause_area/Pause_button.connect("pressed",self,"Pause_Button_Pressed")




func _process(delta):
	move_on()
	if Globals.curren_level_set in Globals.collected_star:
		if get_tree().current_scene.name in Globals.collected_star[Globals.curren_level_set]:
			$UI/Test_Label.text = str(Globals.for_now_collected_star) #str(Globals.collected_star[Globals.curren_level_set][get_tree().current_scene.name])
	
	
	if Globals.for_now_coin < 1000:
		$UI/Coin.text = "Coin: " + str(Globals.for_now_coin)
	elif Globals.for_now_coin > 1000 and Globals.for_now_coin <1000000:
		var coin = round_to_dec(Globals.for_now_coin*0.001,1)
		$UI/Coin.text = "Coin: " + (str(coin)) + "K"
	elif Globals.for_now_coin > 1000000 and Globals.for_now_coin <1000000000:
		var coin = round_to_dec(Globals.for_now_coin*0.000001,1)
		$UI/Coin.text = "Coin: " + (str(coin)) + "M"
	
	$UI/Fps.text = "FPS: " + str(Engine.get_frames_per_second())



#Function for round high coin numbers
func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)






func move_on():
	if Globals.touch == true:
		Globals.pause =false
		
			
func _on_Back_pressed():
	get_tree().change_scene("res://Menues/Main_Menu/Main_Menu.tscn")

func _on_Gate_body_entered(body):
	
	if body.name == "Player":

		
		###################
		
		Globals.game_over = true
		###################
		
		CheckpointS.last_position = null
		CheckpointS.previous_postion = null
		Globals.coin = Globals.for_now_coin
		

		var cs= Globals.current_level
		var cls = Globals.curren_level_set
		var current_scene = get_tree().current_scene
		var collected_star = Globals.collected_star
		var for_now_stars = Globals.for_now_collected_star
		
		
		#Check the stars before collecting new stars
		if Globals.curren_level_set in Globals.collected_star.keys():
			if get_tree().current_scene.name in Globals.collected_star[Globals.curren_level_set]:
				
				
				for old_star in Globals.collected_star[Globals.curren_level_set][get_tree().current_scene.name]:
					Globals.current_old_collected_star.append(old_star)
				print("first set cocs:",Globals.current_old_collected_star)
		
		###check collected star
		if cls in Globals.collected_star:
			if current_scene.name in collected_star[cls]:
				
				if for_now_stars != []:
					for star in for_now_stars:
						if not star in collected_star[cls][current_scene.name]:
							collected_star[cls][current_scene.name].append(star)
			else:
				
				collected_star[cls][current_scene.name] = []
				if for_now_stars != []:
					for star in for_now_stars:
						if not star in collected_star[cls][current_scene.name]:
							collected_star[cls][current_scene.name].append(star)
		else:

			
			collected_star[cls] = {}
			collected_star[cls][current_scene.name] = []
			if for_now_stars != []:
				for star in for_now_stars:
					if not star in collected_star[cls][current_scene.name]:
						collected_star[cls][current_scene.name].append(star) # Globals.collected_star[Globals.curren_level_set][get_tree().current_scene.name].append("star1")
		
		
		
		
		
		##Save complate level and calcute new level and world
		if int(Globals.current_level) < Globals.set_size[Globals.curren_level_set]:
			var c = str(int(Globals.current_level)+1)
			Globals.next_level = "res://Level_sets/"+Globals.curren_level_set+"/Level_"+c+".tscn"
			#get_tree().change_scene("res://Level_sets/"+Globals.curren_level_set+"/Level_"+c+".tscn")
			Globals.current_level= c
			if Globals.curren_level_set in Globals.unclocked_levels.keys():
				Globals.unclocked_levels[Globals.curren_level_set].append(int(c))
				
				#print(Globals.unclocked_levels)
			
		else:

			var c = Globals.curren_level_set
			for i in range(0,10):
				c[0] = ""
				
			if int(c) < len(Globals.set_size): 
				c = "Level_set_"+str(int(c) + 1)
				Globals.curren_level_set = c
				Globals.next_level = "res://Level_sets/"+c+"/Level_1.tscn"
				#get_tree().change_scene("res://Level_sets/"+c+"/Level_1.tscn")
				#print(Globals.curren_level_set)
				if Globals.curren_level_set in Globals.unclocked_levels.keys():
					Globals.unclocked_levels[Globals.curren_level_set].append(int(c))
					Globals.current_level= "1"
				else:
					Globals.unclocked_levels[c] = [1]
					#print(Globals.unclocked_levels)
					Globals.current_level= "1"
					

		Globals.pause = true
		$UI.You_win()
		Globals.save_data()

func _on_Back_mouse_entered():
	$Player.back_button = true
	$Player.set_physics_process(false)
	#print("a")

func _on_Back_mouse_exited():
	$Player.back_button = false
	$Player.set_physics_process(true)
	#print("a")


func Pause_Button_Pressed():
	$UI.Paused()
