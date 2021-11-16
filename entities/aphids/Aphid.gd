extends KinematicBody2D

var predators = []

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
	pass

func run():
	var targets = []
	for predator in predators:
		targets.push_back([predator, position.distance_to(predator.position)])
	for target in targets:
		if target[1] < targets.front()[1]:
			targets.push_front(targets.pop_at(targets.find(target)))
	var target_dir = targets.front()[0].rotation
	rotation = lerp(rotation, target_dir, 0.3)
	move_and_slide((Vector2.UP * 100).rotated(rotation))

func hit():
	print("Aphid("+name+"): YEOUCH!!!")
