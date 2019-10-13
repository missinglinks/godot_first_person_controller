shader_type canvas_item;
render_mode blend_add;

uniform sampler2D outline: hint_albedo;


void fragment() {
		
	vec4 flat_ = texture(outline, UV);
	
	float radius = 0.002;
	float divider = 9.2;

	vec4 col = vec4(0);


	for (int i = 0; i< 15; i++) {
		
		col+= texture(outline, UV+vec2(radius,-0));
		col+= texture(outline, UV+vec2(-radius,0));
		col+= texture(outline, UV+vec2(0,0));
		
		col+= texture(outline, UV+vec2(-radius,-radius));
		col+= texture(outline, UV+vec2(radius,-radius));
		col+= texture(outline, UV+vec2(0,-radius));
		
		col+= texture(outline, UV+vec2(0,radius));
		col+= texture(outline, UV+vec2(-radius,radius));
		col+= texture(outline, UV+vec2(radius,radius));
		radius += 0.001;
	}
	
	col /= divider * 15.0;	

	COLOR = col - flat_;
}