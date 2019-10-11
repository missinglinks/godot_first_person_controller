extends Camera

var target: Spatial

func _process(delta: float) -> void:
	if target:
		global_transform = target.global_transform
