extends Camera

var target: Spatial

func _process(delta: float) -> void:
	global_transform = target.global_transform