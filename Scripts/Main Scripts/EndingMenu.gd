extends Node2D
# Called when the node enters the scene tree for the first time.
func _ready():
	Music.changeSong("menu");
	Music.FadeSong(true);
	await get_tree().create_timer(0.5).timeout
	var tween = get_tree().create_tween();
	tween.tween_property($Canvas/white, "modulate", Color(1, 1, 1, 0), 1)
	var tween2 = get_tree().create_tween();
	tween2.tween_property($Cam, "zoom", Vector2(1, 1), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	await get_tree().create_timer(2).timeout
	
	var tween3 = get_tree().create_tween();
	tween3.tween_property($Cam, "position", Vector2($Cam.position.x, -300), 6).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	await get_tree().create_timer(6).timeout
	
	var CutSpr = [$PBG1/PL/she/Cut1, $PBG1/PL/she/Cut0]
	var tween4 = get_tree().create_tween();
	tween4.tween_property(CutSpr[0], "modulate", Color(1, 1, 1, 1), 1)
	var tween5 = get_tree().create_tween();
	tween5.tween_property(CutSpr[1], "modulate", Color(1, 1, 1, 0), 1)
	await get_tree().create_timer(3).timeout
	var tween6 = get_tree().create_tween();
	tween6.tween_property($Canvas/white, "modulate", Color(1, 1, 1, 1), 2);
	await get_tree().create_timer(3).timeout
	var tween7 = get_tree().create_tween();
	tween7.tween_property($Canvas/white, "modulate", Color(1, 1, 1, 0), 2);
	$PBG0/PL/Bg1.visible = true;
	$PBG1/PL/she/Cut2.visible = true;
	$PBG1/PL/she/Cut0.visible = false;
	$PBG1/PL/she/Cut1.visible = false;
	$PBG1/PL/she/Thanks.visible = true;
	await get_tree().create_timer(6).timeout
	var tween8 = get_tree().create_tween();
	tween8.tween_property($PBG1/PL/she/Thanks, "modulate", Color(1, 1, 1, 0), 2);
	var tween9 = get_tree().create_tween();
	tween9.tween_property($PBG1/PL/she/Cut2, "modulate", Color(1, 1, 1, 0), 2);
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://Scenes/GameScenes/TitleMenu.tscn")
	pass # Replace with function body.
