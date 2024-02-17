extends AudioStreamPlayer

var volume = -15;

func changeSong(song : String):
	stream = load("res://Audio/Music/" + song + ".wav")
	playing = true;
	pass
func FadeSong(isEnter : bool):
	if(isEnter): volume = -15; 
	else: volume = -85;
	
func _process(delta):
	if Input.is_action_just_pressed("Mute"):
		AudioServer.set_bus_mute(1, !AudioServer.is_bus_mute(1))
		
	if(volume_db != volume):
		if(volume < volume_db):
			volume_db = lerpf(volume_db, volume, delta * 0.5);
		else:
			volume_db = lerpf(volume_db, volume, delta * 4);
	 
	
