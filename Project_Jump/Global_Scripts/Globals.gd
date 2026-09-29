extends Node


#Controls 
var touch = false


var pre_scene = "" #varible for back to pre scene

#Game pause variables
var pause 
var game_over


#Level vars
var unclocked_levels = {"Level_set_1":[1]}
var curren_level_set = "" 
var current_level = 0
var set_size = {} #Size of all Level sets
var next_level = ""


#Star wars
var for_now_collected_star = []
var collected_star = {}
var current_old_collected_star = []


#Charcater vars
var unlocked_chars = ["0"]
var current_character: int = 0


#Checkpoint vars
var checked_level = {}



#Coin vars
var for_now_coin:int = 0
var coin: int = 0

#save_files
var data_save = "user://data_save.save"

func save_data():
	var savedata = File.new()
	savedata.open(data_save,File.WRITE)
	savedata.store_var(coin)
	savedata.store_var(unclocked_levels)
	savedata.store_var(collected_star)
	savedata.store_var(current_character)
	savedata.store_var(unlocked_chars)
	savedata.close()

func load_data():
	var loaddata = File.new()
	if loaddata.file_exists(data_save):
		loaddata.open(data_save,File.READ)
		coin = loaddata.get_var()
		unclocked_levels = loaddata.get_var()
		collected_star = loaddata.get_var()
		current_character = loaddata.get_var()
		unlocked_chars = loaddata.get_var()
		loaddata.close()
