extends RigidBody2D


var HitParticles = preload("res://src/scenes/HitParticles.tscn")
var lifetime = null

var explosionsfx_list = [
	preload("res://src/assets/audio/sfx/explosion/explosion1.wav"),
	preload("res://src/assets/audio/sfx/explosion/explosion2.wav"),
	preload("res://src/assets/audio/sfx/explosion/explosion3.wav"),
	preload("res://src/assets/audio/sfx/explosion/explosion4.wav"),
	preload("res://src/assets/audio/sfx/explosion/explosion5.wav"),
]


func _process(delta):
	if position.x < -300 or position.y < -200:
		queue_free()
	elif position.x > 32900 or position.y > 1500:
		queue_free()
		
	if lifetime != null and lifetime <= 0:
		queue_free()
	elif lifetime != null:
		lifetime -= delta
		
	#$Particles2D.speed_scale = linear_velocity.length()


func _on_Area2D_body_entered(body):
	if "Enemy" in body.name:
		$ExplosionSFX.stream = explosionsfx_list[randi() % 5]
		$ExplosionSFX.play()
		linear_velocity = Vector2(0, 0)
		var hit_particles = HitParticles.instance()
		add_child(hit_particles)
		hit_particles.set_emitting(true)
		$Sprite.hide()
		$CollisionShape2D.set_deferred("disabled", true)
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
		$ExplosionParticles.hide()
		lifetime = $ExplosionParticles.lifetime
		
