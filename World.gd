extends Spatial

onready var player_camera: Camera = $Player.camera
onready var flat_color_camera: Camera = $PickUpOverlay/FlatColorViewport/ViewportCamera


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
