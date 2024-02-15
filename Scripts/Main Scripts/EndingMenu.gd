extends Node2D
# Called when the node enters the scene tree for the first time.
func _ready():
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
	pass # Replace with function body.
