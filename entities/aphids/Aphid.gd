extends KinematicBody2D

var predators = []

var vel = Vector2.ZERO
var speed = 150
var friction = 0.3

var new_idle = true
var idle_move_time = 0.0
var idle_move_rot = 0.0
var idle_move_speed = 0

var scared = false
var fear_timer = 3

func _ready():
	$FearTimer.set_wait_time(fear_timer)

func _process(delta):
	if predators.size() > 0:
		run()
	else:
		idle()

func _on_DetectArea_body_entered(body):
	if body != self:
		predators.push_front(body)

func _on_DetectArea_body_exited(body):
	if body != self:
		predators.erase(body)

func idle():
	vel = move_and_slide(vel.linear_interpolate(Vector2.ZERO, friction))
	if scared:
		vel = move_and_slide((Vector2.UP * speed).rotated(rotation))
	else:
		if new_idle:
			new_idle = false
			idle_move_time = rand_range(0.5, 2)
			idle_move_rot = rand_range(0, 2*PI)
			idle_move_speed = rand_range(0, speed)
			rotation = idle_move_rot
			$IdleTimer.set_wait_time(idle_move_time)
			$IdleTimer.start()
		else:
			vel = move_and_slide((Vector2.UP * idle_move_speed).rotated(idle_move_rot))

func run():
	var targets = []
	new_idle = true
	for predator in predators:
		targets.push_back([predator, position.distance_to(predator.position)])
	for target in targets:
		if target[1] < targets.front()[1]:
			targets.push_front(targets.pop_at(targets.find(target)))
	rotation = position.angle_to_point(targets.front()[0].position) + 0.5 * PI
	vel = move_and_slide((Vector2.UP * speed).rotated(rotation))
	$FearTimer.start()
	scared = true

func hit():
	print("Aphid("+name+"): YEOUCH!!!")

func _on_Timer_timeout():
	new_idle = true

func _on_FearTimer_timeout():
	scared = false
