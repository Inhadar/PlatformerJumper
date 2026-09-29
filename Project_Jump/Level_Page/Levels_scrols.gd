extends ScrollContainer

export(float, 0.5,1,0.1) var item_scale = 1
export(float, 0.5,1.5,0.1) var item_current_scale = 1.3
export(float, 0.1,1,0.1) var scroll_duration =1.3
var item_current_index: int = 0
var item_x_positions: Array = []




onready var scroll_tween: Tween = Tween.new()
onready var margin_r: int = $CenterContainer/MarginContainer.get("custom_constants/margin_right")
onready var item_space: int = $CenterContainer/MarginContainer/HBoxContainer.get("custom_constants/separation")
onready var item_nodes: Array = $CenterContainer/MarginContainer/HBoxContainer.get_children()



func _ready():
	#1st settings
	add_child(scroll_tween)
	yield(get_tree(),"idle_frame")
	get_h_scrollbar().modulate.a = 0 
	
	#seting level_sets positions
	for _item in item_nodes:
		var item_pos_x: float = (margin_r + _item.rect_position.x) - ((self.rect_size.x - _item.rect_size.x)/2)
		_item.rect_pivot_offset = (_item.rect_size/2)
		item_x_positions.append(item_pos_x)
	
	scroll_horizontal = item_x_positions[item_current_index] #The first item seen when the page is opened
	
	scroll()
	var c=0
	for a in item_nodes:
		#print(a.name)
		for d in a.get_children():
			c +=1
			d.get_node("Label").text = str(c)
			if c == a.get_children().size():
				c=0

func _process(_delta:float) -> void:
	for index in range(item_x_positions.size()):
		var item_pos_x: float = item_x_positions[index]
		#warning-ignore: integer_division
		var swipe_length: float = ((item_nodes[index].rect_size.x/2)+(item_space/2))
		var swipe_current_length:float = abs(item_pos_x - scroll_horizontal)
		
		var now_item_scale: float = range_lerp(swipe_current_length,swipe_length,0,item_scale,item_current_scale)
		var now_item_opacity: float = range_lerp(swipe_current_length,swipe_length,0,0.3,1)
		now_item_scale = clamp(now_item_scale,item_scale,item_current_scale)
		now_item_opacity =clamp(now_item_opacity,0.3,1)
		
		item_nodes[index].rect_scale = Vector2(now_item_scale,now_item_scale)
		item_nodes[index].modulate.a = now_item_opacity
		
		if swipe_current_length < swipe_length:#/swipe_sensitivity:
			item_current_index = index
			get_parent().dot_pressed = false

func scroll() -> void:
	var _tween = scroll_tween.interpolate_property(self,"scroll_horizontal",scroll_horizontal,item_x_positions[item_current_index],scroll_duration,Tween.TRANS_BACK,Tween.EASE_OUT)
	
	
	for index in range(item_nodes.size()):
		var _item_scale: float = item_current_scale if index == item_current_index else item_scale
		var _tween2 = scroll_tween.interpolate_property(item_nodes[index],"rect_scale",item_nodes[index].rect_scale,Vector2(_item_scale,_item_scale),scroll_duration,Tween.TRANS_QUAD,Tween.EASE_OUT)
	var _tween3 = scroll_tween.start()

func _on_ScrollContainer_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			var _tween = scroll_tween.stop_all()
		else:
			scroll()
