extends Area2D

@onready var light = $Visual/PointLight2D;
@onready var sprite = $Visual/Ball;
@onready var sound = get_tree().get_current_scene().get_node("SFX");
var p = load("res://Scenes/GameAssets/Particles/particle.tscn");
var ligCos = 0;
@export var sp1 = 2;
@export var sp2 = 3;
@export var sp3 = 5;
@export var curSpirits = 0;
# Called when the node enters the scene tree for the first time.
func _ready():
	$Visual/Ball/AnimationPlayer.play("Idle");
	pass # Replace with function body.

func lighting():
	sound.playsound("getThere", 1 + (0.1 * curSpirits))
	curSpirits += 1;
	light.energy = 3;
	light.texture_scale = 4;
	sprite.scale = Vector2(1.1, 1.1);
	var rng = RandomNumberGenerator.new()
	light.rotation_degrees = rng.randi_range(-180, 180)
	var ins = p.instantiate();
	add_child(ins);
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	light.energy = lerpf(light.energy, 1, delta * 10);
	light.texture_scale = lerpf(light.texture_scale, 2.6, delta * 10)
	light.rotation_degrees = lerpf(light.rotation_degrees, 0, delta * 10)
	sprite.scale = lerp(sprite.scale, Vector2(1, 1), delta * 10)
	
	ligCos += delta * 10; 
	var ligFinal = 0.8 + (sin(ligCos) / 8)
	light.energy = ligFinal
	pass
