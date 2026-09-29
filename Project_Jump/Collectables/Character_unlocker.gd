extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var collect_char = 0
var character_name = ["Red Jelly","Orange Juice","Aqua Wax","Lemon Jelibon"]
onready var ui = get_tree().current_scene.get_node("UI")


# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.texture = load("res://Project_jump/Players/Player"+ str(collect_char+1) + ".png")
	$AnimationPlayer.play("idle")
	
	if str(collect_char) in Globals.unlocked_chars:
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func create_new_timer(wait_time,body):
	var new_timer = Timer.new()
	new_timer.wait_time = wait_time
	new_timer.one_shot = true
	add_child(new_timer)
	new_timer.connect("timeout",self,"New_Timeout",[body])
	new_timer.start()


func _on_Character_unlocker_body_entered(body):
	if body.name == "Player":
		$CollisionShape2D.set_deferred("disabled",true)
		$AnimationPlayer.play("collect")
		create_new_timer(1,body)
		body.move_permision = false
		body.jump_permision = false
		ui.get_node("TouchScreenButton").hide()
		ui.get_node("Blur").show()
		

func New_Timeout(body):
	queue_free()
	if !str(collect_char)in Globals.unlocked_chars:
		Globals.unlocked_chars.append(str(collect_char))
		ui.get_node("New_character/Sprite").texture = load("res://Project_jump/Players/Player"+str(collect_char+1)+".png")
		ui.get_node("New_character/character_name").text = character_name[collect_char]
		ui.get_node("New_character/new_character_Anim").play("New Anim")
		#turn on move,jump permisions,touchsceen and Blur to -------> in UI codes
