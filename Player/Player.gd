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
onready var leg_ray: RayCast = $LegRayCast
onready var interaction_ray: RayCast = $Head/Camera/InteractionRayCast
onready var carry_object_pos: Position3D = $Head/Camera/CarryObjectPosition

# use this variable instead of the is_on_floor() function 
# to prevent sliding from slopes: 
var is_on_floor: bool = false

var carry_object: PickUpObject = null

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


func _process(delta: float) -> void:
	check_floor()
	carry_object()


func _physics_process(delta: float) -> void:
	match state:
		States.WALK:
			walk(delta)
		States.FLY:
			fly(delta)


func carry_object() -> void:
	if not carry_object:
		if interaction_ray.is_colliding() and Input.is_action_just_pressed("mouse_action"):
			var obj: Object = interaction_ray.get_collider()
			if obj is PickUpObject:
				carry_object = obj
				carry_object.pick_up(self)


	else:
		if Input.is_action_just_pressed("mouse_action"):
			carry_object.release()
			carry_object = null


"""
Checks if player is on ground
"""
func check_floor() -> void:
	if leg_ray.is_colliding():
		var obj: Object = leg_ray.get_collider()
		is_on_floor = true
	else:
		is_on_floor = false


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
Set new velocity based on player input
"""
func set_velocity(delta: float, aim: Basis, gravity: float, speed: float, accel: float) -> void:
	var direction: Vector3 = Vector3.ZERO

	if !is_on_floor:
		velocity.y += gravity
	
	
	if Input.is_action_pressed("move_forward"):
		direction -= aim.z
	elif Input.is_action_pressed("move_backward"):
		direction += aim.z
	if Input.is_action_pressed("strafe_left"):
		direction -= aim.x
	elif Input.is_action_pressed("strafe_right"):
		direction += aim.x
	
	direction = direction.normalized()

	
	if Input.is_action_just_pressed("move_jump") and is_on_floor:
		direction.y += JUMP_FORCE	
	
	var target: Vector3 = direction * speed
	velocity = velocity.linear_interpolate(target, accel * delta) 