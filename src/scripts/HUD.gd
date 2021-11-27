extends CanvasLayer




func _on_Player_hit(bugillness):
	$BugIllnessBar.value = bugillness
	$"/root/Main/Player".bugillness_changed = false
	

func _on_Player_add_score(score):
	$Score.text = str(score)


func _on_SpawnManager_show_text_wave():
	$WaveText.show()
	

func _on_SpawnManager_hide_text_wave():
	$WaveText.hide()
