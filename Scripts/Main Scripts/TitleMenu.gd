extends Node2D

@onready var sprites = [$CanvasLayer/Info/R0, $CanvasLayer/Play/R0, $CanvasLayer/Levels/R0];
@onready var buttons = [$CanvasLayer/Info, $CanvasLayer/Play, $CanvasLayer/Levels];
@onready var cam = $Cam;
@onready var sound = get_tree().get_current_scene().get_node("SFX");
var isActive = true
# Called when the node enters the scene tree for the first time.
func _ready():
	if(!Music.playing):
		Music.changeSong("menu")
		Music.FadeSong(true);
	#get_node("CanvasLayer/Transition").start(false);
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Mute"):
		if(Music.volume_db == -15): Music.volume_db = -80;
		else:  Music.volume_db = -15;
	if Input.is_action_just_pressed("debugKey"):
		SaveData.saveVal = [3, 3, 3, 3, 3, 3, 3, 3, 3, 3]
		
	var mouse = get_viewport().get_mouse_position();
	var winSize = get_viewport().size
	if(mouse > Vector2(0, 0) && mouse < Vector2(winSize) && mouse.y > 0 && mouse.y < winSize.y): 
		cam.position = mouse;
	if(isActive):
		for i in sprites.size():
			if(sprites[i].ishovering):
				if(sprites[i].modulate == Color(0.6, 0.6, 0.6)):
					sound.playsound("hover", 1, 1.3)
				sprites[i].modulate = Color(1, 1, 1)
				sprites[i].scale = lerp(sprites[i].scale, Vector2(1.2, 1.2), delta * 15)
				
				if Input.is_action_just_released("ClickL"):
					SelectButton(i);
			else:
				sprites[i].modulate = Color(0.6, 0.6, 0.6)
				sprites[i].scale = lerp(sprites[i].scale, Vector2(1, 1), delta * 15)
	else:
		for i in sprites.size():
			sprites[i].modulate = Color(0.6, 0.6, 0.6)
			sprites[i].scale = lerp(sprites[i].scale, Vector2(1, 1), delta * 15)
	pass
	
func SelectButton(button):
	isActive = false;
	get_node("CanvasLayer/Transition").start(true);
	await get_tree().create_timer(0.5).timeout
	
	match button:
		0:
			get_tree().change_scene_to_file("res://Scenes/GameScenes/InfoMenu.tscn")
		1:
			get_tree().change_scene_to_file("res://Scenes/GameScenes/IntroMenu.tscn")
		2:
			get_tree().change_scene_to_file("res://Scenes/GameScenes/LevelMenu.tscn")
	pass
