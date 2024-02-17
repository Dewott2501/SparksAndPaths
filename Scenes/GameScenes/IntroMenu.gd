extends Node2D
var shake = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	#look at EndingMenu.gd comments
	await get_tree().create_timer(0.5).timeout
	var tween = get_tree().create_tween();
	tween.tween_property($Cam, "zoom", Vector2(1, 1), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	await get_tree().create_timer(1).timeout
	var tween2 = get_tree().create_tween();
	tween2.tween_property($CanvasLayer/white, "color", Color(1, 1, 1, 0.6), 2).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	var tween3 = get_tree().create_tween();
	tween3.tween_property($Cam, "zoom", Vector2(1.1, 1.1), 2).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	await get_tree().create_timer(2).timeout
	var tween4 = get_tree().create_tween();
	tween4.tween_property($Cam, "zoom", Vector2(1, 1), 2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	shake = 0.4;
	$CanvasLayer/white.color = Color(0, 0, 0, 0);
	$Cut1.visible = true;
	await get_tree().create_timer(3).timeout
	var tween5 = get_tree().create_tween();
	tween5.tween_property($CanvasLayer/white, "color", Color(0, 0, 0, 1), 1)
	Music.FadeSong(false);
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Scenes/GameScenes/S1.tscn")
	pass # Replace with function body.
	
func _process(delta):
	if(shake > 0):
		shake -= delta;
		var rng = RandomNumberGenerator.new()
		$Cam.position = Vector2(rng.randf_range(-6, 6), rng.randf_range(-6, 6))
	else:
		shake = 0;
		$Cam.position = Vector2(0, 0)
	pass
