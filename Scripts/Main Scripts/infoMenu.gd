extends Node2D

@onready var sprites = [$CanvasLayer/Next/R0, $CanvasLayer/Back/R0, $CanvasLayer/Home/R0];
@onready var sound = get_tree().get_current_scene().get_node("SFX");
var isActive = true;
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in sprites.size():
		sprites[i].modulate = Color(0.6, 0.6, 0.6)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Mute"):
		if(Music.volume_db == -15): Music.volume_db = -80;
		else:  Music.volume_db = -15;
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
	pass
	
func SelectButton(button):
	
	match button:
		0:
			sound.playsound("selectmenu", 1, 1.3)
			$P1.visible = false;
			$P2.visible = true;
			sprites[0].get_parent().visible = false;
			sprites[1].get_parent().visible = true;
		1:
			sound.playsound("selectmenu", 1, 1.3)
			$P1.visible = true;
			$P2.visible = false;
			sprites[0].get_parent().visible = true;
			sprites[1].get_parent().visible = false;
		2:
			isActive = false;
			get_node("CanvasLayer/Transition").start(true);
			await get_tree().create_timer(0.5).timeout
			get_tree().change_scene_to_file("res://Scenes/GameScenes/TitleMenu.tscn")
	pass
