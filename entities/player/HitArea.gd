extends Area2D

func _on_HitArea_area_entered(area):
	get_parent().hit()
