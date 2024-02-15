extends Node2D

func playsound(thesound: String, pitch : float, volume : float = 1):
	var newSound : AudioStreamPlayer = AudioStreamPlayer.new();
	newSound.stream = load("res://Audio/SFX/" + thesound + ".ogg")
	newSound.pitch_scale = pitch;
	newSound.volume_db = log(volume) * 19; 
	add_child(newSound);
	newSound.play();
	await(newSound.finished)
	newSound.queue_free()
