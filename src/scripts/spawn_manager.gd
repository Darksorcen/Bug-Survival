extends Node2D

var Enemy = preload("res://src/scenes/Enemy.tscn")
onready var Enemies = $"/root/Main/Enemies"
onready var Main = get_parent()
var enemy_dead = 0
var wave = 1
var stop_wave = false
var in_passing_wave = false

signal show_text_wave
signal hide_text_wave

func _process(delta):
	if in_passing_wave:
		$"/root/Main/HUD/WaveText".text = "Time left : "+str(round($WaveTimer.get_time_left()))


func _on_EnemyTimer_timeout():
	if stop_wave and Enemies.get_child_count() == 0:
		stop_wave = false
		emit_signal("show_text_wave")
		in_passing_wave = true
		$WaveTimer.set_wait_time(20)
		$WaveTimer.start()
		yield($WaveTimer, "timeout")
		in_passing_wave = false
		emit_signal("hide_text_wave")
	
	if not in_passing_wave and not stop_wave:
		var enemy_instance = Enemy.instance()
		enemy_instance.position = enemy_instance.choose_spawn(Main)
		Enemies.add_child(enemy_instance)
	

func _on_Enemy_dead():
	enemy_dead += 1
	if enemy_dead == 20+wave*5:
		enemy_dead = 0
		wave += 1
		stop_wave = true
		var EnemyTimer = get_node("/root/Main/EnemyTimer")
		EnemyTimer.set_wait_time(EnemyTimer.get_wait_time()-0.1)
