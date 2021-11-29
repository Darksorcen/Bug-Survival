extends KinematicBody2D


var Bullet = preload("res://src/scenes/Bullet.tscn")
var Weapon = preload("res://src/scripts/weapon.gd")
onready var Main = get_parent()
export var SPEED = 500
export var bullet_speed = 1000
var bullet_timer = true
export var bullet_timer_wait_time = 0.8
var bugillness = 0
var enemy_collide = false
var weapons = {
	"pistol":Weapon.new(10),
	"shotgun":Weapon.new(50),
	"submachine_gun":Weapon.new(4),
}
var current_weapon = "pistol"
var bugillness_changed = false
var score = 0
var next_score = 0

var shootsfx_list = [
	preload("res://src/assets/audio/sfx/sfx1.wav"),
	preload("res://src/assets/audio/sfx/sfx2.wav"),
	preload("res://src/assets/audio/sfx/sfx3.wav"),
	preload("res://src/assets/audio/sfx/sfx4.wav"),
	preload("res://src/assets/audio/sfx/sfx5.wav")
]

signal hit
signal add_score
signal set_damage

	
func _process(delta):
	check_bugillness()
	check_score()


func _physics_process(delta):
	var velocity = Vector2()
	
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_just_pressed("test"):
		if current_weapon == "pistol":
			change_weapon("shotgun")
			bullet_timer_wait_time = 1.0
		elif current_weapon == "shotgun":
			change_weapon("submachine_gun")
			bullet_timer_wait_time = 0.2
		elif current_weapon == weapons.keys()[-1]:
			change_weapon("pistol")
			bullet_timer_wait_time = 0.4
		
	velocity = velocity.normalized() 
	velocity = move_and_slide(velocity * SPEED)
	look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("LMB") and bullet_timer == true:
		fire()
		bullet_timer = false
		
	

func fire():
	$ShootSFX.stream = shootsfx_list[ randi() % 5]
	$ShootSFX.play()
	var bullet_instance = Bullet.instance()
	bullet_instance.position = $Weapon.get_global_position()
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.apply_impulse(Vector2(), Vector2(bullet_speed, 0).rotated(rotation))
	Main.call_deferred("add_child", bullet_instance)
	$BulletTimer.start(bullet_timer_wait_time)
	

func check_bugillness():
	if enemy_collide:
		bugillness += 0.5
		bugillness_changed = true
		emit_signal("hit", bugillness)
		if bugillness > 100:
			kill()
	if bugillness_changed:
		emit_signal("hit", bugillness)
			
	
func check_score():
	if score == next_score:
		emit_signal("add_score", score)
		next_score += 1
			
	
func kill():
	get_tree().change_scene("res://src/scenes/Menu.tscn")
	
		
func _on_BulletTimer_timeout():
	bullet_timer = true
	
	
func _on_Area2D_body_entered(body):
	if "Enemy" in body.name:
		enemy_collide = true


func _on_Area2D_body_exited(body):
	if "Enemy" in body.name:
		enemy_collide = false
	
	
func change_weapon(weapon_name):
	var weapon = weapons[weapon_name]
	current_weapon = weapon_name
	$Weapon.set_texture(weapon.get_image(weapon_name))
	get_tree().call_group("enemies", "set_damage", weapon.get_damage())
	
	
