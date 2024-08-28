extends Sprite2D

@onready var sprites = [$Button/R0, $Button2/R1, $Button3/R2];
var useButtons = false;
var son = [false, false, false];
var rotCon = 0;
var canContinue = false;
@onready var sound = get_tree().get_current_scene().get_node("SFX");
# Called when the node enters the scene tree for the first time.
func _ready():
	toggleButtons(false);
	pass # Replace with function body.

func toggleButtons(turn):
	useButtons = turn;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if(useButtons):
		for i in sprites.size():
			var cont = true;
			if(i == 1 && !canContinue): cont = false
			if(sprites[i].ishovering && cont):
					if !son[i]:
						sound.playsound("hover", 1, 1.3)
						son[i] = true;
					var proper = [Color(1.4, 1.4, 1.4), Vector2(1.2, 1.2)]
					if Input.is_action_pressed("ClickL"):
						proper = [Color(0.3, 0.3, 0.3), Vector2(0.9, 0.9)]
					sprites[i].modulate = lerp(sprites[i].modulate, proper[0], delta * 10)
					sprites[i].scale = lerp(sprites[i].scale, proper[1], delta * 10)
					
					rotCon += delta * 5;
					sprites[i].rotation_degrees = lerpf(sprites[i].rotation_degrees, sin(rotCon) * 5, delta * 10)
					
					if Input.is_action_just_released("ClickL"):
						selectOption(i)
			else:
				if(cont):
					son[i] = false;
					sprites[i].modulate = lerp(sprites[i].modulate, Color(1, 1, 1), delta * 10)
					sprites[i].scale = lerp(sprites[i].scale, Vector2(1, 1), delta * 10)
					sprites[i].rotation_degrees = lerpf(sprites[i].rotation_degrees, 0, delta * 10)
				else:
					sprites[i].modulate = lerp(sprites[i].modulate, Color(0.5, 0.5, 0.5), delta * 10)
					sprites[i].scale = lerp(sprites[i].scale, Vector2(1, 1), delta * 10)
					sprites[i].rotation_degrees = lerpf(sprites[i].rotation_degrees, 0, delta * 10)					
	else:
		for i in sprites.size():
			sprites[i].modulate = lerp(sprites[i].modulate, Color(0.5, 0.5, 0.5), delta * 10)
			sprites[i].scale = lerp(sprites[i].scale, Vector2(1, 1), delta * 10)
			sprites[i].rotation_degrees = lerpf(sprites[i].rotation_degrees, 0, delta * 10)
			
	pass

func finishLevel():
	get_node("../HUD").visible = false;
	await get_tree().create_timer(0.5).timeout
	visible = true;
	
	var exit = get_tree().get_nodes_in_group("Exit")[0]
	
	var amounts = [exit.sp1, exit.sp2, exit.sp3, exit.curSpirits]
	var Rtext = $ResultText;
	var diamonds = get_tree().get_nodes_in_group("Diamonds")
	if(amounts[3] >= amounts[0]): 
		Rtext.text = "[center]Level Completed!"
		canContinue = true;
	
	for i in diamonds.size():
		diamonds[i].get_child(0).text = "[center]" + str(amounts[3]) + " / " + str(amounts[i])
	
	var tween = get_tree().create_tween();
	tween.tween_property(self, "position", Vector2(position.x, 345), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	
	var tween2 = get_tree().create_tween();
	tween2.tween_property(get_node("../ColorRect"), "color", Color(0, 0, 0, 0.3), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	
	await get_tree().create_timer(0.8).timeout
	var totalgems = 0;
	for i in diamonds.size():
		if(amounts[i] <= amounts[3]):
			totalgems += 1;
			await get_tree().create_timer(0.4).timeout
			sound.playsound("dmGet", pow(2, (i*2)/12.0))
			diamonds[i].frame = 1;
			diamonds[i].get_child(0).visible = false;
			
			diamonds[i].scale = Vector2(1.2 + (i * 0.2), 0.8 + (i * 0.2));
			diamonds[i].modulate = Color(3, 3, 3);
			
			
			var p = load("res://Scenes/GameAssets/Particles/particleGREEN.tscn");
			var ins = p.instantiate();
			ins.modulate = Color(0.6, 1, 0.6);
			diamonds[i].add_child(ins);
			
			
			var tween3 = get_tree().create_tween();
			tween3.tween_property(diamonds[i], "rotation_degrees", 0, 0.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
			var tween4 = get_tree().create_tween();
			tween4.tween_property(diamonds[i], "scale", Vector2(1, 1), 0.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
			var tween5 = get_tree().create_tween();
			tween5.tween_property(diamonds[i], "modulate", Color(1, 1, 1), 0.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	
	var sceneName = str(get_tree().current_scene.name);
	if(SaveData.saveVal[int(sceneName) - 1] <= totalgems):
		SaveData.saveVal[int(sceneName) - 1] = totalgems;
	await get_tree().create_timer(0.6).timeout
	
	toggleButtons(true);
	
	pass
	
func selectOption(op):
	useButtons = false;
	var tra = get_node(("../Transition"))
	tra.start(true)
	var sceneName = str(get_tree().current_scene.name);
	var numb = int(sceneName) + 1
	if(op == 2 || numb >= 11 || numb == 6): Music.FadeSong(false)
	await get_tree().create_timer(0.5).timeout
	match op:
		0:
			get_tree().reload_current_scene();
		1:
			print("siguiente nivel")
			if(numb >= 11):
				get_tree().change_scene_to_file("res://Scenes/GameScenes/EndingMenu.tscn")
				return;
			get_tree().change_scene_to_file("res://Scenes/GameScenes/S"+ str(numb) +".tscn")
		2:
			get_tree().change_scene_to_file("res://Scenes/GameScenes/LevelMenu.tscn")
