extends Node2D

@onready var sound = get_tree().get_current_scene().get_node("SFX");
@onready var buttons = [$CanvasLayer/Home/R0];
var isActive = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	if(Music.volume < -30):
		Music.changeSong("menu")
		Music.FadeSong(true);
	for i in buttons.size():
		buttons[i].modulate = Color(0.6, 0.6, 0.6)
	generateLevels(10);
	await get_tree().create_timer(0.5).timeout
	isActive = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(isActive):
		for i in buttons.size():
			if(buttons[i].ishovering && buttons[i].isAvailable):
				if(buttons[i].modulate == Color(0.6, 0.6, 0.6)):
					sound.playsound("hover", 1, 1.3)
				buttons[i].modulate = Color(1, 1, 1)
				buttons[i].scale = lerp(buttons[i].scale, Vector2(1.2, 1.2), delta * 15)
				
				if Input.is_action_just_released("ClickL"):
					SelectButton(i);
			else:
				buttons[i].modulate = Color(0.6, 0.6, 0.6)
				buttons[i].scale = lerp(buttons[i].scale, Vector2(1, 1), delta * 15)
	pass
	
func SelectButton(button):
	isActive = false
	if(button != 0): Music.FadeSong(false);
	get_node("CanvasLayer/Transition").start(true);
	await get_tree().create_timer(0.5).timeout
	if(button == 0):
			get_tree().change_scene_to_file("res://Scenes/GameScenes/TitleMenu.tscn")
	else:
		get_tree().change_scene_to_file("res://Scenes/GameScenes/S"+ str(button) +".tscn")
	pass
	
func generateLevels(amount):
	for i in amount:
		var p = load("res://Scenes/GameAssets/level.tscn");
		var ins = p.instantiate();
		var yval = 207;
		var numb = str(i + 1);
		if(numb.length() > 1):
			ins.get_child(0).get_child(2).visible = true
			ins.get_child(0).get_child(2).frame = int(numb.left(1)) - 1;
			ins.get_child(0).get_child(1).position.x += 17;
		ins.get_child(0).get_child(1).frame = i; # LEVEL NUMBER
		ins.get_child(0).get_child(0).frame = SaveData.saveVal[i]; # RATING VALUE
		if(i > 0 && SaveData.saveVal[i-1] == 0):
			ins.get_child(0).isAvailable = false;
		ins.name = str(i);
		if i > 4:
			yval += 210
			i -= 5;
		ins.position = Vector2(113 + (210 * i), yval)
		buttons.append(ins.get_child(0));
		$CanvasLayer.add_child(ins);
	pass
