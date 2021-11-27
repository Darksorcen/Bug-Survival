extends Sprite

var weapons_image = {
	"pistol":preload("res://src/assets/images/pistol.png"),
	"shotgun":preload("res://src/assets/images/shotgun.png"),
	"submachine_gun":preload("res://src/assets/images/submachine_gun.png"),
}
var damage = 0
func _init(dmg):
	damage = dmg
	

func get_damage():
	return damage
	

func get_image(weapon_name):
	return weapons_image[weapon_name]
	

	
