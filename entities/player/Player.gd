extends KinematicBody2D

var dir = Vector2.ZERO
var vel = Vector2.ZERO
var vel_rot = Vector2.ZERO
var acc = Vector2.ZERO

const speed = 50
const max_speed = 250
const friction = 0.2

var damage = 10
var attack_speed = .7
var attack_duration = .1
var armor_piercing = 2

func _ready():
	var timer = Timer.new()
	self.add_child(timer)
	timer.set_wait_time(1.0)
	timer.set_autostart(true)
	timer.start()
	timer.connect("timeout",self,"timeout")

func _physics_process(_delta):
	dir = Vector2.ZERO
	if Input.is_action_pressed("f"):
		dir.y = -1
	elif Input.is_action_pressed("b"):
		dir.y = 1
	if Input.is_action_pressed("r"):
		rotate(deg2rad(3))
	elif Input.is_action_pressed("l"):
		rotate(deg2rad(-3))
	if dir != Vector2.ZERO:
		vel += dir * speed
	vel =  lerpV2(vel, Vector2.ZERO, friction)
	vel.floor()
	if vel != Vector2.ZERO:
		vel_rot = move_and_slide(vel.rotated(rotation))

func lerpV2(start:Vector2 , end:Vector2, ratio:float):
	return Vector2(start.x + (end.x - start.x * ratio),start.y + (end.y - start.y * ratio))

func timeout():
	#print(dir)
	#print(vel)
	pass

func _input(event):
	if event.is_action_pressed("attack"):
		$WeaponNode.get_child(0).attack()

func hit():
	print("Player: Yeouch!!!")
