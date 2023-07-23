extends Node3D

var opened = false

func open(key_count):
	if key_count > 0 and not opened:
		opened = true
		$OpenDoorPlayer.play()
		return key_count-1
	elif not opened and key_count == 0:
		$LockedDoorPlayer.play()
		return key_count
	else:
		return key_count


func _on_open_door_player_finished():
	$AnimationPlayer.play("open")
