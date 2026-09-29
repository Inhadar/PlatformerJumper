extends KinematicBody2D



export var Fly = false # variable for endless fly

var gravity = 100
var move_speed = 600
var jump_height = 2000
var check_jump = false
var velocity = Vector2.ZERO
var direction_X: int = 1
var direction_Y: int = 1
var touched =false
var stick_the_wall = false
var swp = false
var on_wall = false
var on_floor = false


var speed_boost = false
var fly_boost = false
var inv = false

var wall_perm_for_trmpln = true
var jump_permision = false
var move_permision = true

var dead = false

#export var charcater_1: Texture
#export var charcater_2: Texture
#export var charcater_3: Texture
#export var charcater_4: Texture

#onready var character_set = [1,2,3,4]
var current_character = Globals.current_character


var Speed_Boost = 0
var Fly_Boost = 0
var Shield_Boost= 0

var a = true #stick permision for time one time use
var hook = false


#lift perms
var up_lift = false
var down_lift = false
var lift_perm = false
var target_pos = Vector2.ZERO
var current_lift = null
var turn_of_lifts = true #to stop repeating code
var on_lift

##########
onready var Boost_counter  = get_tree().current_scene.get_node("UI/Boost_bar")


var stoper = false
var current_stoper = Vector2.ZERO


var current_lift_keep_moving_permission = false
export var lift_auto_move_time = 0.3


func _ready():
	fly_boost = Fly
	if fly_boost  == true:
		$AnimationPlayer.play("Fly")
	$Background/ParallaxBackground.show()



func _physics_process(delta):

	
	if velocity.y > 5000:
		if dead == false:
			Globals.pause = true
			Globals.game_over = true
			move_speed = 0
			set_physics_process(false)
			$AnimationPlayer.play("dead_anim")
			dead = true
	#controll()
	if Globals.pause == false:
		
		
		if stoper:
			jump_permision = false
			var t = round(global_position.x)
			var y = round(current_stoper.x)
			if round_to_dec(t/y,2) == 1:
				stoper = false
				move_permision = false
				
				
		check_direction()
		move()
		add_gravity()
		jump()
		check_walls()
		
		var snap = Vector2.DOWN * 32 if !check_jump else Vector2.ZERO
		var stop_on_slope = true if get_floor_velocity().x == 0 else false
		velocity = move_and_slide_with_snap(velocity,snap,Vector2.UP,stop_on_slope,4,deg2rad(60),false)







#Function for round high coin numbers
func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)






func controll(): #This function using for just checking raycasts.Also not necessary
	if Input.is_action_pressed("ui_left"):
		velocity.x = -1000
	if Input.is_action_just_released("ui_left"):
		velocity.x= 0
	if Input.is_action_pressed("ui_right"):
		velocity.x = 1000
	if Input.is_action_just_released("ui_right"):
		velocity.x  =0
	if Input.is_action_pressed("ui_up"):
		velocity.y = -1000
	if Input.is_action_just_released("ui_up"):
		velocity.y  =0
	if Input.is_action_pressed("ui_down"):
		velocity.y = 1000
	if Input.is_action_just_released("ui_down"):
		velocity.y  =0
		
		
		
		
		
func check_direction():
	var dir_casts = [$cast_zone/Right,$cast_zone/Left]
	
	for dc in dir_casts:
		if dc.name == "Left":
			if dc.is_colliding():
				direction_X = 1
				$Sprite.scale.x = -direction_X
		elif dc.name == "Right":
			if dc.is_colliding():
				direction_X = -1
				$Sprite.scale.x = -direction_X



func move():
	if lift_perm == false:
		if on_wall == false and move_permision:
			velocity.x = direction_X * move_speed
		else:
			velocity.x = 0


func add_gravity():
	velocity.y += gravity
	
func jump():
	if lift_perm == false:
		if jump_permision:
			if touched and dead == false:
				if is_on_floor() or fly_boost:
					velocity.y = -jump_height
					check_jump = true
					if on_lift == false:
						touched =false
			else:
				check_jump = false ########!!!!!!!!!!!!! there is not problem for now...
				#this var_ using for Player is_jumping or not.This is necesarry for Slope_run



func check_walls():
	var down
	var up
	var left
	var right 
	
	
	for way in $cast_zone.get_children():
		if way.name in ["L_Down","C_Down","R_Down"]:
			if way.is_colliding():
				down = true
			else:
				if !$cast_zone/C_Down.is_colliding() and !$cast_zone/L_Down.is_colliding() and !$cast_zone/R_Down.is_colliding():
					down = false
		if way.name == "Up":
			if way.is_colliding():
				up = true
			else:
				up = false
		if way.name == "Left":
			if way.is_colliding():
				left = true
			else:
				left = false
		if way.name == "Right":
			if way.is_colliding():
				right = true
			else:
				right = false
	#print(up," / ",down," / ",left," / ",down) ####################!!!!!!
	
	
	if wall_perm_for_trmpln == true:
		if on_wall == false:
			if (left or right) and (down == false and up == false ):
				#if stick_the_wall:   #if you activated this #!!!!!!!!!!!!
					#touched = false  #player dont jump after sticked the wall #!!!!!!!!!!!!
					
					
				if Fly == false:# if you turn of stick wall with fly booster change this var to ---> fly_boost <---
					stick_the_wall = true
					on_wall = true
	else:
		on_wall = false
		stick_the_wall = false
		a = true
		
	
	
	if down:
		on_floor =true
		on_wall= false
		a = true
	else:
		on_floor = false
		
	
	###Wall###
	if stick_the_wall == true:
		velocity =Vector2.ZERO
		if touched:
			move_permision = true
			velocity.y = - jump_height
			velocity.x = move_speed * direction_X
			stick_the_wall = false
			on_wall = false
			touched = false
			a= true
			$Relase_Timer.stop()
		else:
			if a == true:
				$Relase_Timer.start()
				a= false
			#stick_the_wall = false
			
	###Hook### 
	if hook:
		global_position = target_pos
		velocity =Vector2.ZERO
		move_permision = false
		jump_permision = false
		if touched:
			move_permision = true
			velocity.y = - jump_height
			velocity.x = move_speed * direction_X
			hook = false
			on_wall = false
			touched = false
			a= true
			$Relase_Timer.stop()
		else:
			if a == true:
				$Relase_Timer.start()
				a= false
			
	###Lifts activation codes###
	if up_lift or down_lift:
		on_lift = true
		#UP lift
		if up_lift:
			if global_position.x != target_pos.x:
				if turn_of_lifts:
					
					
					if touched:
						velocity = Vector2.ZERO
						global_position.x = target_pos.x
						if current_lift != null:
							pass
							current_lift.get_node("Platform/Coll").set_deferred("disabled",true)
						move_permision = false
						jump_permision = false
						gravity = -10
						touched = false
						lift_perm = true
						turn_of_lifts = false
			else:
				if touched:
					lift_perm = false
					move_permision = true
					jump_permision = true
					if on_floor == false:
						move_speed = 1000
						gravity = 100
						velocity.y = -1500
					#velocity.x = 2000 * direction_X

				
		#Down lift
		if down_lift:
			if global_position.x != target_pos.x:

				if turn_of_lifts:
					if touched:
						velocity = Vector2.ZERO
						global_position.x = target_pos.x
						if current_lift != null:
							current_lift.get_node("Platform/Coll").set_deferred("disabled",true)
							#current_lift.get_node("CollisionShape2D").set_deferred("disabled",true)
						move_permision = false
						jump_permision = false
						gravity = 10
						touched = false
						lift_perm = true
						turn_of_lifts = false

			else:
				
				
				if touched:
					if on_floor:
						lift_perm = false
					else:
						lift_perm = false
						move_permision = true
						jump_permision = true
						move_speed = 600#1000
						gravity = 100
						velocity.y = -1500
						#velocity.x = 2000 * direction_X
				else:
					if on_floor:
						if current_lift_keep_moving_permission:
							lift_perm = false
							move_speed = 600#1000
							gravity = 100
							#velocity.y = -1500
							current_lift_keep_moving_permission = false
							yield(get_tree().create_timer(lift_auto_move_time/2),"timeout")
							move_permision = true
							jump_permision = true
	else:
		on_lift = false
		gravity = 100
		lift_perm = false
		if current_lift_keep_moving_permission:
			current_lift_keep_moving_permission = false
			yield(get_tree().create_timer(lift_auto_move_time),"timeout")
			move_permision = true
			jump_permision =true
			pass



func _on_Relase_Timer_timeout():
	stick_the_wall = false
	hook = false
	velocity.y += 1000





func create_timer(object,wait_time,one_shot): #One Time Timer for Boosts or other things
	var boost_timer = Timer.new()
	add_child(boost_timer)
	boost_timer.wait_time = wait_time
	boost_timer.one_shot = one_shot
	boost_timer.start()
	boost_timer.connect("timeout",self,"_on_Boost_timer_timeout",[boost_timer,object,wait_time])

func _on_Area2D_area_entered(area):
	if area.is_in_group("Speed_Boost"):
		move_speed = 1000
		area.hide()
		area.get_node("CollisionShape2D").set_deferred("disabled",true)
		speed_boost = true
		$Ghost_Timer.start()
		
		
		Speed_Boost = 2
		var wait_time = 0.1
		create_timer(area,wait_time,false)
		
	if area.is_in_group("Fly_Boost"):
		fly_boost =true
		area.hide()
		area.get_node("CollisionShape2D").set_deferred("disabled",true)
		
		Fly_Boost = 2.5
		var wait_time = 0.1
		create_timer(area,wait_time,false)
		
	if area.is_in_group("Inv_Boost"):
		area.hide()
		area.get_node("CollisionShape2D").set_deferred("disabled",true)
		inv = true
		
		Shield_Boost = 2
		var wait_time = 0.1
		create_timer(area,wait_time,false)
		
	if area.is_in_group("Spike"):
		if inv == false:
			if dead == false:
				Globals.pause = true
				Globals.game_over = true
				move_speed = 0
				set_physics_process(false)
				$AnimationPlayer.play("dead_anim")
				dead = true

	if area.get_parent().is_in_group("Trampoline"):
		area.get_parent().get_node("AnimatedSprite").frame = 0
		area.get_parent().get_node("AnimatedSprite").play("active")
		velocity.y = -2800
		var wait_time = 0.3
		wall_perm_for_trmpln = false
		create_timer(area.get_parent(),wait_time,true)
		
	if area.get_parent().is_in_group("OTP"):
		var wait_time = 0.5
		create_timer(area.get_parent(),wait_time,true)
	
	if area.is_in_group("Star"):
		area.queue_free()
		Globals.for_now_collected_star.append(area.name)
		get_tree().current_scene.get_node("UI").update_ui_star(area.name)
		#print(Globals.for_now_collected_star)
   
	if area.is_in_group("Coin"):
		area.queue_free()
		Globals.for_now_coin += 1
	
	if area.is_in_group("Stoper"):
		jump_permision = false
		stoper =true
		current_stoper = area.global_position
			
		
		
	if area.is_in_group("Hook"):
		hook  = true
		target_pos = area.global_position
		
	if area.is_in_group("UPL"):
		up_lift = true
		target_pos = area.global_position
		current_lift = area
		#area.get_node("Platform/Coll").set_deferred("disabled",true)
		current_lift_keep_moving_permission = area.keep_moving
	if area.is_in_group("DOWNL"):
		current_lift_keep_moving_permission = area.keep_moving
		area.get_node("Activator/CollisionShape2D").set_deferred("disabled",true)
		#down_lift = true
		#target_pos = area.global_position
		#current_lift = area
		#area.get_node("Platform/Coll").set_deferred("disabled",false)
	if area.is_in_group("DLA"):
		down_lift = true
		target_pos = area.get_parent().global_position
		current_lift = area.get_parent()
		area.get_parent().get_node("Platform/Coll").set_deferred("disabled",false)
		#down_lift_perm = true
	
	if area.is_in_group("TSL"):# I dont delete old codes for future but for now this is not necesarry
		current_lift_keep_moving_permission = area.keep_moving
		pass
		#area.get_node("Up_activator/CollisionShape2D").set_deferred("disabled",false)
		#area.get_node("Down_activator/CollisionShape2D").set_deferred("disabled",false)
		#down_lift = true
		#target_pos = area.get_parent().global_position
		#current_lift = area.get_parent()
		#area.get_parent().get_node("Platform/Coll").set_deferred("disabled",false)
		#down_lift_perm = true
	if area.is_in_group("TSUPL"):
		up_lift = true
		area.get_parent().get_node("Platform/Coll").set_deferred("disabled",true)
		#area.get_parent().get_node("Down_activator/CollisionShape2D").set_deferred("disabled",true)
		target_pos = area.get_parent().global_position
		current_lift = area.get_parent()
	if area.is_in_group("TSDOWNL"):
		down_lift = true
		#area.get_parent().get_node("Platform/Coll").set_deferred("disabled",true)
		area.get_parent().get_node("Up_activator/CollisionShape2D").set_deferred("disabled",true)
		target_pos = area.get_parent().global_position
		current_lift = area.get_parent()

func _on_Area2D_area_exited(area):
	if area.is_in_group("Stoper"):
		jump_permision = true
		stoper = false
	if area.is_in_group("TSL"):
		up_lift = false
		down_lift = false
		current_lift = null
		turn_of_lifts =true
		#velocity = Vector2.ZERO
		move_speed = 600
		jump_height = 2000
	#	move_permision = false
	#	jump_permision = false
	#	gravity = 100
		area.get_node("Platform/Coll").set_deferred("disabled",false)
		area.get_node("Up_activator/CollisionShape2D").set_deferred("disabled",false)
		area.get_node("Down_activator/CollisionShape2D").set_deferred("disabled",false)
		
		
	if area.is_in_group("DOWNL"):
		down_lift = false
		current_lift = null
		turn_of_lifts = true
		move_speed = 600
		jump_height = 2000
		area.get_node("Platform/Coll").set_deferred("disabled",false)
		area.get_node("Activator/CollisionShape2D").set_deferred("disabled",false)
	
	if area.is_in_group("UPL"):
		print("AAAAAA")
		up_lift = false
		current_lift = null
		turn_of_lifts =true
		move_speed = 600
		jump_height = 2000
	#	move_permision = false
	#	jump_permision = false
	#	gravity = 100
		area.get_node("Platform/Coll").set_deferred("disabled",false)
		
		
func _on_Boost_timer_timeout(timer,area,wait_time):
	if area.is_in_group("Speed_Boost"):
		if Speed_Boost <= 0:
			move_speed = 700
			speed_boost = false
			timer.stop()
			Boost_counter.hide()
			Speed_Boost = 0
		else:
			Boost_counter.show()
			Speed_Boost -= wait_time
		Boost_counter.get_node("BC").text = area.name + " / " + str(abs(Speed_Boost))
	if area.is_in_group("Fly_Boost"):
		if Fly_Boost <= 0:
			if Fly == false:
				fly_boost=false
			timer.stop()
			Boost_counter.hide()
			Fly_Boost = 0
		else:
			Boost_counter.show()
			Fly_Boost -= wait_time
		Boost_counter.get_node("BC").text = area.name + " / " + str(abs(Fly_Boost))
	if area.is_in_group("Inv_Boost"):
		if Shield_Boost <= 0:
			inv = false
			timer.stop()
			Boost_counter.hide()
			Shield_Boost = 0
		else:
			Boost_counter.show()
			Shield_Boost -= wait_time
		Boost_counter.get_node("BC").text = area.name + " / " + str(abs(Shield_Boost))
	if area.is_in_group("OTP"):
		area.queue_free()
		#$Label.text = area.name + " / " + str(wait_time)
	if area.is_in_group("Trampoline"):
		wall_perm_for_trmpln = true
	if area.is_in_group("Hook"):
		on_wall = false
		Globals.pause = false
		stick_the_wall = false
func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().current_scene.get_node("UI").You_lose()
	#var _restart = get_tree().reload_current_scene()

#Ghost_efffect_timer
func _on_Ghost_Timer_timeout():
	if speed_boost == true and dead == false:
		var player = current_character+1
		var this_ghost = preload("res://Effects/Ghost.tscn").instance()
		this_ghost.global_position = $Sprite.global_position
		this_ghost.scale = scale
		this_ghost.scale.x *= -direction_X
		this_ghost.texture = load("res://Project_jump/Players/Player"+str(current_character+1)+".png")#character_set[current_character]
		get_parent().add_child(this_ghost)


