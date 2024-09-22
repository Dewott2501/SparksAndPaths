extends CharacterBody2D

@onready var Nav : NavigationAgent2D = $NavAG;
@onready var sprite : Sprite2D = $Sprite2D/Sprite2D;
@onready var light : Light2D = $Light;
@onready var anim : AnimationPlayer = $Sprite2D/Sprite2D/AnimationPlayer;
@onready var signL : Array = [];
@onready var sound = get_tree().get_current_scene().get_node("SFX");
var curtarget : Vector2 = Vector2(0,0);
var isRunning = false;
var offset = Vector2();
var newPos : Vector3;
@export var evil = false;
var curVel = 450;
var stunt = 0;
var ligCos = 0;
var ligOff : float = 80;
var shakeSprite = 0;
var evilTimer = 0;
var closedist = 0;
var safe = false;
var stuck = false;
# Called when the node enters the scene tree for the first time.
func _ready():
	light.enabled = false;
	if(evil):
		changeBand(true)
	var lamps = get_tree().get_nodes_in_group("Lamp")
	for i in lamps.size():
		signL.append(lamps[i].get_node("sign"))
		
	var rng = RandomNumberGenerator.new()
	ligCos = rng.randi_range(-2, 4)
	call_deferred("Csetup")
	pass # Replace with function body.

func Csetup():
	await get_tree().physics_frame
	
	##set_target(curtarget)
	
func set_target(mov: Vector2):
	var lastTarget = Nav.target_position;
	if(lastTarget.x == 0 && lastTarget.y == 0): lastTarget = position;
	Nav.target_position = mov + offset

	if(Nav.distance_to_target() > 700):
		Nav.target_position = lastTarget;
		curtarget = lastTarget;
		isRunning = false;
	else:
		isRunning = true;
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var postAr = [];
	for i in signL.size():
		postAr.append([signL[i].global_position.distance_to(position), signL[i].get_parent().name])
	postAr.sort()
	update_anim();
	if(!Nav.is_navigation_finished() && isRunning && stunt <= 0):
		set_target(curtarget)
		var vel: Vector2 = Nav.get_next_path_position() - global_position;
		vel = vel.normalized();
		vel = vel * curVel;
		#print(vel)
		velocity = velocity.lerp(vel, 5 * delta);
	else:
		isRunning = false;
		velocity = velocity.lerp(Vector2(0,0), 8 * delta);
	
	
	if(!evil):
		#if()
		if(!safe && postAr[0][0] > 400):
			sprite.modulate.g -= delta * 0.2;
		else:
			if sprite.modulate.g < 1: sprite.modulate.g += delta * 0.4;
		curVel = 750 * sprite.modulate.g 
	else: 
		if(evilTimer > 0): evilTimer -= delta;
		else: 
			var rng = RandomNumberGenerator.new()
			evilTimer = rng.randf_range(3.0, 6.0)
			var numb = 100;
			if(!isRunning):
				isRunning = true;
				curtarget = position + Vector2(rng.randi_range(numb * -1, numb), rng.randi_range(numb * -1, numb))
				set_target(curtarget)
			
		
	if sprite.modulate.g <= 0: 
		changeBand(true);
		
	if(stunt > 0): stunt -= delta;
	else: stunt = 0;
	
	ligCos += delta * 10; 
	var ligFinal = (ligOff / 100) + (sin(ligCos) / 20)
	light.energy = ligFinal
	#tween.tween_property(light, "texture_scale", 2.9, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	light.texture_scale = lerpf(light.texture_scale, 2.9, delta * 10)
	#print(sin(ligCos))
	#if Input.is_action_just_pressed("ui_down"):
		#velocity.x += 100
		
	if(shakeSprite > 0):
		shakeSprite -= delta;
		var rng = RandomNumberGenerator.new()
		var n = 8;
		sprite.position = Vector2(rng.randi_range(-n, n), rng.randi_range(-n, n))
	else: 
		shakeSprite = 0;
		sprite.position = Vector2(0, 0)
		
	move_and_slide()
	
	if(isRunning):
		if(velocity.x == 0 || velocity.y == 0): stuck = true;
		else: stuck = false;
	
func update_anim():
	var curAnim = "";
	if(evil):
		if(!isRunning): curAnim = "EvilIdle";
		else: curAnim = "EvilWalking";
	else:
		if(velocity.x > 0):
			curAnim = "Right";
		if(velocity.x < 0):
			curAnim = "Left";
			
		if(velocity.y > abs(velocity.x * 1.7)): curAnim = "Down";
		if(velocity.y < -(abs(velocity.x * 1.7))): curAnim = "Up";
		
		if(!isRunning): 
			curAnim = "Idle";
		if(stunt > 0): curAnim = "Stunt";
		
		if(stuck): curAnim = "Idle";
	anim.play(curAnim);

		
func changeBand(turningEVIL):
	if turningEVIL:
		evil = true;
		sprite.modulate.g = 1;
		add_to_group("PurpleS")
		remove_from_group("BlueS")
		sprite.texture = load("res://Sprites/Spirits/purpleSP.png")
		light.color = Color("4f00e49a");
		var tween = get_tree().create_tween()
		ligOff = 2000;
		light.texture_scale = 4;
		tween.tween_property(self, "ligOff", 80, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		shakeSprite = 0.3
		curVel = 450;
		
		var rng = RandomNumberGenerator.new()
		evilTimer = rng.randf_range(3.0, 6.0)
		sound.playsound("EVIL", rng.randf_range(0.9, 1.1), 0.6)
		var numb = 100;
		curtarget = position + Vector2(rng.randi_range(numb * -1, numb), rng.randi_range(numb * -1, numb))
		set_target(curtarget)
		get_tree().current_scene.updateSpirits()
		anim.play("EvilIdle");
	else:
		evil = false;
		sprite.modulate.g = 1;
		add_to_group("BlueS")
		remove_from_group("PurpleS")
		sprite.texture = load("res://Sprites/bluePH.png")
		light.color = Color("00ffff9a");
		
func stuntSpirit():
	if(stunt <= 0):
		var rng = RandomNumberGenerator.new()
		sound.playsound("squish", rng.randf_range(0.9, 1.1), 0.6)
		var p = load("res://Scenes/GameAssets/Particles/particle.tscn");
		var ins = p.instantiate();
		add_child(ins);
		stunt = 3;
		var tweenf = get_tree().create_tween()
		var tweenf2 = get_tree().create_tween()
		$Sprite2D.scale = Vector2(1.2, 0.6);
		$Sprite2D.modulate = Color("9401d7");
		tweenf.tween_property($Sprite2D, "scale", Vector2(1, 1), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		tweenf2.tween_property($Sprite2D, "modulate", Color(1, 1, 1), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		
		
		
func startFind(curLamp):
	var rng = RandomNumberGenerator.new()
	var numb = 200 * sqrt(rng.randf_range(0, 1));
	var thet = rng.randf_range(0, 1) * 2 * PI;
	offset = Vector2(numb * cos(thet), numb * sin(thet))
	#if(rng.randi_range(0, 1) > 0): offset.x = -offset.x
	#if(rng.randi_range(0, 1) > 0): offset.y = -offset.y
	var postAr = [];
	for i in signL.size():
		postAr.append([signL[i].global_position.distance_to(position), signL[i].get_parent().name])
	postAr.sort()
	for i in signL.size():
		if(postAr[0][1] == signL[i].get_parent().name && signL[i].get_parent().name == curLamp):
			curtarget = signL[i].global_position
			set_target(curtarget)
	#newPos = Vector3(sign.position.x + rng.randf_range(offset, offset * -1), sign.position.y + rng.randf_range(offset, offset * -1))
	
	pass


func _on_area_2d_area_entered(area):
	var aName = str(area.name)
	if(aName == "Exit"):
		area.lighting();
		remove_from_group("BlueS")
		get_tree().current_scene.updateSpirits()
		queue_free();
	if(aName.contains("SafeArea")):
		safe = true;
	pass # Replace with function body.



func _on_area_2d_area_exited(area):
	var aName = str(area.name)
	if(aName.contains("SafeArea")):
		safe = false;
	pass # Replace with function body.
