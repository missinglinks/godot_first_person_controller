extends RigidBody

class_name PickUpObject

var host: KinematicBody
var original_parent: Node


func _ready():
	original_parent = get_parent()

func pick_up(host: KinematicBody) -> void:
	original_parent.remove_child(self)
	host.camera.add_child(self)
	global_transform = host.carry_object_pos.global_transform	
	
func release() -> void:
	var current_global_transform = global_transform
	get_parent().remove_child(self)
	original_parent.add_child(self)
	global_transform = current_global_transform
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO