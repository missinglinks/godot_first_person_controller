extends RigidBody

class_name PickUpObject

var host: KinematicBody
var original_parent: Node


func _ready():
	original_parent = get_parent()


"""
Picking up adds the current node as child to the player camera
and sets its global transform to the carry item position.
"""
func pick_up(host: KinematicBody) -> void:
	original_parent.remove_child(self)
	host.camera.add_child(self)
	global_transform = host.carry_object_pos.global_transform

"""
Sets visibility layer 3 to true. This layer is rendered in the 
overlay viewport.
"""
func set_layer_bits() -> void:
	$MeshInstance.set_layer_mask_bit(3, true);

"""
Reset visibility layer 3 to false
"""
func reset_layer_bits() -> void:
	$MeshInstance.set_layer_mask_bit(3, false);

"""
Removes node from player camera and resets it as a child of 
its original parent, but containing its current global 
position, but resets its velocity to zero.
"""
func release() -> void:
	var current_global_transform = global_transform
	get_parent().remove_child(self)
	original_parent.add_child(self)
	global_transform = current_global_transform
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
