extends Area2D

@export var objectsToggle : Array = [];
@export var ExtraObj : Array = [];
@export var sameArea : Array = [];
@export var TotalRequired = 1;
@export var AreaColor : Color;
var p = load("res://Scenes/GameAssets/Particles/particleCube.tscn");
var amount = 0;
var animt = 0;
var unlock = false;
var altUnlock = false;
var trow = false;

func _ready():
	$Magic.modulate = AreaColor;
	
func _process(delta):
	if(animt > 2):
		animt = 0;
	elif(animt > 1):
		$Magic.frame = 1;
	else:
		$Magic.frame = 0;
	animt += delta * 4;
	
	var newFrame = (TotalRequired - amount) - 1;
	if(amount >= TotalRequired): 
		newFrame = 9;
		unlock = true;
	else: unlock = false;
	$Sprite2D.frame = newFrame;
	
	if(sameArea != null):
		for i in sameArea.size():
			#print(get_node(sameArea[i]).unlock);
			if(get_node(sameArea[i]).unlock):
				altUnlock = true;
			else: altUnlock = false;
	
	if(objectsToggle != null):
		for i in objectsToggle.size():
			var _node = get_node(objectsToggle[i])
			if(!unlock && !altUnlock):
				if(!_node.visible):
					_node.visible = true;
					spawnParticle(_node);
			else:
				if(_node.visible):
					_node.visible = false;
					spawnParticle(_node);
					
			if(unlock || altUnlock): _node.set_collision_layer(2)
			else: _node.set_collision_layer(1)
	
	if(ExtraObj != null):
		for i in ExtraObj.size():
			var extraArea = get_node(ExtraObj[i][1])
			var extraBox = get_node(ExtraObj[i][0])
			
			if(extraArea.amount >= extraArea.TotalRequired && (unlock || altUnlock)):
				if(extraBox.visible):
					extraBox.visible = false;
					spawnParticle(extraBox);
				extraBox.set_collision_layer(2)
			else: 
				if(!extraBox.visible):
					extraBox.visible = true;
					spawnParticle(extraBox);
				extraBox.set_collision_layer(1)

	pass # Replace with function body.

func spawnParticle(where):
	var ins = p.instantiate();
	var wSprite = where.get_child(0);
	add_child(ins);
	ins.global_position = where.global_position;
	ins.modulate = wSprite.modulate + Color(0.2, 0.2, 0.2)
	ins.scale = where.scale;
	ins.amount = ins.amount * (where.scale.x * 5);
	await(ins.finished)
	ins.queue_free();

func _on_body_entered(body):
	if(body.is_in_group("BlueS")):
		amount += 1;
	pass # Replace with function body.


func _on_body_exited(body):
	if(body.is_in_group("BlueS")):
		amount -= 1;
	pass # Replace with function body.
