extends ColorRect

export var viewport: NodePath
export var target: NodePath

onready var viewport_camera = $FlatColorViewport/ViewportCamera

var vp: Viewport
var target_node: Camera

func _ready():
	vp = get_node(viewport)
	viewport_camera.target = get_node(target).camera
	
	#set viewport texture as shader input
	material.set_shader_param("outline", vp.get_texture())
