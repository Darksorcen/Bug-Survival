extends KinematicBody2D

export (PackedScene) var Enemy

onready var Player = get_node("/root/Main/Player")
var health = 20
signal dead
var damage = 10

func _ready():
	var damage_weapon = Player.weapons[Player.current_weapon].get_damage()
	set_damage(damage_weapon)
	set_physics_process(true)
	self.connect("dead", $"/root/Main/SpawnManager", "_on_Enemy_dead")


func _physics_process(delta):
	position += (Player.position - position)/(Player.position - position).length()*5
	look_at(Player.position)
	
	move_and_collide(Vector2())


func _on_Area2D_body_entered(body):
	if "Bullet" in body.name:
		health -= damage
		
	if health <= 0:
		$"/root/Main/Player".score += 1
		if $"/root/Main/Player".bugillness > 0:
			$"/root/Main/Player".bugillness -= 1
			$"/root/Main/Player".bugillness_changed = true
		emit_signal("dead")
		queue_free()
		

func choose_spawn(parent):
	var spawn = "SpawnManager/EnemySpawn"+str(randi() % 4 + 1)
	return parent.get_node(spawn).position


func set_damage(new_damage: int):
	damage = new_damage


