extends Node2D

@onready var spirits : Array = get_tree().get_nodes_in_group("BlueS");
@onready var EVILspirits : Array = get_tree().get_nodes_in_group("PurpleS");
@onready var sound = get_tree().get_current_scene().get_node("SFX");
@onready var signL : Array = [];
@onready var signSp : Array = []
@onready var light : Array = [];
@onready var finishSp = $CanvasLayer/FinishSp
@onready var click = $click
var sigCos = 0;
#@onready var lamp = $Lamp/Body
var grab = false;
var LOOK = false;
var dist = 0;
var maxvel = 3;
var clickCooldown = 0;
var finished = false;
var curLamp = "";
# Called when the node enters the scene tree for the first time.
func _ready():
	var lamps = get_tree().get_nodes_in_group("Lamp")
	for i in lamps.size():
		signL.append(lamps[i].get_node("sign"))
		signSp.append(lamps[i].get_node("Lamp/Body/Sprite2D"))
		light.append(lamps[i].get_node("sign/Light"))
	var rng = RandomNumberGenerator.new()
	sigCos = rng.randi_range(-2, 4)
	pass # Replace with function body.
	
func updateSpirits():
	spirits = get_tree().get_nodes_in_group("BlueS");
	if(spirits.size() <= 0):
		endLv();
	pass

#func _input(event):
	#if event is InputEventMouseMotion:
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(!finished):
		if Input.is_action_just_pressed("debugKey"):
			endLv()
		if Input.is_action_just_pressed("Mute"):
			if(Music.volume_db == -15): Music.volume_db = -80;
			else:  Music.volume_db = -15;
		var mouse = get_global_mouse_position();
		var postAr = [];
		for i in signL.size():
			postAr.append([signL[i].global_position.distance_to(mouse), signL[i].get_parent().name])
		postAr.sort()
		#print(postAr);
		dist = postAr[0][0];
		
		for i in signSp.size():
			var spScale = 0.54;
			if(dist < 100 && postAr[0][1] == signL[i].get_parent().name):
				spScale = 0.6;
			else:
				spScale = 0.54;
			signSp[i].scale = lerp(signSp[i].scale, Vector2(spScale, spScale), delta * 10)
		
		for p in signL.size():
			if(signL[p].get_parent().name == postAr[0][1]):
				if Input.is_action_just_pressed("ClickL"):
					dist = signL[p].global_position.distance_to(mouse);
					if(dist < 100):
						curLamp = signL[p].get_parent().name;
						sound.playsound("grab", 1)
						grab = true;
						LOOK = true;
					
				if Input.is_action_just_released("ClickL"):
					if(grab): 
						grab = false;
						sound.playsound("drop", 1)
					
		if grab:
			changeMouse("grab")
			for p in signL.size():
				if(signL[p].get_parent().name == curLamp):
						var mospos = get_viewport().get_mouse_position();
						var winSize = get_viewport().size
						if(mospos > Vector2(0, 0) && mospos < Vector2(winSize) && mospos.y > 0 && mospos.y < winSize.y): 
							signL[p].global_position = signL[p].global_position.lerp(mouse, delta * 10);

			for i in spirits.size():
				spirits[i].startFind(curLamp)
		else:
			changeMouse("select")
			
			
		if(clickCooldown > 0): clickCooldown -= delta;
		else: clickCooldown = 0;	
			
		if Input.is_action_just_released("ClickR"):
			var spDistance : Array = [];
			for i in spirits.size():
				spDistance.append([spirits[i].position.distance_to(mouse), i])
		
			spDistance.sort() #get closest one
			if(spDistance[0][0] < 90):
				var who = spDistance[0][1]
				if(clickCooldown > 0): spirits[who].stuntSpirit()
				clickCooldown = 0.5;
		
	sigCos += delta * 20; 
	var ligFinal = 0.8 + (sin(sigCos) / 20)
	for i in light.size():
		light[i].energy = ligFinal
	if(click != null):
		click.scale = Vector2(1 + (sin(sigCos / 5) / 20), 1 + (sin(sigCos / 5) / 20))
		
	if(LOOK && click != null):
		click.modulate.a = lerpf(click.modulate.a, 0, delta * 10)

func changeMouse(spr):
	var offset = Vector2(0, 0)
	match spr:
		"select": offset = Vector2(6, 4)
		"grab": offset = Vector2(22, 16)
		
	Input.set_custom_mouse_cursor(load("res://Sprites/mouse/" + spr + ".png"), Input.CURSOR_ARROW, offset)
	
func endLv():
	EVILspirits = get_tree().get_nodes_in_group("PurpleS");
	for i in EVILspirits.size():
		var tween = get_tree().create_tween();
		tween.tween_property(EVILspirits[i], "modulate", Color(1, 1, 1, 0), 1)
		var tween2 = get_tree().create_tween();
		tween2.tween_property(EVILspirits[i].get_child(1), "energy", 0, 1)
		tween.tween_callback(EVILspirits[i].queue_free)
	
	finished = true;
	changeMouse("select")
	finishSp.finishLevel()
	pass
	
