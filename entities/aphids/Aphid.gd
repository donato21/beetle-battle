extends KinematicBody2D

var predators = []
var vel = Vector2.ZERO
var speed = 150
var friction = 0.3

func _process(delta):
	if predators.size() <= 0:
		idle()
	else:
		run()

func _on_DetectArea_body_entered(body):
	if body != self:
		predators.push_front(body)

func _on_DetectArea_body_exited(body):
	if body != self:
		predators.erase(body)

func idle():
	vel = move_and_slide(vel.linear_interpolate(Vector2.ZERO, friction))
	pass

func run():
	var targets = []
	for predator in predators:
		targets.push_back([predator, position.distance_to(predator.position)])
	for target in targets:
		if target[1] < targets.front()[1]:
			targets.push_front(targets.pop_at(targets.find(target)))
	rotation = position.angle_to_point(targets.front()[0].position) + 0.5 * PI
	vel = move_and_slide((Vector2.UP * speed).rotated(rotation))

func hit():
	print("Aphid("+name+"): YEOUCH!!!")
