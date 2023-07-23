extends Node

@export var victory_music : AudioStreamMP3
@export var num_collectables = 0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$PlayerCharacter.set_physics_process(false)
	$PlayerCharacter.set_process_unhandled_input(false)
	
func _on_exit_body_entered(body):
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$AudioStreamPlayer.stop()
	$AudioStreamPlayer.stream = victory_music
	$AudioStreamPlayer.play()
	$VictorySoundPlayer.play()
	$PlayerCharacter.set_process_unhandled_input(false)
	$PlayerCharacter.set_physics_process(false)
	
	$UI/VictoryScreen/Completion.text = str($PlayerCharacter.collectable_count) + "/" + str(num_collectables) + " Collectables found!"
	if $PlayerCharacter.collectable_count == num_collectables:
		$UI/VictoryScreen/FullComplete.show()
	$UI/VictoryScreen.show()

func _on_player_character_collectable_picked_up():
	$CollectableSoundPlayer.play()

func _on_player_character_key_picked_up():
	$KeySoundPlayer.play()


func _on_play_pressed():
	$UI/StartScreen.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$PlayerCharacter.set_physics_process(true)
	$PlayerCharacter.set_process_unhandled_input(true)
