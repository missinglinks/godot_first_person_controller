extends KinematicBody

const GRAVITY: float = -0.98 * 2 

const FLY_SPEED = 50
const FLY_ACCEL = 4

const WALK_SPEED = 10
const WALK_ACCEL = 8

const JUMP_FORCE: float = 30.0

enum States { WALK,  FLY }
var state: int 

var pitch: float = 0
var mouse_sensitivity: float = 0.3

var velocity: Vector3 = Vector3.ZERO

onready var camera: Camera = $Head/Camera
onready var head: Spatial = $Head


func _ready() -> void:
	state = States.WALK


"""
Set player head/camera rotation based on mouse movement
"""
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var head_rotation: float = - event.relative.x * mouse_sensitivity
		head.rotate_y(deg2rad(head_rotation))
		var delta: float = -event.relative.y * mouse_sensitivity
		if pitch + delta < 90 && pitch + delta > -90:
			camera.rotate_x(deg2rad(delta))
			pitch += delta


func _physics_process(delta: float) -> void:
	match state:
		States.WALK:
			walk(delta)
		States.FLY:
			fly(delta)


"""
Handle walk state physics proccess
"""
func walk(delta: float) -> void:
	var aim: Basis = head.global_transform.basis
	set_velocity(delta, aim, GRAVITY, WALK_SPEED, WALK_ACCEL)
	velocity = move_and_slide(velocity, Vector3.UP)


"""
Handle fly state physics process
"""
func fly(delta: float) -> void:
	var aim: Basis = head.global_transform.basis
	set_velocity(delta, aim, 0, FLY_SPEED, FLY_ACCEL)
	velocity = move_and_slide(velocity, Vector3.UP)


"""
Calculate new velocity based on player input
"""
func set_velocity(delta: float, aim: Basis, gravity: float, speed: float, accel: float) -> void:
	var direction: Vector3 = Vector3.ZERO
	
	velocity.y += gravity
	
	if Input.is_action_pressed("move_forward"):
		direction -= aim.z
	elif Input.is_action_pressed("move_backward"):
		direction += aim.z
	if Input.is_action_pressed("strafe_left"):
		direction -= aim.x
	elif Input.is_action_pressed("strafe_right"):
		direction += aim.x
	
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		direction.y += JUMP_FORCE	
	
	var target: Vector3 = direction * speed
	velocity = velocity.linear_interpolate(target, accel * delta) 