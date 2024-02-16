extends Node2D
var isActive = false;

@onready var hudPause = get_node("../HUD/Button/R0")

@onready var PauseButtons = [get_node("Button/R0"), get_node("Button2/R1"), get_node("Button3/R2")]
@onready var sound = get_tree().get_current_scene().get_node("SFX");

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(hudPause.ishovering):
		hudPause.modulate = Color(1.3, 1.3, 1.3)
		hudPause.scale = lerp(hudPause.scale, Vector2(1.2, 1.2), delta * 10)
		if Input.is_action_just_released("ClickL"):
			visible = true;
			hudPause.get_parent().visible = false;
			get_tree().paused = true;
			isActive = true;
			sound.playsound("flipPage", 1)
	else:
		hudPause.modulate = Color(1, 1, 1)
		hudPause.scale = lerp(hudPause.scale, Vector2(1, 1), delta * 10)
	if(isActive):
		for i in PauseButtons.size():
			if(PauseButtons[i].ishovering):
				if(PauseButtons[i].modulate == Color(0.6, 0.6, 0.6)):
					sound.playsound("hover", 1, 1.3)
				PauseButtons[i].modulate = Color(1, 1, 1)
				PauseButtons[i].scale = lerp(PauseButtons[i].scale, Vector2(1.2, 1.2), delta * 15)
				
				if Input.is_action_just_released("ClickL"):
					SelectButton(i);
			else:
				PauseButtons[i].modulate = Color(0.6, 0.6, 0.6)
				PauseButtons[i].scale = lerp(PauseButtons[i].scale, Vector2(1, 1), delta * 15)
			
	#pass
	
func SelectButton(button):
	isActive = false;
	match button:
		0:
			sound.playsound("pageOut", 1)
			visible = false;
			hudPause.get_parent().visible = true;
			get_tree().paused = false;
		1:
			get_node("../Transition").start(true);
			await get_tree().create_timer(0.5).timeout
			get_tree().paused = false;
			get_tree().reload_current_scene();
		2:
			get_node("../Transition").start(true);
			if(button == 2): Music.FadeSong(false)
			await get_tree().create_timer(0.5).timeout
			get_tree().paused = false;
			get_tree().change_scene_to_file("res://Scenes/GameScenes/LevelMenu.tscn")
	pass
