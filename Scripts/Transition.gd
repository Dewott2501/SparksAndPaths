extends ColorRect

@onready var _shader = material;
var tran = 0;
var newVal = 0;
@onready var sound = get_tree().get_current_scene().get_node("SFX");
# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(0.5).timeout
	start(false)
	pass # Replace with function body.

func start(the):
	if(the):
		sound.playsound("transitionEnd", 1)
		tran = 0;
	else: 
		sound.playsound("transitionStart", 1)
		tran = 1;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if(newVal >= 1): visible = false;
	#else: visible = true;
	newVal = lerpf(newVal, tran, delta * 5)
	_shader.set_shader_parameter('progress', newVal)
	pass
