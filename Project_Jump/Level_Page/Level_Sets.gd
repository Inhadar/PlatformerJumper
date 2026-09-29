extends Node

var unclocked_levels = Globals.unclocked_levels
var collected_star = Globals.collected_star

onready var level_sets = $ScrollContainer/CenterContainer/MarginContainer/HBoxContainer.get_children()

var dot_pressed = false


func _ready():
	
	Globals.load_data()
	#print(Globals.collected_star)
	#print(Globals.unclocked_levels)
	#print(Globals.coin)
	unclocked_levels = Globals.unclocked_levels
	collected_star = Globals.collected_star
	for dot in $ScrollContainer2/CenterContainer/MarginContainer/HBoxContainer.get_children():
		dot.connect("pressed",self,"_Dot_Pressed",[dot.name]) 
		
		
	for set in level_sets:
		Globals.set_size[set.name] = set.get_child_count()
	
	
	
	
	#Auto connect levels button 
	for a in level_sets:
		for b in a.get_children():
			b.connect("pressed", self, "_on_Level_Button_pressed",[a.name,b.name])
			
			#Changing color unlocked 
			if a.name in unclocked_levels.keys():
				if int(b.name) in unclocked_levels[a.name]:
					b.modulate = Color(1,1,1)
			
			
			#Changing color collected stars 
			if a.name in collected_star.keys():
				if "Level_"+b.name in collected_star[a.name]:
					for star in b.get_node("Star_set").get_children():
						if star.name in collected_star[a.name]["Level_"+b.name]:
							star.modulate = Color(1,1,1)

func _process(_delta):
	if dot_pressed == false:
		$ScrollContainer2.item_current_index = $ScrollContainer.item_current_index
		$ScrollContainer2.scroll()

func _on_Button_pressed():
	get_tree().change_scene("res://Menues/Main_Menu/Main_Menu.tscn")

func _on_Level_Button_pressed(level_set_name,level_name):
	unclocked_levels = Globals.unclocked_levels
	#print(level_set_name,"/",level_name)
	Globals.current_level = level_name
	if level_set_name in unclocked_levels.keys():
		if int(level_name) in unclocked_levels[level_set_name]:
			get_tree().change_scene("res://Level_sets/" + level_set_name + "/Level_" + level_name + ".tscn")
			Globals.curren_level_set = level_set_name
			CheckpointS.last_position = null
			CheckpointS.previous_postion = null
		else:
			print("level do not yet unlocked")
	else:
			print("Wordl do not yet unlocked")

func _on_Back_pressed():
	get_tree().change_scene("res://Menues/Main_Menu/Main_Menu.tscn")

func _Dot_Pressed(dot_name):
	dot_pressed = true# Go to ScrollContainer _process() function for setting false this value
	$ScrollContainer.item_current_index = int(dot_name)
	$ScrollContainer.scroll()



func _on_CheckBox_toggled(button_pressed):
	if button_pressed:
		Globals.unclocked_levels = {"Level_set_1":[1,2,3,4,5,6,7,8,9],"Level_set_2":[1,2,3,4,5,6,7,8,9],"Level_set_3":[1,2,3,4,5,6,7,8,9]}
		
		for level_set in level_sets:
			for level in level_set.get_children():
				#level.disabled =false
				level.modulate = Color(1,1,1)
	else:
		Globals.unclocked_levels = {"Level_set_1":[1]}
		for level_set in level_sets:
			for level in level_set.get_children():
				if level_set.name in Globals.unclocked_levels.keys():
					if int(level.name) in Globals.unclocked_levels[level_set.name]: 
						pass
					else:
						level.modulate = Color(0.388235, 0.388235, 0.388235)
				else:
					#level.disabled =true
					level.modulate = Color(0.388235, 0.388235, 0.388235)
		
