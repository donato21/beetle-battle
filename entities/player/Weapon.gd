extends Node2D

var damage = 0
var attack_speed = 0
var attack_duration = 0
var armor_piercing = 0
var can_attack = true

func _ready():
	damage = get_parent().get_parent().damage
	attack_speed = get_parent().get_parent().attack_speed
	armor_piercing = get_parent().get_parent().armor_piercing
	attack_duration = get_parent().get_parent().attack_duration
	$DurationTimer.set_wait_time(attack_duration)
	$AttackTimer.set_wait_time(attack_speed)

func attack():
	if can_attack:
		$Area2D/CollisionShape2D.set_disabled(false)
		$DurationTimer.start()

func _on_DurationTimer_timeout():
	$Area2D/CollisionShape2D.set_disabled(true)
	can_attack = false
	$AttackTimer.start()


func _on_AttackTimer_timeout():
	can_attack = true
