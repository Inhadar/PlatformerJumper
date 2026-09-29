extends Node


onready var Character_Buttons = $ScrollContainer/CenterContainer/MarginContainer/HBoxContainer.get_children()


func _ready():
	Globals.load_data()
	update_coin()
	for button in Character_Buttons:
		if !button.name in Globals.unlocked_chars:
			if !button.is_in_group("with_money"):
				button.disabled = true
				button.get_node("TextureRect").modulate = Color(0.34902, 0.34902, 0.34902)
			button.get_node("chain").show()
			
		button.connect("pressed",self,"_Button_Pressed",[button.name,button])
	button_checker()
	$ScrollContainer.item_current_index=Globals.current_character

func button_checker():
	for button in Character_Buttons:
		if button.is_in_group("with_money"):
			if button.name in Globals.unlocked_chars:
				button.get_node("Price").text = "SOLD"
		
		if button.name == str(Globals.current_character):
			button.self_modulate = Color(0.3,0.3,0.3)
			button.set_deferred("dissabled",true)
		else:
			button.self_modulate = Color(1,1,1)
			button.set_deferred("dissabled",false)

func _Button_Pressed(button_name,button):
	if int(button.name) ==$ScrollContainer.item_current_index: #This blocks further purchases from the focused object
		if button.is_in_group("with_money"):
			if !button.name in Globals.unlocked_chars:
				if Globals.coin >= int(button.get_node("Price").text):
					Globals.coin -= int(button.get_node("Price").text)
					Globals.unlocked_chars.append(button.name)
					button.get_node("chain").hide()
					button.get_node("Price").text = "SOLD"
					update_coin()
		if button.name in Globals.unlocked_chars:
			Globals.current_character = int(button_name)
		Globals.save_data()
		button_checker()


func update_coin():
	if Globals.for_now_coin < 1000:
		$Coin_label.text = "Coin: " + str(Globals.for_now_coin)
	elif Globals.for_now_coin > 1000 and Globals.for_now_coin <1000000:
		var coin = round_to_dec(Globals.for_now_coin*0.001,1)
		$Coin_label.text = "Coin: " + (str(coin)) + "K"
	elif Globals.for_now_coin > 1000000 and Globals.for_now_coin <1000000000:
		var coin = round_to_dec(Globals.for_now_coin*0.000001,1)
		$Coin_label.text = "Coin: " + (str(coin)) + "M"
	



#Function for round high coin numbers
func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)


func _on_TextureButton_pressed():
	if Globals.pre_scene != "":
		get_tree().change_scene(Globals.pre_scene)
